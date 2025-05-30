import os
import re
from pathlib import Path
from typing import Any

import yaml
from pydantic import BaseModel, Field, ValidationError

from snowblower_cli.logger import logger


class LanguageTool(BaseModel):
    """Model for a language tool configuration."""

    enable: bool = False
    package: str | None = None
    settings: dict[str, Any] = Field(default_factory=dict)


class ShellTool(LanguageTool):
    """Model for a shell tool configuration."""


class Language(BaseModel):
    """Model for a language configuration."""

    enable: bool = False
    package: str | None = None
    settings: dict[str, Any] = Field(default_factory=dict)
    tools: dict[str, LanguageTool] = Field(default_factory=dict)


class ServiceConfig(BaseModel):
    """Model for a service configuration."""

    image: str  # Only require the image field as mandatory
    # Allow any additional fields that Docker Compose might support
    model_config = {
        "extra": "allow",
    }


class SnowBlowerConfig(BaseModel):
    """Model for the main SnowBlower configuration."""

    languages: dict[str, Language] = Field(default_factory=dict)
    shell_tools: dict[str, ShellTool] = Field(default_factory=dict)
    services: dict[str, ServiceConfig] = Field(default_factory=dict)

    def get(self, key: str, default: Any = None) -> Any:
        """Retrieve a value from the config using dot notation.

        Args:
            key: The key to retrieve, can use dot notation (e.g., 'languages.python.enable')
            default: The default value to return if key is not found

        Returns:
            The stored value or the default value if not found or if empty/null/false
        """
        parts = key.split(".")
        current = self.model_dump()

        # Navigate through the nested structure
        for part in parts:
            if not isinstance(current, dict) or part not in current:
                return default
            current = current[part]

        # Return default if the value is empty, null, or false
        if current is None or current in ("", {}, []) or current is False:
            return default

        return current


class ConfigParser:
    """Parser for SnowBlower configuration files."""

    DEFAULT_CONFIG_FILE = "snowblower.yml"

    def __init__(self, config_path: str | Path | None = None) -> None:
        """Initialize the config parser.

        Args:
            config_path: Path to the configuration file

        """
        self.config_path = Path(config_path) if config_path else Path(self.DEFAULT_CONFIG_FILE)
        self.config: SnowBlowerConfig | None = None

    def parse(self) -> SnowBlowerConfig:
        """Parse the configuration file.

        Returns:
            The parsed configuration

        Raises:
            FileNotFoundError: If the configuration file doesn't exist
            ValidationError: If the configuration is invalid

        """
        if not self.config_path.exists():
            raise FileNotFoundError(f"Configuration file not found: {self.config_path}")

        try:
            # Register the !include constructor
            yaml.add_constructor("!include", self._include_constructor)

            with open(self.config_path) as f:
                config_data = yaml.safe_load(f)

            # Process environment variables in the loaded config
            config_data = self._process_env_vars(config_data)

            self.config = SnowBlowerConfig.model_validate(config_data)
            logger.info(f"Successfully parsed configuration from {self.config_path}")
            return self.config

        except yaml.YAMLError as e:
            logger.error(f"Error parsing YAML: {e}")
            raise
        except ValidationError as e:
            logger.error(f"Invalid configuration: {e}")
            raise

    def get_language_config(self, language_name: str) -> Language | None:
        """Get configuration for a specific language.

        Args:
            language_name: Name of the language

        Returns:
            Language configuration or None if not found

        """
        if not self.config:
            self.parse()

        return self.config.languages.get(language_name)

    def get_service_config(self, service_name: str) -> ServiceConfig | None:
        """Get configuration for a specific service.

        Args:
            service_name: Name of the service

        Returns:
            Service configuration or None if not found

        """
        if not self.config:
            self.parse()

        return self.config.services.get(service_name)

    def _include_constructor(self, loader, node):
        """YAML constructor for !include tag.

        This allows including other YAML files within a YAML file.

        Args:
            loader: YAML loader
            node: YAML node

        Returns:
            The loaded content from the included file
        """
        filename = loader.construct_scalar(node)

        # Resolve the path relative to the current config file
        include_path = self.config_path.parent / filename

        if not include_path.exists():
            logger.warning(f"Included file not found: {include_path}")
            return {}

        with open(include_path) as f:
            return yaml.safe_load(f)

    def _process_env_vars(self, data: Any) -> Any:
        """Process environment variables in configuration values.

        Replaces ${VAR} or $VAR with the value of the environment variable VAR.

        Args:
            data: The data to process

        Returns:
            The processed data with environment variables expanded
        """
        if isinstance(data, str):
            # Match ${VAR} or $VAR patterns
            pattern = r"\${([^}]+)}|\$([a-zA-Z0-9_]+)"

            def replace_env_var(match):
                var_name = match.group(1) or match.group(2)
                return os.environ.get(var_name, match.group(0))

            return re.sub(pattern, replace_env_var, data)

        if isinstance(data, dict):
            return {k: self._process_env_vars(v) for k, v in data.items()}

        if isinstance(data, list):
            return [self._process_env_vars(item) for item in data]

        return data
