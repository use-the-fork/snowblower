import os
import sys
from pathlib import Path

import click
from pydantic import BaseModel, Field

from snowblower_cli.config.parser import ConfigParser
from snowblower_cli.snowblower import SnowBlower
from snowblower_templates import list_templates, load_template


class CliConfig(BaseModel):
    """Configuration for the CLI."""

    working_dir: Path = Field(default_factory=Path.cwd)
    command: str = "init"
    config_path: Path | None = None
    verbose: bool = False


# Create the main command group for the CLI
@click.group(context_settings={"auto_envvar_prefix": "SNOWBLOWER"})
@click.version_option(prog_name="snowblower")
def cli():
    """SnowBlower CLI - All flake no fluff."""
    return


# Define the "init" command
@cli.command("init")
@click.option(
    "--config",
    "-c",
    help="Path to the configuration file",
    type=click.Path(exists=False),
)
@click.option(
    "--verbose",
    "-v",
    is_flag=True,
    help="Enable verbose output",
)
def snowblower_init(config, verbose):
    """Initialize a new SnowBlower project."""
    cli_config = CliConfig(
        working_dir=Path.cwd(),
        command="init",
        config_path=Path(config) if config else None,
        verbose=verbose,
    )

    # Convert to dict for compatibility with SnowBlower
    config_dict = cli_config.model_dump()

    # Initialize and run SnowBlower
    snow_blower = SnowBlower(config_dict, cli_config.working_dir)
    success = snow_blower.run(cli_config.command)

    if not success:
        click.echo("Failed to initialize project")
        exit(1)

    click.echo("Project initialized successfully")


# Define the "generate" command
@cli.command("generate")
@click.option(
    "--config",
    "-c",
    help="Path to the configuration file",
    type=click.Path(exists=True),
)
@click.option(
    "--verbose",
    "-v",
    is_flag=True,
    help="Enable verbose output",
)
def snowblower_generate(config, verbose) -> None:
    """Generate configuration files from SnowBlower config."""
    cli_config = CliConfig(
        working_dir=Path.cwd(),
        command="generate",
        config_path=Path(config) if config else None,
        verbose=verbose,
    )

    # Convert to dict for compatibility with SnowBlower
    config_dict = cli_config.model_dump()

    # Initialize and run SnowBlower
    snow_blower = SnowBlower(config_dict, cli_config.working_dir)
    success = snow_blower.run(cli_config.command)

    if not success:
        click.echo("Failed to generate configuration")
        sys.exit(1)

    click.echo("Configuration generated successfully")


# Define the "template" command group
@cli.group("template")
def template_group():
    """Apply templates to your configuration."""


@template_group.command("list")
@click.argument("category", required=False)
def list_template_command(category):
    """List available templates."""
    templates = list_templates(category)

    if not templates:
        if category:
            click.echo(f"No templates found for category: {category}")
        else:
            click.echo("No templates found")
        return

    click.echo("Available templates:")
    for cat, template_list in templates.items():
        click.echo(f"\n{cat}:")
        for template in template_list:
            click.echo(f"  - {template}")


@template_group.command("apply")
@click.argument("category")
@click.argument("template_name")
@click.option(
    "--config",
    "-c",
    help="Path to the configuration file",
    type=click.Path(exists=True),
)
def apply_template_command(category, template_name, config):
    """Apply a template to your configuration."""
    try:
        # Load the template
        template_data = load_template(category, template_name)

        # Load the current configuration
        config_path = Path(config) if config else Path(ConfigParser.DEFAULT_CONFIG_FILE)
        if not config_path.exists():
            click.echo(f"Configuration file not found: {config_path}")
            sys.exit(1)

        # Apply the template to the configuration
        snow_blower = SnowBlower({}, Path.cwd())
        success = snow_blower.apply_template(category, template_name, config_path)

        if not success:
            click.echo(f"Failed to apply template {template_name} to {category}")
            sys.exit(1)

        click.echo(f"Successfully applied template {template_name} to {category}")

    except FileNotFoundError as e:
        click.echo(str(e))
        sys.exit(1)
    except Exception as e:
        click.echo(f"Error applying template: {e}")
        sys.exit(1)


# Add convenience commands for specific templates
@cli.command("ruff")
@click.argument("template_name")
@click.option(
    "--config",
    "-c",
    help="Path to the configuration file",
    type=click.Path(exists=True),
)
def ruff_template(template_name, config):
    """Apply a Ruff template to your configuration."""
    apply_template_command.callback("python/ruff", template_name, config)
