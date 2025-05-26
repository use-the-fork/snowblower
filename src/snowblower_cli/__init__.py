import os
from pathlib import Path

from dotenv import load_dotenv

# ruff: noqa: E402
# Keep this here to ensure imports have environment available.
env_file = os.getenv("SNOWBLOWER_ENV_FILE", ".env")
env_found = load_dotenv(dotenv_path=Path.cwd() / env_file)

from snowblower_cli.logger import logger

if env_found:
    logger.info(f"Loaded {env_file} file")
