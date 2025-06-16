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

ARG USERNAME=${USERNAME:-snowblower}
ARG USER_UID=${USER_UID}
ARG USER_GID=${USER_GID}
RUN groupadd --gid ${USER_GID} ${USERNAME} && \
    useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} -s /bin/bash && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/devcontainer && \
    chmod 0440 /etc/sudoers.d/devcontainer

COPY docker/nix.conf /etc/nix/nix.conf
RUN chmod 0664 /etc/nix/nix.conf

ARG NIX_INSTALL_SCRIPT=https://install.lix.systems/lix
RUN curl --proto '=https' --tlsv1.2 -sSf -L ${NIX_INSTALL_SCRIPT} | sh -s -- install linux \
    --init none \
    --no-confirm

ENV PATH="${PATH}:/nix/var/nix/profiles/default/bin"

COPY docker/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

RUN sudo chown -R ${USERNAME}: /nix

USER ${USERNAME}