import json
from abc import ABC, abstractmethod
from dataclasses import dataclass
from enum import Enum, auto
from pathlib import Path
from typing import Any

import yaml


class FileType(Enum):
    """Supported file types for conversion."""

    JSON = auto()
    YAML = auto()
    TOML = auto()
    TEXT = auto()
    NIX = auto()


@dataclass
class FileHandlerInput:
    """Input data for file handlers.

    Attributes:
        file_path: Path to the file
        file_type: Type of file for conversion
        data: Dictionary of settings/data to be processed
    """

    file_name: str
    file_type: FileType
    data: dict[str, Any]

    def __init__(
        self,
        file_name: str,
        file_type: FileType,
        data: dict[str, Any] | None = None,
    ):
        self.file_name = file_name
        self.file_type = file_type
        self.data = data or {}


class FileHandler(ABC):
    """Base class for handling different file formats."""

    def __init__(self, file_path: str | Path | None = None):
        """Initialize the file handler.

        Args:
            file_path: Optional path to the file to read/write
        """
        self.file_path = Path(file_path) if file_path else None

    @abstractmethod
    def parse(self, content: str) -> dict[str, Any]:
        """Parse content string into a dictionary.

        Args:
            content: String content to parse

        Returns:
            Parsed dictionary
        """

    @abstractmethod
    def generate(self, data: dict[str, Any]) -> str:
        """Generate formatted string from dictionary.

        Args:
            data: Dictionary to convert to string

        Returns:
            Formatted string representation
        """

    def read_file(self, file_path: str | Path | None = None) -> dict[str, Any]:
        """Read and parse a file.

        Args:
            file_path: Path to file (overrides instance file_path if provided)

        Returns:
            Parsed dictionary from file

        Raises:
            FileNotFoundError: If file doesn't exist
        """
        path = Path(file_path) if file_path else self.file_path
        if not path:
            raise ValueError("No file path provided")

        if not path.exists():
            raise FileNotFoundError(f"File not found: {path}")

        with open(path) as f:
            content = f.read()

        return self.parse(content)

    def write_file(
        self,
        data: dict[str, Any],
        file_path: str | Path | None = None,
    ) -> None:
        """Write dictionary to a file.

        Args:
            data: Dictionary to write
            file_path: Path to file (overrides instance file_path if provided)

        Raises:
            ValueError: If no file path is provided
        """
        path = Path(file_path) if file_path else self.file_path
        if not path:
            raise ValueError("No file path provided")

        content = self.generate(data)

        with open(path, "w") as f:
            f.write(content)


class JsonHandler(FileHandler):
    """Handler for JSON files."""

    def parse(self, content: str) -> dict[str, Any]:
        """Parse JSON string into a dictionary."""
        return json.loads(content)

    def generate(self, data: dict[str, Any]) -> str:
        """Generate JSON string from dictionary."""
        return json.dumps(data, indent=2)


class YamlHandler(FileHandler):
    """Handler for YAML files."""

    def parse(self, content: str) -> dict[str, Any]:
        """Parse YAML string into a dictionary."""
        return yaml.safe_load(content)

    def generate(self, data: dict[str, Any]) -> str:
        """Generate YAML string from dictionary."""
        return yaml.dump(data, default_flow_style=False)


class TextHandler(FileHandler):
    """Handler for plain text files."""

    def parse(self, content: str) -> dict[str, Any]:
        """Parse text content into a dictionary.

        For text files, we store the content as a single string under the 'content' key.
        """
        return {"content": content}

    def generate(self, data: dict[str, Any]) -> str:
        """Generate text string from dictionary.

        For text files, we expect either a 'content' key with a string value,
        or a dictionary where each key-value pair represents a line in the file.
        """
        if "content" in data:
            return data["content"]

        # If no content key, treat each key-value pair as a line
        lines = []

        # Handle case where data is a list
        if isinstance(data, list):
            lines = data
        else:
            # Handle dictionary case
            for key, value in data.items():
                if value is True:
                    lines.append(key)
                elif value:
                    lines.append(f"{key} {value}")

        return "\n".join(lines)


class TomlHandler(FileHandler):
    """Handler for TOML files."""

    def parse(self, content: str) -> dict[str, Any]:
        """Parse TOML string into a dictionary."""
        try:
            import tomli

            return tomli.loads(content)
        except ImportError:
            try:
                import toml

                return toml.loads(content)
            except ImportError:
                raise ImportError(
                    "Neither 'tomli' nor 'toml' package is installed. Please install one of them to handle TOML files.",
                )

    def generate(self, data: dict[str, Any]) -> str:
        """Generate TOML string from dictionary."""
        try:
            import tomli_w

            return tomli_w.dumps(data)
        except ImportError:
            try:
                import toml

                return toml.dumps(data)
            except ImportError:
                raise ImportError(
                    "Neither 'tomli_w' nor 'toml' package is installed. Please install one of them to handle TOML files.",
                )


class NixHandler(FileHandler):
    """Handler for Nix files."""

    def parse(self, content: str) -> dict[str, Any]:
        """Parse Nix string into a dictionary.

        Note: This is a simplified parser and may not handle all Nix syntax.
        """
        # Parsing Nix is complex and would require a dedicated parser
        # This is a placeholder that returns an empty dict
        return {}

    def generate(self, data: dict[str, Any]) -> str:
        """Generate Nix string from dictionary."""
        return self._generate_nix_config(data)

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
                result.append(
                    f"{spaces}{key} = {{\n{self._dict_to_nix(value, indent + 2)}\n{spaces}}};",
                )
            elif isinstance(value, list):
                if all(isinstance(item, str) for item in value):
                    # Format as a list of strings
                    items = " ".join([f'"{item}"' for item in value])
                    result.append(f"{spaces}{key} = [{items}];")
                else:
                    # Format as a general list
                    items = "\n".join(
                        [f"{spaces}  {self._value_to_nix(item)}" for item in value],
                    )
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
                result.append(f'{spaces}{key} = "{value}";')

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
        if isinstance(value, list):
            if all(isinstance(item, str) for item in value):
                items = " ".join([f'"{item}"' for item in value])
                return f"[{items}]"
            items = "\n".join([f"    {self._value_to_nix(item)}" for item in value])
            return f"[\n{items}\n  ]"
        if isinstance(value, bool):
            return str(value).lower()
        if isinstance(value, (int, float)):
            return str(value)
        if value is None:
            return "null"
        if isinstance(value, dict) and "key" in value and value["key"] == "package":
            return f"pkgs.{value['value']}"
        return f'"{value}"'

    def _generate_nix_config(self, data: dict) -> str:
        """Generate a complete Nix configuration file.

        Args:
            data: The configuration data

        Returns:
            A complete Nix configuration file as a string
        """

        # Convert boolean 'enable' to 'enable' as per Nix convention
        def transform_enable(d):
            if isinstance(d, dict):
                result = {}
                for k, v in d.items():
                    if k == "enable":
                        result["enable"] = v
                    elif isinstance(v, (dict, list)):
                        result[k] = transform_enable(v)
                    else:
                        result[k] = v
                return result
            if isinstance(d, list):
                return [
                    transform_enable(item) if isinstance(item, (dict, list)) else item for item in d
                ]
            return d

        transformed_data = transform_enable(data)

        # Create the Nix file content
        nix_content = f"""{{config, pkgs, ...}}: {{
{self._dict_to_nix(transformed_data, 2)}
}}
"""

        return nix_content
