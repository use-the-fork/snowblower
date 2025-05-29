from abc import ABC, abstractmethod
import json
import yaml
from pathlib import Path
from typing import Any, Dict, Optional


class FileHandler(ABC):
    """Base class for handling different file formats."""

    def __init__(self, file_path: Optional[str | Path] = None):
        """Initialize the file handler.
        
        Args:
            file_path: Optional path to the file to read/write
        """
        self.file_path = Path(file_path) if file_path else None

    @abstractmethod
    def parse(self, content: str) -> Dict[str, Any]:
        """Parse content string into a dictionary.
        
        Args:
            content: String content to parse
            
        Returns:
            Parsed dictionary
        """
        pass
    
    @abstractmethod
    def generate(self, data: Dict[str, Any]) -> str:
        """Generate formatted string from dictionary.
        
        Args:
            data: Dictionary to convert to string
            
        Returns:
            Formatted string representation
        """
        pass
    
    def read_file(self, file_path: Optional[str | Path] = None) -> Dict[str, Any]:
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
            
        with open(path, "r") as f:
            content = f.read()
            
        return self.parse(content)
    
    def write_file(self, data: Dict[str, Any], file_path: Optional[str | Path] = None) -> None:
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
    
    def parse(self, content: str) -> Dict[str, Any]:
        """Parse JSON string into a dictionary."""
        return json.loads(content)
    
    def generate(self, data: Dict[str, Any]) -> str:
        """Generate JSON string from dictionary."""
        return json.dumps(data, indent=2)


class YamlHandler(FileHandler):
    """Handler for YAML files."""
    
    def parse(self, content: str) -> Dict[str, Any]:
        """Parse YAML string into a dictionary."""
        return yaml.safe_load(content)
    
    def generate(self, data: Dict[str, Any]) -> str:
        """Generate YAML string from dictionary."""
        return yaml.dump(data, default_flow_style=False)


class TomlHandler(FileHandler):
    """Handler for TOML files."""
    
    def parse(self, content: str) -> Dict[str, Any]:
        """Parse TOML string into a dictionary."""
        try:
            import tomli
            return tomli.loads(content)
        except ImportError:
            try:
                import toml
                return toml.loads(content)
            except ImportError:
                raise ImportError("Neither 'tomli' nor 'toml' package is installed. Please install one of them to handle TOML files.")
    
    def generate(self, data: Dict[str, Any]) -> str:
        """Generate TOML string from dictionary."""
        try:
            import tomli_w
            return tomli_w.dumps(data)
        except ImportError:
            try:
                import toml
                return toml.dumps(data)
            except ImportError:
                raise ImportError("Neither 'tomli_w' nor 'toml' package is installed. Please install one of them to handle TOML files.")
