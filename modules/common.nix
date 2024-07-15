topLevel @ {
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
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
      topLevel.config.flake.flakeModules.nixpkgs

      topLevel.config.flake.flakeModules.integrations
      topLevel.config.flake.flakeModules.scripts
      topLevel.config.flake.flakeModules.processes
      topLevel.config.flake.flakeModules.languages
      topLevel.config.flake.flakeModules.services


      topLevel.config.flake.flakeModules.shell

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
        env = lib.mkOption {
          type = types.submoduleWith {
            modules = [
              (_env: {
                config._module.freeformType = types.lazyAttrsOf types.anything;
              })
            ];
          };
          description = "Environment variables to be exposed inside the developer environment.";
          default = {};
        };

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
              runtimeEnv = builtins.getEnv "SNOWBLOWER_RUNTIME";

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
          internals.dotfile = lib.mkDefault (builtins.toPath (config.snow-blower.internals.root + "/.devenv"));
          internals.profile = profile;

          env.SNOWBLOWER_PROFILE = config.snow-blower.internals.profile;
          env.SNOWBLOWER_STATE = config.snow-blower.internals.state;
          env.SNOWBLOWER_RUNTIME = config.snow-blower.internals.runtime;
          env.SNOWBLOWER_DOTFILE = config.snow-blower.internals.dotfile;
          env.SNOWBLOWER_ROOT = config.snow-blower.internals.root;


          shell.shellPreHook = ''
            FLAKE_ROOT="''$(${lib.getExe config.flake-root.package})"
            export FLAKE_ROOT

            export PS1="\[\e[0;34m\](devenv)\[\e[0m\] ''${PS1-}"

            # set path to locales on non-NixOS Linux hosts
            ${lib.optionalString (pkgs.stdenv.isLinux && (pkgs.glibcLocalesUtf8 != null)) ''
              if [ -z "''${LOCALE_ARCHIVE-}" ]; then
                export LOCALE_ARCHIVE=${pkgs.glibcLocalesUtf8}/lib/locale/locale-archive
              fi
            ''}

            # note what environments are active, but make sure we don't repeat them
            if [[ ! "''${DIRENV_ACTIVE-}" =~ (^|:)"$PWD"(:|$) ]]; then
              export DIRENV_ACTIVE="$PWD:''${DIRENV_ACTIVE-}"
            fi

            # devenv helper
            if [ ! type -p direnv &>/dev/null && -f .envrc ]; then
              echo "You have .envrc but direnv command is not installed."
              echo "Please install direnv: https://direnv.net/docs/installation.html"
            fi

            mkdir -p "$DEVENV_STATE"
            if [ ! -L "$DEVENV_DOTFILE/profile" ] || [ "$(${pkgs.coreutils}/bin/readlink $DEVENV_DOTFILE/profile)" != "${profile}" ]
            then
              ln -snf ${profile} "$DEVENV_DOTFILE/profile"
            fi
            unset ${lib.concatStringsSep " " config.snow-blower.shell.unsetEnvVars}

            mkdir -p ${lib.escapeShellArg config.snow-blower.internals.runtime}
            ln -snf ${lib.escapeShellArg config.snow-blower.internals.runtime} ${lib.escapeShellArg config.snow-blower.internals.dotfile}/run
          '';


        };
      };
    });
  };
}
