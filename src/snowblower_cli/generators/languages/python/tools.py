from snowblower_cli.generators.base import ToolGenerator
from snowblower_cli.generators.manager import GeneratorOutput


class RuffTool(ToolGenerator):
    """Ruff linter and formatter tool for Python."""

    documentation_url = "https://docs.astral.sh/ruff/"
        

    def validate(self) -> bool:
        """Validate the Ruff tool configuration.

        Returns:
            True if the configuration is valid, False otherwise
        """
        # Check if Python language is enabled
        if not self.config.get("languages.python.enabled", False):
            return False
        
        # Check if Ruff tool is enabled
        if not self.config.get("languages.python.tools.ruff.enabled", False):
            return False
        
        return True


    def handle(self, pending_generator: GeneratorOutput) -> GeneratorOutput:
        """Generate Ruff tool configuration.

        Args:
            pending_generator: The current state of the generator output

        Returns:
            Updated generator output with Ruff tool configuration
        """

        # Set the defaults for nix.
        pending_generator.add("nix.config.snowblower.languages.python.tools.ruff.enabled", True)

        # Add Ruff package if specified
        if self.config.get("languages.python.tools.ruff.package", False):
            pending_generator.add("nix.config.snowblower.languages.python.tools.ruff.package", self.config.get("languages.python.tools.ruff.package", "ruff"))

        if self.config.get("languages.python.tools.ruff.settings", False):
            pending_generator.add("nix.config.snowblower.languages.python.tools.ruff.settings.config", self.config.get("languages.python.tools.ruff.settings.config"))


        return pending_generator
