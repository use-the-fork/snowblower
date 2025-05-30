# SnowBlower Development Conventions

This document outlines the conventions and guidelines for contributing to the SnowBlower project.

## General Guidelines

* **Comments**: Add comments to explain complex logic or non-obvious decisions. Avoid redundant comments that merely restate the code.
* **Documentation**: Document modules, functions, and options using proper Nix documentation format.
* **Naming**: Use clear, descriptive names for variables, functions, and modules. Follow existing naming patterns in the codebase.
* **Consistency**: Maintain consistent style with the rest of the codebase.

## Python Code Guidelines

* Follow PEP 8 style guidelines
* Use type hints for all function parameters and return values
* Use docstrings for all modules, classes, and functions (Google style)
* Use f-strings for string formatting when possible
* Prefer composition over inheritance
* Use dataclasses or Pydantic models for data structures
* Use pathlib instead of os.path for file operations
* Use context managers for file operations

## Nix Code Guidelines

* Use 2-space indentation for Nix files
* Follow the NixOS module system conventions
* Use descriptive option names
* Provide default values where appropriate
* Document all options with descriptions and examples
* Use mkOption for declaring options
* Use mkIf, mkMerge, and other module combinators appropriately
* Avoid using `with` expressions in production code

## Documentation Guidelines

* Document all module options with clear descriptions and examples
* Include usage examples in markdown documentation
* Keep documentation up-to-date when changing module behavior
* Follow the existing documentation structure for consistency
* Use markdown for all documentation
* Include screenshots or diagrams where they add clarity

## Error Handling

* Use specific exception types
* Provide helpful error messages
* Log errors with appropriate context
* Handle errors at the appropriate level
* Fail gracefully when possible