FROM alpine
RUN apk add curl sudo xz git gcompat bash openssh-client
RUN echo "snowuser ALL = NOPASSWD: ALL" > /etc/sudoers

ARG USER_UID=1000
ARG USER_GID=${USER_UID}

RUN addgroup --gid "$USER_UID" snowuser
RUN adduser -D --uid "$USER_UID" --ingroup snowuser snowuser
USER snowuser

# install nix
ARG NIX_INSTALL_SCRIPT=https://nixos.org/nix/install
RUN sh <(curl --proto '=https' --tlsv1.2 -L ${NIX_INSTALL_SCRIPT}) --no-daemon

RUN cp -r /nix /tmp/nix.orig

VOLUME /nix

RUN mkdir -p /home/snowuser/.config/nix/
RUN echo "sandbox = false" >> /home/snowuser/.config/nix/nix.conf && \
    echo "experimental-features = nix-command flakes" >> /home/snowuser/.config/nix/nix.conf && \
    echo "accept-flake-config = true" >> /home/snowuser/.config/nix/nix.conf && \
    echo "substituters = https://cache.nixos.org https://nix-community.cachix.org https://nixpkgs-unfree.cachix.org" >> /home/snowuser/.config/nix/nix.conf && \
    echo "trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs=" >> /home/snowuser/.config/nix/nix.conf

WORKDIR /workspace

COPY docker/builder-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["sh", "/entrypoint.sh"]
