topLevel @ {
  inputs,
  flake-parts-lib,
  self,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
    ./nixpkgs.nix
    ./integrations
    ./languages
    ./services
    ./process-compose.nix
    ./shell.nix
  ];
  flake.flakeModules.common = flakeModule: {
    imports = [
      topLevel.config.flake.flakeModules.nixpkgs

      topLevel.config.flake.flakeModules.integrations-git-hooks
      topLevel.config.flake.flakeModules.integrations-just
      topLevel.config.flake.flakeModules.integrations-tree-fmt

      topLevel.config.flake.flakeModules.process-compose

      topLevel.config.flake.flakeModules.languages-php


      topLevel.config.flake.flakeModules.services-adminer
      topLevel.config.flake.flakeModules.services-mysql

      topLevel.config.flake.flakeModules.shell

      inputs.process-compose-flake.flakeModule
    ];


        options.perSystem = flake-parts-lib.mkPerSystemOption ({
          lib,
          pkgs,
          config,
          ...
        }: let
          inherit (lib) types mkOption;

            drvOrPackageToPaths = drvOrPackage:
              if drvOrPackage ? outputs then
                builtins.map (output: drvOrPackage.${output}) drvOrPackage.outputs
              else
                [ drvOrPackage ];

            profile = pkgs.buildEnv {
              name = "devenv-profile";
              paths = lib.flatten (builtins.map drvOrPackageToPaths config.packages);
              ignoreCollisions = true;
            };

        in {
          options.snow-blower = {

            env = lib.mkOption {
              type = types.submoduleWith {
                modules = [
                  (env: {
                    config._module.freeformType = types.lazyAttrsOf types.anything;
                  })
                ];
              };
              description = "Environment variables to be exposed inside the developer environment.";
              default = { };
            };

            packages = mkOption {
              type = types.listOf types.package;
              description = "A list of packages to expose inside the developer environment. See https://search.nixos.org/packages for packages.";
              default = [];
            };

            config = {

                  root = lib.mkOption {
                    type = types.str;
                    internal = true;
                    default = builtins.getEnv "PWD";
                  };

                  dotfile = lib.mkOption {
                    type = types.str;
                    internal = true;
                  };

                  state = lib.mkOption {
                    type = types.str;
                    internal = true;
                  };

                  runtime = lib.mkOption {
                    type = types.str;
                    internal = true;
                    # The path has to be
                    # - unique to each DEVENV_STATE to let multiple devenv environments coexist
                    # - deterministic so that it won't change constantly
                    # - short so that unix domain sockets won't hit the path length limit
                    # - free to create as an unprivileged user across OSes
                    default =
                      let
                        runtimeEnv = builtins.getEnv "DEVENV_RUNTIME";

                        hashedRoot = builtins.hashString "sha256" config.snow-blower.config.state;

                        # same length as git's abbreviated commit hashes
                        shortHash = builtins.substring 0 7 hashedRoot;
                      in
                      if runtimeEnv != ""
                      then runtimeEnv
                      else "${config.snow-blower.config.tmpdir}/devenv-${shortHash}";
                  };

                  tmpdir = lib.mkOption {
                    type = types.str;
                    internal = true;
                    default =
                      let
                        xdg = builtins.getEnv "XDG_RUNTIME_DIR";
                        tmp = builtins.getEnv "TMPDIR";
                      in
                      if xdg != "" then xdg else if tmp != "" then tmp else "/tmp";
                  };

                  profile = lib.mkOption {
                    type = types.package;
                    internal = true;
                  };

            };


          };

          config = {
            nixpkgs.config.allowUnsupportedSystem = true;
            snow-blower.config.state =  builtins.toPath (self + "/state");
            snow-blower.config.dotfile = lib.mkDefault (builtins.toPath (self + "/.devenv"));
            snow-blower.config.profile = profile;
          };
        });

  };
}
