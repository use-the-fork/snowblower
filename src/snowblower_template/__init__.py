"""Templates package for SnowBlower."""

import os
from pathlib import Path
from typing import Any, Dict

import yaml


def get_template_path(category: str, name: str) -> Path:
    """Get the path to a template file.

    Args:
        category: The category of the template (e.g., 'python/ruff')
        name: The name of the template (e.g., 'standard', 'strict')

    Returns:
        Path to the template file
    """
    base_dir = Path(__file__).parent
    return base_dir / category / f"{name}.yml"


def load_template(category: str, name: str) -> dict[str, Any]:
    """Load a template from a YAML file.

    Args:
        category: The category of the template
        name: The name of the template

    Returns:
        The template configuration

    Raises:
        FileNotFoundError: If the template file doesn't exist
    """
    template_path = get_template_path(category, name)

    if not template_path.exists():
        raise FileNotFoundError(f"Template '{name}' not found in category '{category}'")

    with open(template_path) as f:
        return yaml.safe_load(f)


def list_templates(category: str = None) -> dict[str, list]:
    """List available templates.

    Args:
        category: Optional category to filter by

    Returns:
        Dictionary of categories and their templates
    """
    base_dir = Path(__file__).parent
    result = {}

    # If category is specified, only look in that directory
    if category:
        category_dir = base_dir / category
        if not category_dir.exists() or not category_dir.is_dir():
            return {}

        templates = [f.stem for f in category_dir.glob("*.yml")]
        return {category: templates}

    # Otherwise, scan all directories
    for root, dirs, files in os.walk(base_dir):
        rel_path = Path(root).relative_to(base_dir)
        if rel_path == Path():
            continue

        yml_files = [f for f in files if f.endswith(".yml")]
        if yml_files:
            category = str(rel_path).replace(os.sep, "/")
            result[category] = [Path(f).stem for f in yml_files]

    return result
