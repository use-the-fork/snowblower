FROM docker.io/use-the-fork/snow-blower-devcontainer:latest
# FROM ghcr.io/use-the-fork/snow-blower-devcontainer:latest
# FROM localhost/use-the-fork/snow-blower-devcontainer:latest

# cache /nix
VOLUME /nix

# We need this to install direnv and any top level devcontainer requirments.
RUN \
    nix-channel --add https://nixos.org/channels/nixos-unstable unstable && \
    nix-channel --update unstable && \
    nix-env -iA unstable.nix-direnv

# RUN nix run home-manager -- switch --flake /home/${USERNAME}/.config/flake#snowblower && \
#     nix-collect-garbage