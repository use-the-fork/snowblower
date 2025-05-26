import os

import click
from dataclasses import dataclass


@dataclass
class RunConfig:
    """"""

    name: str


# Create the main command group for the CLI
@click.group(context_settings={"auto_envvar_prefix": "SNOWBLOWER"})
@click.version_option(prog_name="snowblower")
def cli():
    return


# Define the "run" command for Chainlit CLI
@cli.command("init")
def snowblower_init():
    run_snowblower()
