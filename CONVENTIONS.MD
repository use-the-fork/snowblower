# Coding Conventions

## General Guidelines

* **Comments**: Add comments to explain complex logic or non-obvious decisions. Avoid redundant comments that merely restate the code.
* **Documentation**: Document modules, functions, and options using proper Nix documentation format.
* **Naming**: Use clear, descriptive names for variables, functions, and modules. Follow existing naming patterns in the codebase.
* **Consistency**: Maintain consistent style with the rest of the codebase.

## Nix-Specific Guidelines

* Use `lib.mkOption` for defining module options with proper types and descriptions.
* Prefer `lib.mkIf` for conditional configuration over nested if-then-else expressions.
* Use `lib.mkDefault` when providing default values that users might want to override.
* Follow the flake-parts module structure for new modules.
* Keep module options organized by related functionality.

## Documentation Guidelines

* Document all module options with clear descriptions and examples.
* Include usage examples in markdown documentation.
* Keep documentation up-to-date when changing module behavior.
* Follow the existing documentation structure for consistency.

## Project Structure

* Place new modules in the appropriate directory based on their functionality.
* Follow the established pattern for module organization:
  * Core modules in `modules/core/`
  * Language support in `modules/languages/`
  * Services in `modules/services/`
  * Integrations in `modules/integrations/`
