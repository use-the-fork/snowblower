from snowblower_cli.generators.base import ToolGenerator
from snowblower_cli.generators.manager import GeneratorOutput
from snowblower_cli.utils.file_handlers import FileHandlerInput, FileType


class YarnTool(ToolGenerator):
    """Yarn package manager for JavaScript projects."""

    documentation_url = "https://yarnpkg.com/configuration/manifest"

    def validate(self) -> bool:
        """Validate the Yarn tool configuration.

        Returns:
            True if the configuration is valid, False otherwise
        """

        # Check if JavaScript language is enabled
        if not self.config.get("languages.javascript.enable", False):
            return False

        # Check if Yarn tool is enabled
        return self.config.get("languages.javascript.tools.yarn.enable", False)

    def handle(self, pending_generator: GeneratorOutput) -> GeneratorOutput:
        """Generate Yarn tool configuration.

        Args:
            pending_generator: The current state of the generator output

        Returns:
            Updated generator output with Yarn tool configuration
        """

        # Set the defaults for nix.
        pending_generator.add(
            "nix.config.snowblower.languages.javascript.tools.yarn.enable",
            True,
        )

        # Add Ruff package if specified
        if self.config.get("languages.javascript.tools.yarn.package", False):
            pending_generator.add(
                "nix.config.snowblower.languages.javascript.tools.yarn.package",
                self.config.get("languages.javascript.tools.yarn.package", "ruff"),
            )

        if self.config.get("languages.javascript.tools.yarn.settings", False):
            ruff_config = FileHandlerInput(
                file_name=".yarnrc.yml",
                file_type=FileType.YAML,
                data=self.config.get("languages.javascript.tools.yarn.settings.config", {}),
            )

            pending_generator.add(
                "workspace.files.yarn",
                ruff_config,
            )

        return pending_generator
