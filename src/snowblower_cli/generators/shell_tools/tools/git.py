from snowblower_cli.generators.base import ShellToolGenerator
from snowblower_cli.generators.manager import GeneratorOutput
from snowblower_cli.utils.file_handlers import FileHandlerInput, FileType


class GitShellTool(ShellToolGenerator):
    """Git version control tool."""

    documentation_url = "https://git-scm.com/doc"

    def validate(self) -> bool:
        """Validate the Git tool configuration.

        Returns:
            True if the configuration is valid, False otherwise
        """
        # Check if Git tool is enable
        return self.config.get("shell_tools.git.enable", False)

    def handle(self, pending_generator: GeneratorOutput) -> GeneratorOutput:
        """Generate Git tool configuration.

        Args:
            pending_generator: The current state of the generator output

        Returns:
            Updated generator output with Git tool configuration
        """

        # Set the defaults for nix.
        pending_generator.add("nix.config.snowblower.shell_tools.git.enable", True)

        pending_generator.add(
            "nix.config.snowblower.shell_tools.git.user_name",
            self.config.get("shell_tools.git.settings.user_name"),
        )
        pending_generator.add(
            "nix.config.snowblower.shell_tools.git.user_email",
            self.config.get("shell_tools.git.settings.user_email"),
        )

        # Add Ruff package if specified
        if self.config.get("shell_tools.git.package", False):
            pending_generator.add(
                "nix.config.snowblower.shell_tools.git.package",
                self.config.get("shell_tools.git.package"),
            )

        # Handle .gitignore file configuration
        if self.config.get("shell_tools.git.settings.gitignore", False):
            gitignore_config = FileHandlerInput(
                file_name=".gitignore",
                file_type=FileType.TEXT,
                data=self.config.get("shell_tools.git.settings.gitignore", {}),
            )

            pending_generator.add(
                "workspace.files.gitignore",
                gitignore_config,
            )

        return pending_generator
