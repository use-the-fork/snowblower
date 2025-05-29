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
