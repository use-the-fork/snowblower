from __future__ import annotations

import importlib
import inspect
import pkgutil
from pathlib import Path
from typing import TYPE_CHECKING, Any
from rich import print

from snowblower_cli.generators.languages.core import AllLanguages
from snowblower_cli.logger import logger

if TYPE_CHECKING:
    from snowblower_cli.config.parser import SnowBlowerConfig
    from snowblower_cli.generators.base import BaseGenerator

class GeneratorOutput:
    """Container for generator outputs."""

    def __init__(self) -> None:
        """Initialize the generator output container."""
        self.config = {}

    def all(self) -> dict[str, Any]:
        """Retrieve all items in the store.
        
        Returns:
            A dictionary containing all stored items
        """
        return self.config

    def add(self, key: str, value: Any) -> None:
        """Add an item to the repository.
        
        Supports dot notation for nested keys (e.g., 'nix.languages.python').
        
        Args:
            key: The key to store the value under, can use dot notation
            value: The value to store
        """
        parts = key.split('.')
        current = self.config
        
        # Navigate to the nested location
        for i, part in enumerate(parts[:-1]):
            if part not in current:
                current[part] = {}
            elif not isinstance(current[part], dict):
                current[part] = {}
            current = current[part]
                
        # Set the value at the final location
        current[parts[-1]] = value

    def get(self, key: str, default: Any = None) -> Any:
        """Retrieve a single item from the store.
        
        Supports dot notation for nested keys (e.g., 'nix.languages.python').
        
        Args:
            key: The key to retrieve, can use dot notation
            default: The default value to return if key is not found
            
        Returns:
            The stored value or the default value if not found
        """
        parts = key.split('.')
        current = self.config
        
        # Navigate through the nested structure
        for part in parts:
            if not isinstance(current, dict) or part not in current:
                return default
            current = current[part]
            
        return current

    def merge(self, data: dict[str, Any]) -> None:
        """Merge in other dictionaries with deep merge.
        
        Args:
            data: The dictionary to merge into the current store
        """
        def _deep_merge(target: dict, source: dict) -> dict:
            for key, value in source.items():
                if key in target and isinstance(target[key], dict) and isinstance(value, dict):
                    _deep_merge(target[key], value)
                else:
                    target[key] = value
            return target
            
        self.config = _deep_merge(self.config, data)

    def remove(self, key: str) -> None:
        """Remove an item from the store.
        
        Supports dot notation for nested keys (e.g., 'nix.languages.python').
        
        Args:
            key: The key to remove, can use dot notation
        """
        parts = key.split('.')
        current = self.config
        
        # Navigate to the parent of the item to remove
        for part in parts[:-1]:
            if not isinstance(current, dict) or part not in current:
                return
            current = current[part]
            
        # Remove the item if it exists
        if isinstance(current, dict) and parts[-1] in current:
            del current[parts[-1]]

    def set(self, data: dict[str, Any]) -> None:
        """Overwrite the entire repository's contents.
        
        Args:
            data: The new data to replace the current store with
        """
        self.config = data
    


class GeneratorManager:
    """Manager for all generators in the system."""

    def __init__(self, config: SnowBlowerConfig, working_dir: Path):
        """Initialize the generator manager.

        Args:
            config: The parsed SnowBlower configuration
            working_dir: The current working directory
        """
        self.config = config
        self.working_dir = working_dir
        self.generators: list[BaseGenerator] = []
        self.output = GeneratorOutput()

    def run_generators(self) -> bool:
        """Run all discovered generators.

        Returns:
            True if all generators ran successfully, False otherwise
        """
        
        pending_generator = GeneratorOutput()
        all_languages = AllLanguages(self.config)
        self.output = all_languages(pending_generator)

        return True


    def _dict_to_nix(self, data: dict, indent: int = 2) -> str:
        """Convert a dictionary to Nix format.
        
        Args:
            data: The dictionary to convert
            indent: The indentation level
            
        Returns:
            A string in Nix format
        """
        result = []
        spaces = " " * indent
        
        for key, value in data.items():
            if isinstance(value, dict):
                result.append(f"{spaces}{key} = {{\n{self._dict_to_nix(value, indent + 2)}\n{spaces}}};")
            elif isinstance(value, list):
                if all(isinstance(item, str) for item in value):
                    # Format as a list of strings
                    items = " ".join([f'"{item}"' for item in value])
                    result.append(f"{spaces}{key} = [{items}];")
                else:
                    # Format as a general list
                    items = "\n".join([f"{spaces}  {self._value_to_nix(item)}" for item in value])
                    result.append(f"{spaces}{key} = [\n{items}\n{spaces}];")
            elif isinstance(value, bool):
                result.append(f"{spaces}{key} = {str(value).lower()};")
            elif isinstance(value, (int, float)):
                result.append(f"{spaces}{key} = {value};")
            elif value is None:
                result.append(f"{spaces}{key} = null;")
            elif key == "package" and isinstance(value, str):
                # Special handling for package values
                result.append(f"{spaces}{key} = pkgs.{value};")
            else:
                result.append(f"{spaces}{key} = \"{value}\";")
                
        return "\n".join(result)
    
    def _value_to_nix(self, value: Any) -> str:
        """Convert a single value to Nix format.
        
        Args:
            value: The value to convert
            
        Returns:
            A string representation in Nix format
        """
        if isinstance(value, dict):
            return f"{{\n{self._dict_to_nix(value, 4)}\n  }}"
        elif isinstance(value, list):
            if all(isinstance(item, str) for item in value):
                items = " ".join([f'"{item}"' for item in value])
                return f"[{items}]"
            else:
                items = "\n".join([f"    {self._value_to_nix(item)}" for item in value])
                return f"[\n{items}\n  ]"
        elif isinstance(value, bool):
            return str(value).lower()
        elif isinstance(value, (int, float)):
            return str(value)
        elif value is None:
            return "null"
        elif isinstance(value, dict) and "key" in value and value["key"] == "package":
            return f"pkgs.{value['value']}"
        else:
            return f'"{value}"'
    
    def _generate_nix_config(self, data: dict) -> str:
        """Generate a complete Nix configuration file.
        
        Args:
            data: The configuration data
            
        Returns:
            A complete Nix configuration file as a string
        """
        # Convert boolean 'enabled' to 'enable' as per Nix convention
        def transform_enabled(d):
            if isinstance(d, dict):
                result = {}
                for k, v in d.items():
                    if k == 'enabled':
                        result['enable'] = v
                    elif isinstance(v, (dict, list)):
                        result[k] = transform_enabled(v)
                    else:
                        result[k] = v
                return result
            elif isinstance(d, list):
                return [transform_enabled(item) if isinstance(item, (dict, list)) else item for item in d]
            else:
                return d
        
        transformed_data = transform_enabled(data)
        
        # Create the Nix file content
        nix_content = f"""{{config, pkgs, ...}}: {{
{self._dict_to_nix(transformed_data, 2)}
}}
"""

        return nix_content

    def write_outputs(self) -> bool:
        """Write all generated outputs to their respective files.

        Returns:
            True if all outputs were written successfully, False otherwise
        """
        # Write Nix configuration
        if self.output.get('nix'):
            try:
                nix_config_path = self.working_dir / ".devcontainer" / "configuration.nix"
                # Ensure the directory exists
                nix_config_path.parent.mkdir(parents=True, exist_ok=True)
                
                # Generate Nix configuration
                nix_content = self._generate_nix_config(self.output.get('nix'))
                
                # Write to file
                with open(nix_config_path, 'w') as f:
                    f.write(nix_content)
                
                logger.info(f"Wrote Nix configuration to {nix_config_path}")
                
            except Exception as e:
                logger.error(f"Failed to write Nix configuration: {e}")
                return False

        return True
