FROM debian:stable-slim

LABEL maintainer="use-the-fork <23747916+use-the-fork@users.noreply.github.com>"

# change build shell to /bin/bash, so env will be set correctly
SHELL ["/bin/bash", "-c"]

# make /bin/sh symlink to bash instead of dash:
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

# update and install base packages
RUN apt update -y
RUN apt -y install --no-install-recommends \
    sudo \
    ca-certificates \
    psmisc \
    procps \
    less \
    xz-utils \
    vim-tiny \
    curl \
    git \
    ssh \
    direnv \
    gnupg2 \
    iproute2 \
    inetutils-ping \
    rsync \
    lsb-release \
    dialog \
    locales \
    man-db \
    bash-completion \
    acl && \
    rm -rf /var/lib/apt/lists/*

# create at least locae for en_US.UTF-8
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen

# create non-root user and group and add it sudoers
ARG USERNAME=code
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
RUN groupadd --gid ${USER_GID} ${USERNAME} && \
    useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} -s /bin/bash && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/devcontainer && \
    chmod 0440 /etc/sudoers.d/devcontainer

# copy nix configuration
COPY etc/nix.conf /etc/nix/nix.conf

# install nix
ARG NIX_INSTALL_SCRIPT=https://nixos.org/nix/install
RUN curl -L ${NIX_INSTALL_SCRIPT} | sudo -u ${USERNAME} NIX_INSTALLER_NO_MODIFY_PROFILE=1 sh

ENV PATH="${PATH}:/nix/var/nix/profiles/default/bin"

# install devcontainer extra profile that loads nix and has vscode user env probe
COPY etc/devcontainer.sh /etc/profile.d/devcontainer.sh

# install bash config
COPY etc/bash.bashrc /etc/bash.bashrc

# set env for non interactve shell to load nix
COPY etc/envrc /etc/envrc
ENV ENV="/etc/envrc" BASH_ENV="/etc/envrc"

# copy direnv config and set conig path
COPY etc/direnv.toml /etc
ENV DIRENV_CONFIG=/etc

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# In theory, this should not be necessary. We should be able to run home-manager
# below with sudo and have it populate our home directory. However, this appear
# to be broken.
RUN sudo chown -R ${USERNAME}: /nix

# set defaut user, can be changed via ONBUILD triggers
USER ${USERNAME}

# Copy over our dot files and switch.
COPY flake /home/${USERNAME}/.config/flake

# Setup vscode
RUN mkdir -p /home/${USERNAME}/.vscode-server/extensions && \
    mkdir -p /home/${USERNAME}/.vscode-server-insiders/extensions

ENTRYPOINT [ "/docker-entrypoint.sh" ]

ONBUILD USER root

# Arguments for username and user_uid and user_gid that can be changed
ONBUILD ARG USERNAME=code
ONBUILD ARG USER_UID=1000
ONBUILD ARG USER_GID=${USER_UID}

# onbuild uid and gid fixes
ONBUILD RUN \
    if [ -z ${USER_UID} ] || [ -z ${USER_UID} ] || [ -z ${USERNAME} ]; then exit 0; fi && \
    set -x && \
    if [ "$(id -u code)" != "${USER_UID}" ] || [ "$(id -g code)" != "${USER_GID}" ]; then \
    groupmod -g ${USER_GID} -n ${USERNAME} code || true && \
    usermod -u ${USER_UID} -g ${USER_GID} -l ${USERNAME} -m -d /home/${USERNAME} code && \
    chown -R ${USER_UID}:${USER_GID} /nix && \
    chown -R ${USER_UID}:${USER_GID} /home/${USERNAME} && \
    echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/devcontainer; \
    fi

ONBUILD USER ${USERNAME}

ONBUILD ARG SNOW_BLOWER_CONFIG_PATH=flake/snow-blower-config.nix
ONBUILD COPY ${SNOW_BLOWER_CONFIG_PATH} /home/${USERNAME}/.config/flake/snow-blower-config.nix
ONBUILD RUN sudo chown -R ${USERNAME}: /home/${USERNAME}/.config

# switch to the flake package
ONBUILD RUN nix run home-manager/release-24.05 -- switch --flake ./home/${USERNAME}/.config/flake#${USERNAME}
