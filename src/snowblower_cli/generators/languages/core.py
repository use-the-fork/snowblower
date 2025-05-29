from __future__ import annotations

from typing import TYPE_CHECKING

import rich

from snowblower_cli.generators.base import BaseGenerator

if TYPE_CHECKING:
    from snowblower_cli.generators.manager import GeneratorOutput


class AllLanguages(BaseGenerator):
    """Abstract base class for all generators in the SnowBlower system.

    All generator implementations should inherit from this class.
    """

    def validate(self) -> bool:
        """Validate the language configuration.

        Ensures that the language configuration is valid before generation.
        """
        return True

    def handle(self, pending_generator: GeneratorOutput) -> GeneratorOutput:
        """Process all language configurations.

        Args:
            pending_generator: The current generator output

        Returns:
            Updated generator output with language configurations
        """
        for language_key, language_config in self.config.languages.items():
            try:
                # Import the language module dynamically
                module_path = f"snowblower_cli.generators.languages.{language_key}.core"
                class_name = f"{language_key.capitalize()}Language"

                # Import the module
                module = __import__(module_path, fromlist=[class_name])

                # Get the language class
                language_class = getattr(module, class_name)

                # Instantiate and call the language generator
                language_generator = language_class(self.config)
                pending_generator = language_generator(pending_generator)

            except (ImportError, AttributeError) as e:
                # Handle case where language module doesn't exist
                rich.print(f"Failed to import language module for {language_key}: {e}")

        return pending_generator
