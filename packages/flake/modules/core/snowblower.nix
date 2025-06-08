{
  pkgs,
  config,
  ...
}: let
  snowblower = pkgs.writeShellApplication {
    name = "snow";
    runtimeInputs = [config.snowblower.core.packages.environment];
    text = ''
      snowblower-setup-environment

      ${builtins.readFile ./lib-bash/activation-init.sh}
      ${builtins.readFile ./lib-bash/help.sh}
      ${builtins.readFile ./lib-bash/commands.sh}
    '';
  };
in
  snowblower
