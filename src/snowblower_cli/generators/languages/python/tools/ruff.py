from snowblower_cli.generators.base import ToolGenerator
from snowblower_cli.generators.manager import GeneratorOutput
from snowblower_cli.utils.file_handlers import FileHandlerInput, FileType


class RuffTool(ToolGenerator):
    """Ruff linter and formatter tool for Python."""

    documentation_url = "https://docs.astral.sh/ruff/"

    def validate(self) -> bool:
        """Validate the Ruff tool configuration.

        Returns:
            True if the configuration is valid, False otherwise
        """
        # Check if Python language is enable
        if not self.config.get("languages.python.enable", False):
            return False

        # Check if Ruff tool is enable
        if not self.config.get("languages.python.tools.ruff.enable", False):
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
        pending_generator.add(
            "nix.config.snowblower.languages.python.tools.ruff.enable",
            True,
        )

        # Add Ruff package if specified
        if self.config.get("languages.python.tools.ruff.package", False):
            pending_generator.add(
                "nix.config.snowblower.languages.python.tools.ruff.package",
                self.config.get("languages.python.tools.ruff.package", "ruff"),
            )

        if self.config.get("languages.python.tools.ruff.settings", False):
            ruff_config = FileHandlerInput(
                file_name="ruff.toml",
                file_type=FileType.TOML,
                data=self.config.get("languages.python.tools.ruff.settings.config", {}),
            )

            pending_generator.add(
                "workspace.files.ruff",
                ruff_config,
            )

        return pending_generator
