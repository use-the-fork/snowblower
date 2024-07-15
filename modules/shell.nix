topLevel@{ inputs, flake-parts-lib, ... }: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.shell = flakeModule: {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({ lib, pkgs, config, ... }: let
     inherit (lib) types mkOption;

    in {

      options.snow-blower.shell = {

              shellPreHook = mkOption {
                type = types.lines;
                description = "Bash code to execute when entering the shell.";
                default = "";
              };

              shellPostHook = mkOption {
                type = types.lines;
                description = "Bash code to execute when entering the shell but after `shellPreHook`.";
                default = "";
              };

              packages = mkOption {
                type = types.listOf types.package;
                description = "A list of packages to expose inside the developer environment. See https://search.nixos.org/packages for packages.";
                default = [ ];
              };

              stdenv = mkOption {
                type = types.package;
                description = "The stdenv to use for the developer environment.";
                default = pkgs.stdenv;
              };

              shell = mkOption {
                type = types.package;
                internal = true;
              };

            # Outputs
            build = {
              devShell = mkOption {
                description = "The development shell with Snow Blower and its underlying programs";
                type = types.package;
                readOnly = true;
              };
            };
          };


      config.devShells.default = (pkgs.mkShell) {
                                shellHook = ''
                                        ${config.snow-blower.shell.shellPreHook}
                                        ${config.snow-blower.shell.shellPostHook}
                                  echo
                                  echo "Snow Blower: Simple, Fast, Declarative, Reproducible, and Composable Developer Environments"
                                  echo
                                  echo "Run 'just <recipe>' to get started"
                                '';
                              };

    });



  };
}
