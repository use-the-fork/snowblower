# UV

UV is an extremely fast Python package installer and resolver, written in Rust.

## Configuration

In your `snowblower.yml` file, you can configure UV as follows:

```yaml
languages:
  python:
    enable: true
    package: "python311"
    tools:
      uv:
        enable: true
        settings:
          config:
            resolution:
              allow-prereleases: false
            venv:
              python: "python3.11"
```

## Options

| Option            | Description                   | Default |
| ----------------- | ----------------------------- | ------- |
| `enable`          | Enable or disable UV          | `false` |
| `package`         | The Nix package to use for UV | `"uv"`  |
| `settings.config` | UV configuration options      | `{}`    |

## Common Configuration Options

UV offers several configuration options. Here are some of the most commonly used:

- `resolution.allow-prereleases`: Whether to allow pre-release versions
- `resolution.prefer-binary`: Whether to prefer binary distributions
- `venv.python`: The Python interpreter to use for virtual environments
- `cache.dir`: The directory to use for caching
- `index.url`: The URL of the package index to use

For a complete list of options, see the [UV documentation](https://github.com/astral-sh/uv/blob/main/docs/configuration.md).

## Output Files

When enabled, SnowBlower will generate a `~/.config/uv/config.toml` file with your configuration.
