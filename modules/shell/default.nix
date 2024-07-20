{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.shell = _flakeModule: {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      pkgs,
      config,
      ...
    }: let
      inherit (lib) types mkOption;

      cfg = config.snow-blower.shell;

      drvOrPackageToPaths = drvOrPackage:
        if drvOrPackage ? outputs
        then builtins.map (output: drvOrPackage.${output}) drvOrPackage.outputs
        else [drvOrPackage];

      # Builds the PROJECT_PROFILE with all the dependencies
      profile = pkgs.buildEnv {
        name = "snowblower-profile";
        paths = lib.flatten (builtins.map drvOrPackageToPaths config.snow-blower.packages);
        ignoreCollisions = true;
      };
      #      unset ${lib.concatStringsSep " " config.unsetEnvVars}

      setupShell = ''
        # Remove all the unnecessary noise that is set by the build env
        unset NIX_BUILD_TOP NIX_BUILD_CORES NIX_STORE
        unset TEMP TEMPDIR TMP TMPDIR
        # $name variable is preserved to keep it compatible with pure shell https://github.com/sindresorhus/pure/blob/47c0c881f0e7cfdb5eaccd335f52ad17b897c060/pure.zsh#L235
        unset builder out shellHook stdenv system
        # Flakes stuff
        unset dontAddDisableDepTrack outputs

        # Setup our directories and linkages as needed.
        mkdir -p "$PROJECT_DOTFILE"

        #setup state (data) directory
        mkdir -p "$PROJECT_STATE"
        if [ ! -L "$PROJECT_DOTFILE/profile" ] || [ "$(${pkgs.coreutils}/bin/readlink $PROJECT_DOTFILE/profile)" != "${profile}" ]
        then
          ln -snf ${profile} "$PROJECT_DOTFILE/profile"
        fi

        # setup the runtime directory
        mkdir -p ${lib.escapeShellArg config.snow-blower.paths.runtime}
        ln -snf ${lib.escapeShellArg config.snow-blower.paths.runtime} ${lib.escapeShellArg config.snow-blower.paths.dotfile}/run

        #Run our Startup hooks.
        ${builtins.concatStringsSep "\n" cfg.startup}

        # Interactive sessions
        if [[ $- == *i* ]]; then
        ${builtins.concatStringsSep "\n" cfg.interactive}
        fi # Interactive session

      '';
    in {
      options.snow-blower.shell = {
        startup = mkOption {
          type = types.listOf types.str;
          description = "Bash code to execute on startup.";
          default = "";
        };

        interactive = mkOption {
          type = types.listOf types.str;
          description = "Bash code to execute on interactive startups";
          default = "";
        };

        startup_env = mkOption {
          type = types.str;
          default = "";
          internal = true;
          description = ''
            Please ignore. Used by the env module.
          '';
        };

        motd = mkOption {
          type = types.str;
          default = ''
            ❄️ 💨 Snow Blower: Simple, Fast, Declarative, Reproducible, and Composable Developer Environments
          '';
          description = ''
            Message Of The Day.

            This is the welcome message that is being printed when the user opens
            the shell.

            You may use any valid ansi color from the 8-bit ansi color table. For example, to use a green color you would use something like {106}. You may also use {bold}, {italic}, {underline}. Use {reset} to turn off all attributes.
          '';
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

      config = {
        snow-blower = {
          paths = {
            dotfile = lib.mkDefault (builtins.toPath (config.snow-blower.paths.root + "/.sb"));
            state = builtins.toPath (config.snow-blower.paths.dotfile + "/state");
            inherit profile;
          };

          shell = {
            startup = lib.mkAfter [
              ''
                echo ${cfg.motd}
                echo
                echo Run 'just <recipe>' to get started
                just --list

              ''
              ''
                # devenv helper
                if [ ! type -p direnv &>/dev/null && -f .envrc ]; then
                  echo "You have .envrc but direnv command is not installed."
                  echo "Please install direnv: https://direnv.net/docs/installation.html"
                fi
              ''
            ];

            interactive = [
              ''
                if [[ -n "''${PRJ_ROOT:-}" ]]; then
                  # Print the path relative to $PRJ_ROOT
                  rel_root() {
                    local path
                    path=$(${pkgs.coreutils}/bin/realpath --relative-to "$PRJ_ROOT" "$PWD")
                    if [[ $path != . ]]; then
                      echo " $path "
                    fi
                  }
                else
                  # If PRJ_ROOT is unset, print only the current directory name
                  rel_root() {
                    echo " \W "
                  }
                fi
              ''
            ];
          };
        };

        devShells.default = (pkgs.mkShell.override {stdenv = cfg.stdenv;}) ({
            name = "devenv-shell";
            packages = config.snow-blower.packages;
            shellHook = ''
              ${setupShell}
            '';
          }
          // config.snow-blower.env);
      };
    });
  };
}
