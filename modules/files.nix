{flake-parts-lib, ...}: let
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  options.perSystem = mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) types mkOption;

    cfg = lib.filterAttrs (_n: f: f.enable) config.snowblower.file;

    inherit
      ((import lib/fileType.nix {
        inherit lib pkgs;
      }))
      fileType
      ;

    sourceStorePath = file: let
      sourcePath = toString file.source;
      sourceName = config.lib.strings.storeFileName (baseNameOf sourcePath);
    in
      if builtins.hasContext sourcePath
      then file.source
      else
        builtins.path {
          path = file.source;
          name = sourceName;
        };
  in {
    options.snowblower = {
      file = mkOption {
        description = "Attribute set of files that will be created in the environment.";
        default = {};
        type = fileType "snowblower.file" "{env}`HOME`" "";
      };

      packages.files = mkOption {
        type = types.package;
        internal = true;
        description = "Package to contain and generate all files";
      };
    };

    config = {
      snowblower.packages.files = pkgs.writeScriptBin "snowblower-files" ''
        #!/usr/bin/env bash

        function insertFile() {
          local source="$1"
          local relTarget="$2"
          local executable="$3"

          mkdir -p "$(dirname "./$relTarget")"
          cp -f "$source" "./$relTarget"
          if [[ $executable == "1" ]]; then
            chmod +x "./$relTarget"
          fi
          echo "Created file: $relTarget"
        }

        ${lib.concatStrings (
          lib.mapAttrsToList (_n: v: ''
            insertFile ${
              lib.escapeShellArgs [
                (sourceStorePath v)
                v.target
                (
                  if v.executable == null
                  then "inherit"
                  else toString v.executable
                )
              ]
            }
          '')
          cfg
        )}

        echo "Files copied to current directory"
      '';

      packages = {
        snowblowerFiles = config.snowblower.packages.files;
      };
    };
  });
}
