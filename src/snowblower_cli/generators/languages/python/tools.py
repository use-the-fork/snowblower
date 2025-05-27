from snowblower_cli.generators.base import ToolGenerator
from snowblower_cli.generators.manager import GeneratorOutput


class RuffTool(ToolGenerator):
    """Ruff linter and formatter tool for Python."""

    def __init__(self, config: dict[str, Any]) -> None:
        """Initialize the Ruff tool generator.

        Args:
            config: Configuration dictionary for the generator
        """
        super().__init__(config)
        self.documentation_url = "https://docs.astral.sh/ruff/"

    def validate(self) -> bool:
        """Validate the Ruff tool configuration.

        Returns:
            True if the configuration is valid, False otherwise
        """
        # Check if Python language is enabled
        if not self.config.get("languages", {}).get("python", {}).get("enabled", False):
            return False

        # Check if Ruff tool is enabled
        return (
            self.config.get("languages", {})
            .get("python", {})
            .get("tools", {})
            .get("ruff", {})
            .get("enabled", False)
        )

    def handle(self, pending_generator: GeneratorOutput) -> GeneratorOutput:
        """Generate Ruff tool configuration.

        Args:
            pending_generator: The current state of the generator output

        Returns:
            Updated generator output with Ruff tool configuration
        """
        # Add Ruff package if specified
        ruff_package = (
            self.config.get("languages", {})
            .get("python", {})
            .get("tools", {})
            .get("ruff", {})
            .get("package")
        )
        if ruff_package:
            pending_generator.add_nix_package(ruff_package)

        # Add Ruff settings to Nix options
        ruff_settings = (
            self.config.get("languages", {})
            .get("python", {})
            .get("tools", {})
            .get("ruff", {})
            .get("settings", {})
        )
        for key, value in ruff_settings.items():
            pending_generator.add_nix_option(f"python.tools.ruff.{key}", value)

        return pending_generator
