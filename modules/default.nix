topLevel @ {
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
    ./env
    ./lib
    ./nixpkgs.nix
    ./integrations
    ./languages
    ./services
    ./processes
    ./scripts
    ./shell
  ];
  flake.flakeModules.default = flakeModule: {
    imports = [
      #The Must Haves
      topLevel.config.flake.flakeModules.lib
      topLevel.config.flake.flakeModules.nixpkgs
      topLevel.config.flake.flakeModules.env

      topLevel.config.flake.flakeModules.integrations
      topLevel.config.flake.flakeModules.scripts
      topLevel.config.flake.flakeModules.processes
      topLevel.config.flake.flakeModules.languages
      topLevel.config.flake.flakeModules.services

      topLevel.config.flake.flakeModules.shell

      #this gives us the avility to $FLAKE_ROOT as a env varible to be able to get at the root of the flake we are developing in.
      inputs.flake-root.flakeModule
    ];

    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      pkgs,
      config,
      ...
    }: let
      inherit (lib) types mkOption;

      drvOrPackageToPaths = drvOrPackage:
        if drvOrPackage ? outputs
        then builtins.map (output: drvOrPackage.${output}) drvOrPackage.outputs
        else [drvOrPackage];

      profile = pkgs.buildEnv {
        name = "devenv-profile";
        paths = lib.flatten (builtins.map drvOrPackageToPaths config.snow-blower.packages);
        ignoreCollisions = true;
      };
    in {
      options.snow-blower = {
        packages = mkOption {
          type = types.listOf types.package;
          description = "A list of packages to expose inside the developer environment. See https://search.nixos.org/packages for packages.";
          default = [];
        };

        paths = {
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

          profile = lib.mkOption {
            type = types.package;
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
            default = let
              runtimeEnv = builtins.getEnv "PROJECT_RUNTIME";

              hashedRoot = builtins.hashString "sha256" config.snow-blower.paths.state;

              # same length as git's abbreviated commit hashes
              shortHash = builtins.substring 0 7 hashedRoot;
            in
              if runtimeEnv != ""
              then runtimeEnv
              else "${config.snow-blower.paths.tmpdir}/sb-runtime-${shortHash}";
          };

          tmpdir = lib.mkOption {
            type = types.str;
            internal = true;
            default = let
              xdg = builtins.getEnv "XDG_RUNTIME_DIR";
              tmp = builtins.getEnv "TMPDIR";
            in
              if xdg != ""
              then xdg
              else if tmp != ""
              then tmp
              else "/tmp";
          };
        };
      };

      config = {
        nixpkgs.config.allowUnsupportedSystem = true;
        packages = {
          "process-compose-up" = config.snow-blower.process-compose.internals.procfileScript;
        };
      };
    });
  };
}
