FROM docker.io/use-the-fork/snowblower-base:latest

ENV IS_NIX_SHELL=1
ENV IS_DOCKER=1

COPY flake.nix /home/${USERNAME}/flake.nix
COPY flake.lock /home/${USERNAME}/flake.lock

RUN nix profile install /home/${USERNAME}#snowblowerDocker
