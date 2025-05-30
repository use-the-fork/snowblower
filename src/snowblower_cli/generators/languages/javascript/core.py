from snowblower_cli.generators.base import LanguageGenerator
from snowblower_cli.generators.manager import GeneratorOutput


# AI: Fix the documentation for the module here.
class JavascriptLanguage(LanguageGenerator):
    """Python language generator for SnowBlower.

    Handles Python language configuration and tools.
    """

    def validate(self) -> bool:
        """Validate the Python language configuration."""
        return self.config.get("languages.javascript.enable", False)

    def handle(self, pending_generator: GeneratorOutput) -> GeneratorOutput:
        """Generate Python language configuration.

        Args:
            pending_generator: The current state of the generator output

        Returns:
            Updated generator output with Python language configuration
        """

        # Set the defaults for nix.
        pending_generator.add("nix.config.snowblower.languages.javascript.enable", True)
        pending_generator.add(
            "nix.config.snowblower.languages.javascript.package",
            self.config.get("languages.javascript.package", "nodejs_22"),
        )

        for tool_key, tool_config in self.config.get(
            "languages.javascript.tools",
            {},
        ).items():
            try:
                # Import the language module dynamically
                module_path = f"snowblower_cli.generators.languages.javascript.tools.{tool_key}"
                class_name = f"{tool_key.capitalize()}Tool"

                # Import the module
                module = __import__(module_path, fromlist=[class_name])

                # Get the language class
                tool_class = getattr(module, class_name)

                # Instantiate and call the language generator
                tool_generator = tool_class(self.config)
                pending_generator = tool_generator(pending_generator)

            except (ImportError, AttributeError) as e:
                # Handle case where language module doesn't exist
                print(f"Failed to import tool module for {tool_key}: {e}")

        return pending_generator
