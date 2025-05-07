# Getting Started with Snow Blower

Snow Blower provides several templates to help you quickly set up different types of projects with the right development environment. This guide will walk you through using these templates and customizing them for your needs.

## Available Templates

Snow Blower offers the following templates:

| Template | Description | Command |
|----------|-------------|---------|
| Base | A minimal setup with core Snow Blower functionality | `nix flake init --template github:use-the-fork/snow-blower` |
| Laravel | PHP/Laravel project setup with MySQL, Redis, etc. | `nix flake init --template github:use-the-fork/snow-blower#laravel` |
| Ruby | Ruby on Rails development environment | `nix flake init --template github:use-the-fork/snow-blower#ruby` |
| Test | A template for testing Snow Blower features | `nix flake init --template github:use-the-fork/snow-blower#test` |

## Using a Template

To initialize a new project with one of the templates:

1. Create a new directory for your project:
   ```bash
   mkdir my-project
   cd my-project
   ```

2. Initialize with your chosen template:
   ```bash
   nix flake init --template github:use-the-fork/snow-blower#laravel
   ```

3. Enter the development shell:
   ```bash
   nix develop --impure
   ```

   Or if you have direnv installed:
   ```bash
   direnv allow
   ```

## Template Details

### Base Template

The base template provides:
- A minimal `flake.nix` with Snow Blower configuration
- A `.envrc` file for direnv integration
- A `justfile` for command automation

This template is ideal for starting new projects where you'll add your own specific requirements.

### Laravel Template

The Laravel template includes:
- PHP and Composer setup
- MySQL database
- Redis for caching
- Node.js for frontend assets
- Laravel-specific directory structure
- Pre-configured `.env` files

Perfect for PHP developers working with the Laravel framework.

### Ruby Template

The Ruby template provides:
- Ruby language setup
- Bundler for dependency management
- Basic Rails configuration

Ideal for Ruby on Rails developers.

### Test Template

A minimal template used primarily for testing Snow Blower features and functionality.

## Customizing Your Environment

After initializing with a template, you can customize your development environment by editing the `flake.nix` file. The file contains commented sections explaining the available options.

Key areas to customize:

1. **Integrations**: Enable tools like Git hooks, formatting tools, etc.
2. **Scripts**: Add custom scripts to automate common tasks
3. **Packages**: Include additional packages in your environment
4. **Shell**: Configure shell startup commands
5. **Processes**: Define background processes for your development environment

Here's an example of a customized `flake.nix` configuration:

```nix
# In your flake.nix
{
  # ...
  snow-blower = {
    integrations = {
      # Configure treefmt for code formatting
      treefmt = {
        programs = {
          alejandra.enable = true;  # Formatter for Nix
        };
      };

      # Set up Git hooks
      git-hooks.hooks = {
        treefmt.enable = true;
      };
    };

    # Define custom scripts
    scripts = {
      "hi" = {
        just.enable = true;
        description = "runs the hello command";
        exec = ''
          hello
        '';
      };
    };

    # Add packages to your environment
    packages = [pkgs.hello];

    # Configure shell startup commands
    shell.startup = [
      ''
        hello
      ''
    ];

    # Define background processes
    processes.hello.exec = "hello";
  };
}
```

## Next Steps

After setting up your project with a template:

1. Review the [Integrations](/integrations/index.md) documentation to add more tools
2. Explore [Just Commands](/just/index.md) to understand the available automation
3. Check out [Services](/services/index.md) to add databases and other infrastructure

For more detailed information on specific features, browse the sidebar for relevant documentation pages.
