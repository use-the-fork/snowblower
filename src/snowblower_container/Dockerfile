
FROM debian:stable-slim

LABEL maintainer="use-the-fork <23747916+use-the-fork@users.noreply.github.com>"

SHELL ["/bin/bash", "-c"]

RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

RUN apt update -y && \
    apt -y install --no-install-recommends \
    sudo \
    ca-certificates \
    curl \
    git \
    locales \
    acl && \
    rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen

ARG USERNAME=code
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
RUN groupadd --gid ${USER_GID} ${USERNAME} && \
    useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} -s /bin/bash && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/devcontainer && \
    chmod 0440 /etc/sudoers.d/devcontainer

COPY etc/nix.conf /etc/nix/nix.conf
RUN chmod 0664 /etc/nix/nix.conf

ARG NIX_INSTALL_SCRIPT=https://install.lix.systems/lix
RUN curl --proto '=https' --tlsv1.2 -sSf -L ${NIX_INSTALL_SCRIPT} | sh -s -- install linux \
    --init none \
    --no-confirm

ENV PATH="${PATH}:/nix/var/nix/profiles/default/bin"

COPY etc/devcontainer.sh /etc/profile.d/devcontainer.sh
COPY etc/bash.bashrc /etc/bash.bashrc
COPY etc/envrc /etc/envrc
ENV ENV="/etc/envrc" BASH_ENV="/etc/envrc"

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

RUN sudo chown -R ${USERNAME}: /nix

USER ${USERNAME}

COPY flake /home/${USERNAME}/.config/flake

RUN mkdir -p /home/${USERNAME}/.vscode-server/extensions && \
    mkdir -p /home/${USERNAME}/.vscode-server-insiders/extensions

ENTRYPOINT [ "/docker-entrypoint.sh" ]
