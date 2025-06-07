{
  pkgs,
  lib,
  config,
  ...
}: let
  configfiles = lib.concatStringsSep "\n" (map (file: ''
      cp -f ${builtins.toString (file.format.generate file.name file.settings)} ./${file.name}
    '')
    config.snow-blower.wrapper.files.config);

  wrapper = pkgs.writeShellApplication {
    name = "snowblower";
    text = ''
      __snowblower_generate_config_files () {
        ${configfiles}
      }
      __snowblower_generate_config_files
    '';
  };
in
  wrapper
