#!/bin/bash

source ~/nix-environment
exec gosu $USER_UID "$@"