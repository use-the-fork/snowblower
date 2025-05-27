import os
import sys
from pathlib import Path

import click
from pydantic import BaseModel, Field

from snowblower_cli.snowblower import SnowBlower


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
