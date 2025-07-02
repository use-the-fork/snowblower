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
      snowblower = {
        filesPackage = pkgs.writeScriptBin "snowblower-files" ''
          ${builtins.readFile config.snowblower.utilitiesPackage}

          doSetupColors

          function insertFile() {
            local source="$1"
            local relTarget="$2"
            local executable="$3"

            # Check if the path is not already within the project root or src root
            if [[ $relTarget != "$SB_PROJECT_ROOT"* && $relTarget != "$SB_SRC_ROOT"* ]]; then
              relTarget="''${SB_SRC_ROOT}/''${relTarget}"
            fi

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
            _iNote "Created %s" "$relTarget"

          }

          _iSnow "Generate Files"

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

          _iOk "File Generation Complete"

          _iWithSpinner "Format snow" ${lib.getExe pkgs.shfmt} -s -w snow

          _iOk "Files copied to current directory"

          ${builtins.readFile ./../lib-bash/file-creation.sh}
          ${builtins.readFile config.snowblower.directoriesPackage}
          ${builtins.readFile config.snowblower.touchFilesPackage}

          _iHeart "Operation Complete"
        '';

        directoriesPackage = pkgs.writeTextFile {
          name = "snowblower-directories";
          text = ''
            _iSnow "Creating Directories"
            ${lib.concatStrings (
              map (dir: ''
                doCreateDirectory ${lib.escapeShellArgs [dir]}
              '')
              config.snowblower.directories
            )}
          '';
        };

        touchFilesPackage = pkgs.writeTextFile {
          name = "snowblower-touch-files";
          text = ''
            _iSnow "Creating Touch Files"
            ${lib.concatStrings (
              map (file: ''
                doCreateTouchFile ${lib.escapeShellArgs [file]}
              '')
              config.snowblower.touchFiles
            )}
          '';
        };

        # this have to be here as well otherwise key pkgs are missing from the final build and as a result snow switch dosen't work.
        packages.tools = [
          config.snowblower.filesPackage
        ];
      };

      # If you run nix locally you can use this instead `nix run .#snowblowerFiles -L`
      packages = {
        snowblowerFiles = config.snowblower.filesPackage;
      };
    };
  });
}
