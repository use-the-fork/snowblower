# Python

Python is a high-level, general-purpose programming language known for its readability and versatility.

## Configuration

In your `snowblower.yml` file, you can configure Python as follows:

```yaml
languages:
  python:
    enable: true
    package: "python311"
    tools:
      # Python tools configuration goes here
      ruff:
        enable: true
      uv:
        enable: true
```

## Options

| Option    | Description                      | Default       |
|-----------|----------------------------------|---------------|
| `enable`  | Enable or disable Python         | `false`       |
| `package` | The Nix package to use for Python| `"python311"` |

## Environment Setup

When Python is enabled, SnowBlower sets up the following environment:

- Adds the configured Python version to your PATH
- Sets up `~/.local/bin` for user-installed Python packages
- Configures environment variables for better Python package management:
  - `PIP_USE_FEATURE=fast-deps`
  - `PYTHONUSERBASE=$HOME/.local`

## Available Tools

SnowBlower supports several Python tools that can be enabled individually:

- [Ruff](./ruff.md) - An extremely fast Python linter and formatter
- [UV](./uv.md) - A fast Python package installer and resolver

Each tool can be configured separately in the `tools` section of your Python configuration.
