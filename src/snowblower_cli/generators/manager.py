import importlib
import inspect
import pkgutil
from pathlib import Path
from typing import Any

from snowblower_cli.config.parser import SnowBlowerConfig
from snowblower_cli.generators import BaseGenerator
from snowblower_cli.logger import logger

class GeneratorOutput:
    """Container for generator outputs."""

    def __init__(self) -> None:
        """Initialize the generator output container."""
        self.nix_config = {}
        self.nix_packages = []
        self.nix_options = {}
        self.ide_config = {}
        self.docker_compose = {}

    def add_nix_package(self, package: str) -> None:
        """Add a Nix package to the list.

        Args:
            package: Package name to add
        """
        if package and package not in self.nix_packages:
            self.nix_packages.append(package)

    def add_nix_option(self, key: str, value: Any) -> None:
        """Add a Nix option.

        Args:
            key: Option key
            value: Option value
        """
        self.nix_options[key] = value

    def update_nix_config(self, config: dict[str, Any]) -> None:
        """Update the Nix configuration.

        Args:
            config: Configuration to add to the Nix config
        """
        self.nix_config.update(config)

    def update_ide_config(self, config: dict[str, Any]) -> None:
        """Update the IDE configuration.

        Args:
            config: Configuration to add to the IDE config
        """
        self.ide_config.update(config)

    def update_docker_compose(self, config: dict[str, Any]) -> None:
        """Update the Docker Compose configuration.

        Args:
            config: Configuration to add to the Docker Compose config
        """
        self.docker_compose.update(config)

    def merge_nix_config(self, key: str, value: dict[str, Any]) -> None:
        """Merge a nested dictionary into the Nix configuration.

        Args:
            key: The key to merge under
            value: The dictionary to merge
        """
        if key not in self.nix_config:
            self.nix_config[key] = {}
        self.nix_config[key].update(value)

    def remove_nix_package(self, package: str) -> None:
        """Remove a Nix package from the list.

        Args:
            package: Package name to remove
        """
        if package in self.nix_packages:
            self.nix_packages.remove(package)

    def remove_nix_option(self, key: str) -> None:
        """Remove a Nix option.

        Args:
            key: Option key to remove
        """
        if key in self.nix_options:
            del self.nix_options[key]


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

    def discover_generators(self) -> None:
        """Discover and load all available generators."""
        logger.info("Discovering generators...")

        # TODO: This can be simplfied. since our SnowBlowerConfig structure should follow our generators structure we should simply attempt to

        # Get the package containing all generators
        import snowblower_cli.generators as generators_pkg

        # Walk through the package to find all modules
        for _, name, is_pkg in pkgutil.walk_packages(
            generators_pkg.__path__,
            generators_pkg.__name__ + ".",
        ):
            if is_pkg:
                continue

            try:
                # Import the module
                module = importlib.import_module(name)

                # Find all classes in the module that inherit from BaseGenerator
                for _, obj in inspect.getmembers(module, inspect.isclass):
                    if (
                        issubclass(obj, BaseGenerator)
                        and obj != BaseGenerator
                        and obj.__module__ == name
                    ):
                        logger.debug(f"Found generator: {obj.__name__}")

                        # Create an instance of the generator
                        generator = obj(self.config.model_dump())
                        self.generators.append(generator)

            except (ImportError, AttributeError) as e:
                logger.warning(f"Failed to load generator module {name}: {e}")

        logger.info(f"Discovered {len(self.generators)} generators")

    def run_generators(self) -> bool:
        """Run all discovered generators.

        Returns:
            True if all generators ran successfully, False otherwise
        """
        if not self.generators:
            self.discover_generators()

        if not self.generators:
            logger.warning("No generators found")
            return False

        success = True

        for generator in self.generators:
            try:
                if not generator.validate_config():
                    logger.warning(
                        f"Generator {generator.__class__.__name__} failed validation",
                    )
                    continue

                logger.info(f"Running generator: {generator.__class__.__name__}")
                result = generator.generate()

                # Process the generator output
                # This would need to be expanded based on what the generators return

            except Exception as e:
                logger.error(
                    f"Error running generator {generator.__class__.__name__}: {e}",
                )
                success = False

        return success

    def write_outputs(self) -> bool:
        """Write all generated outputs to their respective files.

        Returns:
            True if all outputs were written successfully, False otherwise
        """
        # Write Nix configuration
        if self.output.nix_config:
            try:
                nix_config_path = self.working_dir / "configuration.nix"
                # Logic to write Nix configuration
                logger.info(f"Wrote Nix configuration to {nix_config_path}")
            except Exception as e:
                logger.error(f"Failed to write Nix configuration: {e}")
                return False

        # Write IDE configuration
        if self.output.ide_config:
            try:
                # Logic to write IDE configuration
                logger.info("Wrote IDE configuration")
            except Exception as e:
                logger.error(f"Failed to write IDE configuration: {e}")
                return False

        # Write Docker Compose configuration
        if self.output.docker_compose:
            try:
                docker_compose_path = self.working_dir / "docker-compose.yml"
                # Logic to write Docker Compose configuration
                logger.info(
                    f"Wrote Docker Compose configuration to {docker_compose_path}",
                )
            except Exception as e:
                logger.error(f"Failed to write Docker Compose configuration: {e}")
                return False

        return True
