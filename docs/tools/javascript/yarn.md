# Yarn

Yarn is a fast, reliable, and secure dependency management tool for JavaScript projects.

## Configuration

In your `snowblower.yml` file, you can configure Yarn as follows:

```yaml
languages:
  javascript:
    enable: true
    package: "nodejs_22"
    tools:
      yarn:
        enable: true
        package: "yarn-berry"
        settings:
          config:
            enableConstraintsChecks: false
            nodeLinker: "node-modules"
```

## Options

| Option | Description | Default |
|--------|-------------|---------|
| `enable` | Enable or disable Yarn | `false` |
| `package` | The Nix package to use for Yarn | `"yarn-berry"` |
| `settings.config` | Yarn configuration options | `{}` |

## Common Configuration Options

Yarn offers many configuration options. Here are some of the most commonly used:

- `nodeLinker`: Controls how Yarn links packages into your project (`"pnp"`, `"node-modules"`, or `"pnpm"`)
- `enableGlobalCache`: If true, Yarn will use a global cache directory
- `enableTelemetry`: If true, Yarn will send anonymous usage information to the Yarn team
- `enableConstraintsChecks`: If true, Yarn will check that your dependencies match your constraints
- `compressionLevel`: Controls the compression level of the cache (0-9)
- `enableImmutableInstalls`: If true, Yarn will refuse to change the lockfile when running `yarn install`
- `enableProgressBars`: If true, Yarn will show progress bars during installation

For a complete list of options, see the [Yarn documentation](https://yarnpkg.com/configuration/yarnrc).

## Output Files

When enabled, SnowBlower will generate a `.yarnrc.yml` file in your project root with your configuration.
