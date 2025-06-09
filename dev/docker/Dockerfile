FROM docker.io/use-the-fork/snowblower-base:latest

COPY flake.nix /home/${USERNAME}/flake.nix
COPY flake.lock /home/${USERNAME}/flake.lock

RUN nix profile install /home/${USERNAME}#snowblower-container