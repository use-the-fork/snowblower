from dataclasses import dataclass
from enum import Enum, auto
from pathlib import Path
from typing import Any, Dict, Optional


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
    file_path: Path
    file_type: FileType
    data: Dict[str, Any]
    
    def __init__(
        self, 
        file_path: str | Path, 
        file_type: FileType, 
        data: Optional[Dict[str, Any]] = None
    ):
        self.file_path = Path(file_path) if isinstance(file_path, str) else file_path
        self.file_type = file_type
        self.data = data or {}
