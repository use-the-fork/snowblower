topLevel @ {
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules

    ./core
    ./env
    ./integrations
    ./just
    ./languages
    ./docker-compose
    ./code-quality
    ./services
    ./processes
    ./scripts
    ./shell
  ];
  flake.flakeModules.default = _flakeModule: {
    imports = [
      # The Must Haves
      # Core is the primary entrypoint to the snowblower package.
      topLevel.config.flake.flakeModules.core
      # topLevel.config.flake.flakeModules.nixpkgs
      topLevel.config.flake.flakeModules.env

      # Yes, just can be considered an integration however since
      # it's used in most integrations as well as other submodules
      # I see it as more of a core function.
      topLevel.config.flake.flakeModules.just

      topLevel.config.flake.flakeModules.integrations
      topLevel.config.flake.flakeModules.scripts
      topLevel.config.flake.flakeModules.processes
      topLevel.config.flake.flakeModules.languages
      topLevel.config.flake.flakeModules.services

      topLevel.config.flake.flakeModules.docker-compose
      topLevel.config.flake.flakeModules.codeQuality

      topLevel.config.flake.flakeModules.shell
    ];

    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      config,
      ...
    }: let
      inherit (lib) types mkOption;
    in {
      options.snowblower = {
        packages = mkOption {
          type = types.listOf types.package;
          description = "A list of packages to expose inside the developer environment. See https://search.nixos.org/packages for packages.";
          default = [];
        };

        paths = {
          src = lib.mkOption {
            type = types.path;
            internal = true;
          };

          root = lib.mkOption {
            type = types.str;
            internal = true;
            default = builtins.getEnv "SNOWBLOWER_ROOT";
          };

          snowblowerDir = lib.mkOption {
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
            # - unique to each PROJECT_STATE to let multiple snowblower environments coexist
            # - deterministic so that it won't change constantly
            # - short so that unix domain sockets won't hit the path length limit
            # - free to create as an unprivileged user across OSes
            default = let
              runtimeEnv = builtins.getEnv "PROJECT_RUNTIME";

              hashedRoot = builtins.hashString "sha256" config.snowblower.paths.state;

              # same length as git's abbreviated commit hashes
              shortHash = builtins.substring 0 7 hashedRoot;
            in
              if runtimeEnv != ""
              then runtimeEnv
              else "${config.snowblower.paths.tmpdir}/sb-runtime-${shortHash}";
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
        snowblower = {};
        packages = {
          "snowblower" = config.snowblower.core.build;
          "process-compose-up" = config.snowblower.process-compose.internals.procfileScript;
        };
      };
    });
  };
}
