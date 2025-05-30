import os
from pathlib import Path
from typing import Any

import yaml

from snowblower_cli.config.parser import ConfigParser
from snowblower_cli.logger import logger
from snowblower_templates import load_template


class SnowBlower:
    """Main SnowBlower application class.

    This is the entrypoint to the application and is executed from the CLI.
    It handles the main operations based on the provided configuration.
    """

    def __init__(self, config: dict[str, Any], working_dir: Path | None = None):
        """Initialize the SnowBlower application.

        Args:
            config: Configuration dictionary for the operation to run
            working_dir: The directory the command was run from (defaults to current directory)
        """
        self.config = config
        self.working_dir = working_dir or Path.cwd()
        self.config_parser = None

        # Store the working directory in the config for reference
        self.config["working_dir"] = str(self.working_dir)

        logger.info(f"Initialized SnowBlower in {self.working_dir}")

    def init_project(self) -> bool:
        """Initialize a new SnowBlower project.

        Returns:
            True if initialization was successful, False otherwise
        """
        logger.info("Initializing new SnowBlower project")

        # Create default configuration file if it doesn't exist
        config_path = self.working_dir / ConfigParser.DEFAULT_CONFIG_FILE

        if config_path.exists():
            logger.warning(f"Configuration file already exists at {config_path}")
            return False

        try:
            # Create a basic template configuration
            with open(config_path, "w") as f:
                f.write("""# SnowBlower Configuration
languages:
  # Example language configuration
  # php:
  #   enabled: true
  #   package: "php83"
  #   settings:
  #     php:
  #       engine: "on"
  #       error_reporting: "E_ALL"
  #   tools:
  #     composer:
  #       enabled: true

services:
  # Example service configuration
  # mysql:
  #   image: "mysql/mysql-server:8.0"
  #   ports:
  #     - "3306:3306"
""")

            logger.info(f"Created configuration file at {config_path}")
            return True

        except Exception as e:
            logger.error(f"Failed to initialize project: {e}")
            return False

    def load_config(self, config_path: str | None = None) -> bool:
        """Load the project configuration.

        Args:
            config_path: Optional path to the configuration file

        Returns:
            True if configuration was loaded successfully, False otherwise
        """
        try:
            path = config_path or os.path.join(
                self.working_dir,
                ConfigParser.DEFAULT_CONFIG_FILE,
            )
            self.config_parser = ConfigParser(path)
            self.config_parser.parse()
            logger.info("Configuration loaded successfully")
            return True

        except Exception as e:
            logger.error(f"Failed to load configuration: {e}")
            return False

    def generate(self) -> bool:
        """Generate the project configuration files.

        Returns:
            True if generation was successful, False otherwise
        """
        if not self.config_parser:
            if not self.load_config():
                return False

        from snowblower_cli.generators.manager import GeneratorManager

        # Create and run the generator manager
        manager = GeneratorManager(self.config_parser.config, self.working_dir)

        if not manager.run_generators():
            logger.error("One or more generators failed")
            return False

        if not manager.write_outputs():
            logger.error("Failed to write generator outputs")
            return False

        logger.info("Generating project configuration")

        # TODO: Implement generation logic using the appropriate generators

        return True

    def apply_template(self, category: str, template_name: str, config_path: Path) -> bool:
        """Apply a template to the configuration.

        Args:
            category: The category of the template (e.g., 'python/ruff')
            template_name: The name of the template (e.g., 'standard')
            config_path: Path to the configuration file

        Returns:
            True if the template was applied successfully, False otherwise
        """
        try:
            # Load the template
            template_data = load_template(category, template_name)
            logger.info(f"Loaded template {template_name} for {category}")

            # Load the current configuration
            with open(config_path) as f:
                config_data = yaml.safe_load(f) or {}

            # Determine where to apply the template based on category
            parts = category.split("/")
            if len(parts) == 2:  # e.g., python/ruff
                language, tool = parts

                # Ensure the language section exists
                if "languages" not in config_data:
                    config_data["languages"] = {}
                if language not in config_data["languages"]:
                    config_data["languages"][language] = {"enable": True}

                # Ensure the tools section exists
                if "tools" not in config_data["languages"][language]:
                    config_data["languages"][language]["tools"] = {}
                if tool not in config_data["languages"][language]["tools"]:
                    config_data["languages"][language]["tools"][tool] = {"enable": True}

                # Ensure settings section exists
                if "settings" not in config_data["languages"][language]["tools"][tool]:
                    config_data["languages"][language]["tools"][tool]["settings"] = {}

                # Apply the template to the config section
                config_data["languages"][language]["tools"][tool]["settings"]["config"] = (
                    template_data
                )
            else:
                logger.error(f"Unsupported template category format: {category}")
                return False

            # Write the updated configuration back to the file
            with open(config_path, "w") as f:
                yaml.dump(config_data, f, default_flow_style=False, sort_keys=False)

            logger.info(f"Applied template {template_name} to {category} in {config_path}")
            return True

        except Exception as e:
            logger.error(f"Failed to apply template: {e}")
            return False

    def run(self, command: str) -> bool:
        """Run a specific command.

        Args:
            command: The command to run

        Returns:
            True if the command was successful, False otherwise
        """
        commands = {
            "init": self.init_project,
            "generate": self.generate,
        }

        if command not in commands:
            logger.error(f"Unknown command: {command}")
            return False

        return commands[command]()
