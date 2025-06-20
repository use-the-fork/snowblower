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
    inherit (lib.types) listOf;
  in {
    options.snowblower = {
      devShellPackage = mkOption {
        internal = true;
        type = types.package;
        description = "The package containing the complete activation script.";
      };

      entrypointPackage = mkOption {
        internal = true;
        type = types.package;
        description = "The package containing the complete activation script.";
      };
    };

    config = {
      snowblower = {
        entrypointPackage = pkgs.writeShellScriptBin "snow-entrypoint" ''
          ${builtins.readFile ./../lib-bash/utils/head.sh}

          # keep-sorted start
          ${builtins.readFile ./../lib-bash/utils/checks.sh}
          ${builtins.readFile ./../lib-bash/utils/color.sh}
          ${builtins.readFile ./../lib-bash/utils/file.sh}
          ${builtins.readFile ./../lib-bash/utils/output.sh}
          # keep-sorted end

          export SB_IN_SHELL=1

          _iOk "Inside Shell"

          exec "$@"
        '';

        packages = [
          config.snowblower.entrypointPackage
        ];

        devShellPackage = pkgs.mkShell {
          name = "snowblower";
          inherit (config.snowblower) packages;
          shellHook = ''
            export PATH=$PWD/.snowblower/profile:$PATH
            export SB_IN_SHELL=1
          '';
        };
      };

      devShells.default = config.snowblower.devShellPackage;
      packages = {
        snowblowerDevShell = config.snowblower.devShellPackage;
      };
    };
  });
}
