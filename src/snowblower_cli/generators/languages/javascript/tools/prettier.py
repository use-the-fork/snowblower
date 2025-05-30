from snowblower_cli.generators.base import ToolGenerator
from snowblower_cli.generators.manager import GeneratorOutput
from snowblower_cli.utils.file_handlers import FileHandlerInput, FileType


class PrettierTool(ToolGenerator):
    """Prettier code formatter for JavaScript and other languages."""

    documentation_url = "https://prettier.io/docs/en/configuration.html"

    def validate(self) -> bool:
        """Validate the Prettier tool configuration.

        Returns:
            True if the configuration is valid, False otherwise
        """
        # Check if JavaScript language is enabled
        if not self.config.get("languages.javascript.enable", False):
            return False

        # Check if Prettier tool is enabled
        return self.config.get("languages.javascript.tools.prettier.enable", False)

    def handle(self, pending_generator: GeneratorOutput) -> GeneratorOutput:
        """Generate Prettier tool configuration.

        Args:
            pending_generator: The current state of the generator output

        Returns:
            Updated generator output with Prettier tool configuration
        """

        # Set the defaults for nix.
        pending_generator.add(
            "nix.config.snowblower.languages.javascript.tools.prettier.enable",
            True,
        )

        # Add Prettier package if specified
        if self.config.get("languages.javascript.tools.prettier.package", False):
            pending_generator.add(
                "nix.config.snowblower.languages.javascript.tools.prettier.package",
                self.config.get("languages.javascript.tools.prettier.package", "prettierd"),
            )

        if self.config.get("languages.javascript.tools.prettier.settings", False):
            prettier_config = FileHandlerInput(
                file_name=".prettierrc.yaml",
                file_type=FileType.YAML,
                data=self.config.get("languages.javascript.tools.prettier.settings.config", {}),
            )

            pending_generator.add(
                "workspace.files.prettier",
                prettier_config,
            )

        return pending_generator
