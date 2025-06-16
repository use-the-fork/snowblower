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
      ((import ./../lib/fileType.nix {
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

      directories = mkOption {
        description = "List of directories that will be created in the environment.";
        default = [];
        type = types.listOf types.str;
      };

      touchFiles = mkOption {
        description = "List of empty files that will be created (touched) in the environment.";
        default = [];
        type = types.listOf types.str;
      };

      touchFilesPackage = mkOption {
        type = types.package;
        internal = true;
        description = "Package to contain and generate all touch files";
      };

      filesPackage = mkOption {
        type = types.package;
        internal = true;
        description = "Package to contain and generate all files";
      };

      directoriesPackage = mkOption {
        type = types.package;
        internal = true;
        description = "Package to contain all directories that need to be generated";
      };
    };

    config = {
      snowblower.filesPackage = pkgs.writeScriptBin "snowblower-files" ''
        #!/usr/bin/env bash

        function insertFile() {
          local source="$1"
          local relTarget="$2"
          local executable="$3"

          mkdir -p "$(dirname "./$relTarget")"

          # Check if source is a directory and use -r flag if needed
          if [ -d "$source" ]; then
            cp -rf "$source" "./$relTarget"
          else
            cp -f "$source" "./$relTarget"
          fi

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

      snowblower.directoriesPackage = pkgs.writeTextFile {
        name = "snowblower-directories";
        text = ''
          function __sb__createDirectories() {
            statusEcho "OK" "Creating Directories" "''${SB_PROJECT_ROOT}"
            ${lib.concatStrings (
            map (dir: ''
              __sb__createDirectory ${lib.escapeShellArgs [dir]}
            '')
            config.snowblower.directories
          )}
          }
        '';
      };

      snowblower.touchFilesPackage = pkgs.writeTextFile {
        name = "snowblower-touch-files";
        text = ''
          function __sb__createTouchFiles() {
            statusEcho "OK" "Creating Touch Files" "''${SB_PROJECT_ROOT}"
            ${lib.concatStrings (
            map (file: ''
              __sb__createTouchFile ${lib.escapeShellArgs [file]}
            '')
            config.snowblower.touchFiles
          )}
          }
        '';
      };

      packages = {
        snowblowerFiles = config.snowblower.filesPackage;
      };
    };
  });
}
