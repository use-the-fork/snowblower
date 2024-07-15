topLevel @ {
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
    ./env
    ./nixpkgs.nix
    ./integrations
    ./languages
    ./services
    ./processes
    ./scripts
    ./shell.nix
  ];
  flake.flakeModules.common = flakeModule: {
    imports = [
      #The Must Haves
      topLevel.config.flake.flakeModules.nixpkgs
      topLevel.config.flake.flakeModules.env

      topLevel.config.flake.flakeModules.integrations
      topLevel.config.flake.flakeModules.scripts
      topLevel.config.flake.flakeModules.processes
      topLevel.config.flake.flakeModules.languages
      topLevel.config.flake.flakeModules.services

      topLevel.config.flake.flakeModules.shell

      # how we run this ishh.
      inputs.process-compose-flake.flakeModule
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

        internals = {
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
            default = let
              runtimeEnv = builtins.getEnv "PRJ_ROOT";

              hashedRoot = builtins.hashString "sha256" config.snow-blower.internals.state;

              # same length as git's abbreviated commit hashes
              shortHash = builtins.substring 0 7 hashedRoot;
            in
              if runtimeEnv != ""
              then runtimeEnv
              else "${config.snow-blower.internals.tmpdir}/devenv-${shortHash}";
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

          profile = lib.mkOption {
            type = types.package;
            internal = true;
          };
        };
      };

      config = {
        nixpkgs.config.allowUnsupportedSystem = true;

        snow-blower = {
          internals.state = builtins.toPath (config.snow-blower.internals.dotfile + "/state");
          internals.dotfile = lib.mkDefault (builtins.toPath (config.snow-blower.internals.root + "/.snow-blower"));
          internals.profile = profile;

          shell.startup = ''

            # note what environments are active, but make sure we don't repeat them
            if [[ ! "''${SNOWBLOWER_ACTIVE-}" =~ (^|:)"$PWD"(:|$) ]]; then
              export SNOWBLOWER_ACTIVE="$PWD:''${SNOWBLOWER_ACTIVE-}"
            fi

            # devenv helper
            if [ ! type -p snow-blower &>/dev/null && -f .envrc ]; then
              echo "You have .envrc but snow-blower command is not installed."
              echo "Please install snow-blower: https://direnv.net/docs/installation.html"
            fi

            mkdir -p "$FLAKE_ROOT/.snow-blower"

          '';
        };
      };
    });
  };
}
