from abc import ABC, abstractmethod

from snowblower_cli.config import SnowBlowerConfig
from snowblower_cli.generators.manager import GeneratorOutput


class BaseGenerator(ABC):
    """Abstract base class for all generators in the SnowBlower system.

    All generator implementations should inherit from this class.
    """

    def __init__(self, config: SnowBlowerConfig) -> None:
        """Initialize the generator with optional configuration.

        Args:
            config: Configuration dictionary for the generator

        """
        self.config = config or {}

    @abstractmethod
    def handle(self, pending_generator: GeneratorOutput) -> GeneratorOutput:
        """Generate the configuration output.

        Args:
            pending_generator: The current state of the generator output

        Returns:
            Updated generator output with this generator's contributions

        """


class LanguageGenerator(BaseGenerator):
    """Base class for all language generators in the system."""

    @abstractmethod
    def validate(self) -> None:
        """Validate the language configuration.

        Ensures that the language configuration is valid before generation.
        """


class ToolGenerator(BaseGenerator):
    """Base class for all tool generators in the system."""

    def __init__(self, config: SnowBlowerConfig) -> None:
        """Initialize the tool generator.

        Args:
            config: Configuration dictionary for the generator
        """
        super().__init__(config)
        self.documentation_url: str = ""

    @abstractmethod
    def validate(self) -> None:
        """Validate the tool configuration.

        Ensures that the tool configuration is valid before generation.
        """

    @abstractmethod
    def handle(self, pending_generator: GeneratorOutput) -> GeneratorOutput:
        """ """
