from snowblower_cli.generators.base import ShellToolGenerator
from snowblower_cli.generators.manager import GeneratorOutput
from snowblower_cli.utils.file_handlers import FileHandlerInput, FileType


# AI: fix the commants and docblocks
class AiderTool(ShellToolGenerator):
    """Ruff linter and formatter tool for Python."""

    documentation_url = "https://aider.chat/docs/config.html"

    def validate(self) -> bool:
        """Validate the Ruff tool configuration.

        Returns:
            True if the configuration is valid, False otherwise
        """
        # Check if Python language is enabled
        return self.config.get("shell-tools.aider.enabled", False)

    def handle(self, pending_generator: GeneratorOutput) -> GeneratorOutput:
        """Generate Ruff tool configuration.

        Args:
            pending_generator: The current state of the generator output

        Returns:
            Updated generator output with Ruff tool configuration
        """

        # Set the defaults for nix.
        pending_generator.add("nix.config.snowblower.shell-tools.aider.enabled", True)

        # Add Ruff package if specified
        if self.config.get("shell-tools.aider.package", False):
            pending_generator.add(
                "nix.config.snowblower.shell-tools.aider.package",
                self.config.get("shell-tools.aider.package", "aider-chat"),
            )

        if self.config.get("shell-tools.aider.settings", False):
            ruff_config = FileHandlerInput(
                file_name=".aider.conf.yml",
                file_type=FileType.YAML,
                data=self.config.get("shell-tools.aider.settings.config", {}),
            )

            pending_generator.add(
                "workspace.files.aider",
                ruff_config,
            )

        return pending_generator
