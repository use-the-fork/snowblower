#!/bin/sh
# If the nix store volume is empty, initialise it with whatever is in the base
# image. `/nix` itself might not be empty, e.g. GKE adds a `lost+found` folder.
# To circumvent this issue, it tests for the presence of `/nix/store` instead.
if [ ! -e /nix/store ]; then
	cp -Tdar /tmp/nix.orig /nix
fi

export USER=snowuser
source $HOME/.nix-profile/etc/profile.d/nix.sh

exec "$@"
