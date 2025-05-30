# Ruff

Ruff is an extremely fast Python linter and formatter, written in Rust.

## Configuration

In your `snowblower.yml` file, you can configure Ruff as follows:

```yaml
languages:
  python:
    enable: true
    package: "python311"
    tools:
      ruff:
        enable: true
        settings:
          config:
            line-length: 100
            select:
              - "E"  # pycodestyle errors
              - "F"  # pyflakes
              - "I"  # isort
            ignore:
              - "E501"  # line too long
```

## Options

| Option            | Description                     | Default  |
| ----------------- | ------------------------------- | -------- |
| `enable`          | Enable or disable Ruff          | `false`  |
| `package`         | The Nix package to use for Ruff | `"ruff"` |
| `settings.config` | Ruff configuration options      | `{}`     |

## Common Configuration Options

Ruff offers many configuration options. Here are some of the most commonly used:

- `line-length`: Maximum line length for linting
- `target-version`: The Python version to target
- `select`: List of rule codes to enable
- `ignore`: List of rule codes to ignore
- `exclude`: List of file patterns to exclude from linting
- `extend-select`: Additional rule codes to enable
- `extend-ignore`: Additional rule codes to ignore
- `fixable`: List of rule codes that are allowed to be fixed automatically
- `unfixable`: List of rule codes that are not allowed to be fixed automatically

For a complete list of options, see the [Ruff documentation](https://docs.astral.sh/ruff/settings/).

## Output Files

When enabled, SnowBlower will generate a `ruff.toml` file in your project root with your configuration.

## Templates

SnowBlower provides a convenient way to apply common Ruff configurations through templates. You can use the following command to apply a predefined template:

```bash
snowblower template ruff [TEMPLATE_NAME]
```

Available templates include:

- `strict`: A comprehensive set of rules for maximum code quality
- `standard`: A balanced set of rules suitable for most projects
- `minimal`: A minimal set of essential rules for basic linting

For example, to apply the standard template:

```bash
snowblower template ruff standard
```

This will update your `snowblower.yml` file with the selected Ruff configuration template, which you can then customize further if needed.
