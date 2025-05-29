from __future__ import annotations

from abc import ABC, abstractmethod
from typing import TYPE_CHECKING

if TYPE_CHECKING:
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
    def validate(self) -> bool:
        """Validate the language configuration.

        Ensures that the language configuration is valid before generation.
        """

    @abstractmethod
    def handle(self, pending_generator: GeneratorOutput) -> GeneratorOutput:
        """ """

    def __call__(self, pending_generator: GeneratorOutput) -> GeneratorOutput:
        if self.validate():
            pending_generator = self.handle(pending_generator)

        return pending_generator


class LanguageGenerator(BaseGenerator):
    """Base class for all language generators in the system."""


class ToolGenerator(BaseGenerator):
    """Base class for all tool generators in the system."""


class ShellToolGenerator(BaseGenerator):
    """Base class for all shell tool generators in the system."""
