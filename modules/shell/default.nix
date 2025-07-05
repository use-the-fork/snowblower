{flake-parts-lib, ...}: let
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  imports = [
    # keep-sorted start
    ./atuin.nix
    ./starship.nix
    ./zsh.nix
    # keep-sorted end
  ];

  options.perSystem = mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) types mkOption;
  in {
    options.snowblower = {
      utilitiesPackage = mkOption {
        internal = true;
        type = types.package;
        description = "The package containing the utility scripts that can be shared among packages.";
      };
    };

    config = {
      snowblower = {
        utilitiesPackage = pkgs.writeTextFile {
          name = "sb-utils-package";
          text = ''
            ${builtins.readFile ./../../lib-bash/utils/head.sh}

            # keep-sorted start
            ${builtins.readFile ./../../lib-bash/checks.sh}
            ${builtins.readFile ./../../lib-bash/utils/checks.sh}
            ${builtins.readFile ./../../lib-bash/utils/color.sh}
            ${builtins.readFile ./../../lib-bash/utils/file.sh}
            ${builtins.readFile ./../../lib-bash/utils/input.sh}
            ${builtins.readFile ./../../lib-bash/utils/output.sh}
            # keep-sorted end
          '';
        };
      };
    };
  });
}
