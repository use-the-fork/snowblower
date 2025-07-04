FROM alpine
RUN apk add curl sudo xz git gcompat bash openssh-client
RUN echo "snowuser ALL = NOPASSWD: ALL" > /etc/sudoers

ARG USER_UID=1000
ARG USER_GID=${USER_UID}

RUN addgroup --gid "$USER_UID" snowuser
RUN adduser -D --uid "$USER_UID" --ingroup snowuser snowuser

RUN <<EOF
echo '#!/bin/bash
# If the nix store volume is empty, initialise it with whatever is in the base
# image. `/nix` itself might not be empty, e.g. GKE adds a `lost+found` folder.
# To circumvent this issue, it tests for the presence of `/nix/store` instead.
if [ ! -e /nix/store ]; then
  cp -Tdar /tmp/nix.orig /nix
fi

export USER=snowuser
source $HOME/.nix-profile/etc/profile.d/nix.sh

exec "$@"' > /entrypoint.sh
EOF

RUN chmod +x /entrypoint.sh

USER snowuser

# install nix
ARG NIX_INSTALL_SCRIPT=https://nixos.org/nix/install
RUN sh <(curl --proto '=https' --tlsv1.2 -L ${NIX_INSTALL_SCRIPT}) --no-daemon

RUN cp -r /nix /tmp/nix.orig

VOLUME /nix

RUN mkdir -p /home/snowuser/.config/nix/

RUN <<EOF
echo 'sandbox = false
experimental-features = nix-command flakes
accept-flake-config = true
keep-going = true
warn-dirty = false
substituters = https://cache.nixos.org https://nix-community.cachix.org https://nixpkgs-unfree.cachix.org
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs=
pure-eval = false' > /home/snowuser/.config/nix/nix.conf
EOF

WORKDIR /workspace

ENTRYPOINT ["bash", "/entrypoint.sh"]
