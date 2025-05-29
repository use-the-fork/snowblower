from __future__ import annotations

from typing import TYPE_CHECKING

import rich

from snowblower_cli.generators.base import BaseGenerator

if TYPE_CHECKING:
    from snowblower_cli.generators.manager import GeneratorOutput


class AllShellTools(BaseGenerator):
    """Abstract base class for all generators in the SnowBlower system.

    All generator implementations should inherit from this class.
    """

    def validate(self) -> bool:
        """Validate the shell_tool configuration.

        Ensures that the shell_tool configuration is valid before generation.
        """
        return True

    def handle(self, pending_generator: GeneratorOutput) -> GeneratorOutput:
        """Process all shell_tool configurations.

        Args:
            pending_generator: The current generator output

        Returns:
            Updated generator output with shell_tool configurations
        """
        for tool_key, tool_config in self.config.shell_tools.items():
            try:
                # Import the shell_tool module dynamically
                module_path = f"snowblower_cli.generators.shell_tools.{tool_key}"
                class_name = f"{tool_key.capitalize()}ShellTool"

                rich.print(module_path)

                # Import the module
                module = __import__(module_path, fromlist=[class_name])

                # Get the shell_tool class
                shell_tool_class = getattr(module, class_name)

                # Instantiate and call the shell_tool generator
                shell_tool_generator = shell_tool_class(self.config)
                pending_generator = shell_tool_generator(pending_generator)

            except (ImportError, AttributeError) as e:
                # Handle case where shell_tool module doesn't exist
                rich.print(f"Failed to import shell_tool module for {tool_key}: {e}")

        return pending_generator
