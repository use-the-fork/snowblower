from snowblower_cli.generators import LanguageGenerator
from snowblower_cli.generators.manager import GeneratorOutput


class PHPLanguage(LanguageGenerator):
    """Abstract base class for all generators in the SnowBlower system.

    All generator implementations should inherit from this class.
    """

    def __call__(self, pending_generator: GeneratorOutput) -> GeneratorOutput:
        """ """

        # since all languages have tools
