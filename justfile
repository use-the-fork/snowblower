import 'just-flake.just'

# Display the list of recipes
default:
    @just --list

# Start AIder AI assitant
ai:
    @aider --model sonnet --watch-files --no-suggest-shell-commands --no-detect-urls --git-commit-verify --read "README.md" --read "pyproject.toml"

# Build the Nix options documentation and prepare files for VitePress
build-docs:
    @echo "Building Nix options documentation..."
    @python3 ./generate_docs.py

# Run the VitePress development server
docs-dev: build-docs
    @echo "Starting VitePress dev server..."
    @npm run docs:dev

# Build the VitePress site
docs-build: build-docs
    @echo "Building VitePress site..."
    @npm run docs:build

# Preview the built VitePress site
docs-preview:
    @echo "Previewing VitePress site..."
    @npm run docs:preview


# nix build .#homeConfigurations."your.name".activationPackage