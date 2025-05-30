from __future__ import annotations

from pathlib import Path
from typing import TYPE_CHECKING, Any

from snowblower_cli.generators.languages.core import AllLanguages
from snowblower_cli.generators.shell_tools.core import AllShellTools
from snowblower_cli.logger import logger
from snowblower_cli.utils.file_handlers import (
    FileHandlerInput,
    FileType,
    JsonHandler,
    NixHandler,
    TextHandler,
    TomlHandler,
    YamlHandler,
)

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
        parts = key.split(".")
        current = self.config

        # Navigate to the nested location
        for i, part in enumerate(parts[:-1]):
            if part not in current or not isinstance(current[part], dict):
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
        parts = key.split(".")
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
        parts = key.split(".")
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
        pending_generator = all_languages(pending_generator)

        all_shell_tools = AllShellTools(self.config)
        self.output = all_shell_tools(pending_generator)

        return True

    def write_outputs(self) -> bool:
        """Write all generated outputs to their respective files.

        Returns:
            True if all outputs were written successfully, False otherwise
        """

        # Write workspace files
        if self.output.get("workspace") and self.output.get("workspace").get("files"):
            for file_type, file_input in self.output.get("workspace").get("files").items():
                if isinstance(file_input, FileHandlerInput):
                    try:
                        file_path = self.working_dir / file_input.file_name

                        # Create the appropriate handler based on file type
                        if file_input.file_type == FileType.JSON:
                            handler = JsonHandler()
                        elif file_input.file_type == FileType.YAML:
                            handler = YamlHandler()
                        elif file_input.file_type == FileType.TOML:
                            handler = TomlHandler()
                        elif file_input.file_type == FileType.TEXT:
                            handler = TextHandler()
                        elif file_input.file_type == FileType.NIX:
                            handler = NixHandler()
                        else:
                            logger.error(
                                f"Unsupported file type: {file_input.file_type}",
                            )
                            continue

                        # Generate content with auto-generated comment
                        content = handler.generate(file_input.data)
                        auto_comment = (
                            "# This file is auto-generated by SnowBlower. Do not edit manually.\n\n"
                        )

                        # Write to file
                        with open(file_path, "w") as f:
                            f.write(auto_comment + content)

                        logger.info(
                            f"Wrote {file_input.file_type.name} configuration to {file_path}",
                        )
                    except Exception as e:
                        logger.error(f"Failed to write {file_type} configuration: {e}")
                        return False

        # Write Nix configuration
        if self.output.get("nix"):
            try:
                nix_config_path = self.working_dir / ".devcontainer" / "configuration.nix"
                # Ensure the directory exists
                nix_config_path.parent.mkdir(parents=True, exist_ok=True)

                # Create a NixHandler to generate the configuration
                nix_handler = NixHandler()
                nix_content = nix_handler.generate(self.output.get("nix"))

                # Write to file
                with open(nix_config_path, "w") as f:
                    f.write(nix_content)

                logger.info(f"Wrote Nix configuration to {nix_config_path}")

            except Exception as e:
                logger.error(f"Failed to write Nix configuration: {e}")
                return False

        return True
