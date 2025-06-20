# Development Conventions

## Code Style and Formatting

### Comments
- Use clear, concise language that explains the "why" not just the "what"
- Start comments with a capital letter and end with proper punctuation
- For inline comments, use a single space after the comment delimiter
- For block comments, align content consistently
- Use descriptive variable names to reduce need for comments
- Add comments to explain complex logic or non-obvious decisions
- Avoid redundant comments that merely restate the code

### Descriptions
- Begin with a clear, action-oriented statement
- Use present tense and active voice
- Include relevant context and constraints
- Provide examples when helpful for clarity
- Reference related commands, options, or help text using proper formatting
- Use proper markup for code references: `{command}`, `{option}`, `{file}`
- Structure complex descriptions with clear paragraphs
- End with a period for complete sentences

### Formatting
- Use consistent indentation and spacing
- Align related elements vertically when it improves readability
- Break long lines at logical points
- Use proper capitalization for technical terms and proper nouns
- Maintain consistent terminology throughout the codebase

## General Guidelines

* **Naming**: Use clear, descriptive names for variables, functions, and modules. Follow existing naming patterns in the codebase.
* **Consistency**: Maintain consistent style with the rest of the codebase.
* **Documentation**: Document modules, functions, and options using proper Nix documentation format.

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
