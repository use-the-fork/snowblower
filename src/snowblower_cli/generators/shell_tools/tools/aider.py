from snowblower_cli.generators.base import ShellToolGenerator
from snowblower_cli.generators.manager import GeneratorOutput
from snowblower_cli.utils.file_handlers import FileHandlerInput, FileType


class AiderShellTool(ShellToolGenerator):
    """Aider AI assistant tool for development."""

    documentation_url = "https://aider.chat/docs/config.html"

    def validate(self) -> bool:
        """Validate the Aider tool configuration.

        Returns:
            True if the configuration is valid, False otherwise
        """
        # Check if Aider tool is enable
        return self.config.get("shell_tools.aider.enable", False)

    def handle(self, pending_generator: GeneratorOutput) -> GeneratorOutput:
        """Generate Aider tool configuration.

        Args:
            pending_generator: The current state of the generator output

        Returns:
            Updated generator output with Aider tool configuration
        """

        # Set the defaults for nix.
        pending_generator.add("nix.config.snowblower.shell_tools.aider.enable", True)

        # Add Ruff package if specified
        if self.config.get("shell_tools.aider.package", False):
            pending_generator.add(
                "nix.config.snowblower.shell_tools.aider.package",
                self.config.get("shell_tools.aider.package", "aider-chat"),
            )

        if self.config.get("shell_tools.aider.settings", False):
            aider_config = FileHandlerInput(
                file_name=".aider.conf.yml",
                file_type=FileType.YAML,
                data=self.config.get("shell_tools.aider.settings.config", {}),
            )

            pending_generator.add(
                "workspace.files.aider",
                aider_config,
            )

        return pending_generator
