import 'just-flake.just'

# Display the list of recipes
default:
    @just --list

# Build the Nix options documentation and prepare files for VitePress
build-docs:
    @echo "Building Nix options documentation..."
    @nix build .#options-doc -L --show-trace --accept-flake-config

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
