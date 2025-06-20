# Stage 1: Nix builder
# This will build our environment and cach parts for faster rebuilds.
FROM nixos/nix:latest AS builder

# Copy our source and setup our working dir.
COPY . /tmp/build
WORKDIR /tmp/build
RUN mkdir /tmp/nix-store-closure

# build our env and copy it to nix-store-closure.
RUN \
    --mount=type=cache,target=/nix,from=nixos/nix:latest,source=/nix \
    --mount=type=cache,target=/root/.cache \
    --mount=type=bind,target=/tmp/build \
    nix \
    --extra-experimental-features "nix-command flakes" \
    --accept-flake-config \
    --show-trace \
    --log-format raw \
    build .#dockerPackage --out-link /tmp/output/result && \                                                 
    cp -r $(nix-store -qR /tmp/output/result) /tmp/nix-store-closure && \
    cp -r /tmp/output/result /tmp/nix-store-closure/env

# Build is done now we build our working env
FROM debian:stable-slim
COPY --from=builder /tmp/nix-store-closure /nix/store

# Stage 2: Setup Debian and put our nix closure in the path
FROM debian:stable-slim

RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

RUN apt update -y && \
    apt -y install --no-install-recommends \
    sudo \
    ca-certificates \
    curl \
    locales \
    git \
    acl && \
    rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen

# We run this later so that apt gets cached as a layer.
COPY --from=builder /tmp/nix-store-closure /nix/store
ENV PATH="/nix/store/env/bin:$PATH"

ARG USER_UID=${USER_UID:-1000}
ARG USER_GID=${USER_UID:-1000}
RUN groupadd --gid ${USER_GID} snowblower && \
    useradd --uid ${USER_UID} --gid ${USER_GID} -m snowblower -s /bin/bash && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/devcontainer && \
    chmod 0440 /etc/sudoers.d/devcontainer

WORKDIR /workspace
RUN chown ${USER_UID}:${USER_GID} /workspace

USER snowblower