# The core snowblower package IE "snow"
{flake-parts-lib, ...}: let
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  options.perSystem = mkPerSystemOption ({
    config,
    pkgs,
    ...
  }: let
    snowPackage = pkgs.writeScript "snow" ''
      #!/usr/bin/env bash

      ${builtins.readFile ./lib-bash/activation-init.sh}

      #A few extra environment vars that should not be set or passed to docker.
      export APP_USER=''${APP_USER:-"snowblower"}
      export USER_UID=''${USER_UID:-$UID}
      export USER_GID=''${USER_GID:-$(id -g)}

      echo "here";
    '';
  in {
    options.snowblower = {
    };

    config = {
      snowblower.file."snow" = {
        enable = true;
        source = snowPackage;
      };
    };
  });
}
