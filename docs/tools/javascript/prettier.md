# Prettier

Prettier is an opinionated code formatter that supports many languages including JavaScript, TypeScript, CSS, HTML, JSON, and more.

## Configuration

In your `snowblower.yml` file, you can configure Prettier as follows:

```yaml
languages:
  javascript:
    enable: true
    package: "nodejs_22"
    tools:
      prettier:
        enable: true
        package: "prettierd"
        settings:
          config:
            trailingComma: "es5"
            tabWidth: 4
            semi: false
            singleQuote: true
```

## Options

| Option | Description | Default |
|--------|-------------|---------|
| `enable` | Enable or disable Prettier | `false` |
| `package` | The Nix package to use for Prettier | `"prettierd"` |
| `settings.config` | Prettier configuration options | `{}` |

## Common Configuration Options

Prettier offers many configuration options. Here are some of the most commonly used:

- `printWidth`: Specify the line length that the printer will wrap on (default: 80)
- `tabWidth`: Specify the number of spaces per indentation-level (default: 2)
- `useTabs`: Indent lines with tabs instead of spaces (default: false)
- `semi`: Print semicolons at the ends of statements (default: true)
- `singleQuote`: Use single quotes instead of double quotes (default: false)
- `quoteProps`: Change when properties in objects are quoted (default: "as-needed")
- `jsxSingleQuote`: Use single quotes instead of double quotes in JSX (default: false)
- `trailingComma`: Print trailing commas wherever possible (default: "es5")
- `bracketSpacing`: Print spaces between brackets in object literals (default: true)
- `bracketSameLine`: Put the > of a multi-line HTML element at the end of the last line (default: false)
- `arrowParens`: Include parentheses around a sole arrow function parameter (default: "always")

For a complete list of options, see the [Prettier documentation](https://prettier.io/docs/en/options.html).

## Output Files

When enabled, SnowBlower will generate a `.prettierrc.yaml` file in your project root with your configuration.
