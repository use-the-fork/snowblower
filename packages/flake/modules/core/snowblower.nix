{
  pkgs,
  config,
  ...
}: let
  snowblower = pkgs.writeShellApplication {
    name = "snow";
    runtimeInputs = [];
    text = ''
      ${builtins.readFile ./lib-bash/activation-init.sh}

      ${config.snowblower.core.scripts.environment}
      #A few extra environment vars that should not be set or passed to docker.
      export APP_USER=''${APP_USER:-"snowblower"}
      export USER_UID=''${USER_UID:-$UID}
      export USER_GID=''${USER_GID:-$(id -g)}


      ${builtins.readFile ./lib-bash/help.sh}
      ${builtins.readFile ./lib-bash/commands.sh}
    '';
  };
in
  snowblower
