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

ARG USER_UID=${USER_UID:-1000}
ARG USER_GID=${USER_UID:-1000}
RUN groupadd --gid ${USER_GID} snowblower && \
    useradd --uid ${USER_UID} --gid ${USER_GID} -m snowblower -s /bin/bash && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/devcontainer && \
    chmod 0440 /etc/sudoers.d/devcontainer

COPY docker/nix.conf /etc/nix/nix.conf
RUN chmod 0664 /etc/nix/nix.conf

ARG NIX_INSTALL_SCRIPT=https://install.lix.systems/lix
RUN curl --proto '=https' --tlsv1.2 -sSf -L ${NIX_INSTALL_SCRIPT} | sh -s -- install linux \
    --init none \
    --no-confirm

ENV PATH="${PATH}:/nix/var/nix/profiles/default/bin"

# Change ownership of nix store to the user
RUN sudo chown -R snowblower: /nix

WORKDIR /workspace
RUN chown ${USER_UID}:${USER_UID} /workspace

COPY ./docker/with-nix.sh /usr/local/bin/with-nix
RUN chmod +x /usr/local/bin/with-nix

USER snowblower

# Copy the whole project to the workspace before build.
COPY . /workspace

RUN nix profile install '.#dockerPackage'

# Initialize shell environment variables.
RUN /home/snowblower/.nix-profile/bin/docker-entrypoint init

# Execute everything with the shell environment variables.
SHELL ["/home/snowblower/.nix-profile/bin/docker-entrypoint", "exec"]
ENTRYPOINT ["/home/snowblower/.nix-profile/bin/docker-entrypoint", "exec"]

# Drop into a shell by default.
CMD bash
