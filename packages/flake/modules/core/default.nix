{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
    ./files.nix
  ];
  flake.flakeModules.core = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      config,
      pkgs,
      ...
    }: let
      inherit (lib) types mkOption;

      textFormat = {
        generate = _name: content: pkgs.writeText "snow" content;
      };
    in {
      options.snowblower.core = {
        build = mkOption {
          type = types.package;
          description = ''
            The generated snowblower package.
          '';
          default = import ./snowblower.nix {
            inherit pkgs lib config;
          };
          internal = true;
        };
      };

      # We also want to write our shell application to our project so non nix users can still utilize commands etc.
      config.snowblower.core.files."snow" = let
        originalContent = builtins.readFile "${config.snowblower.core.build}/bin/snow";
        # # Get all lines except the first one (shebang)
        # contentLines = builtins.split "\n" originalContent;
        # contentWithoutFirstLine = builtins.concatStringsSep "\n" (builtins.tail contentLines);
        # # Add a portable shebang
        # contentWithPortableShebang = "#!/usr/bin/env bash\n" + contentWithoutFirstLine;
      in {
        format = textFormat;
        settings = originalContent;
      };
    });
  };
}
