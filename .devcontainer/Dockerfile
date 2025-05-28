# FROM docker.io/use-the-fork/snow-blower-devcontainer:latest
# FROM ghcr.io/use-the-fork/snow-blower-devcontainer:latest
FROM localhost/use-the-fork/snow-blower-devcontainer:latest

ARG SNOWBLOWER_CONFIG_PATH=.devcontainer/configuration.nix
ARG USERNAME=code

COPY ${SNOWBLOWER_CONFIG_PATH} /home/${USERNAME}/.config/flake/configuration.nix

RUN sudo chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.config

RUN nix run home-manager -- switch --flake /home/${USERNAME}/.config/flake#snowblower && \
    nix-collect-garbage
