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
      sanitizedName = lib.strings.sanitizeDerivationName "sb";

      bashBin = "${cfg.bashPackage}/bin";
      bashPath = "${cfg.bashPackage}/bin/bash";

      ansi = import ./ansi.nix;

      # Write a bash profile to load
      envBash = pkgs.writeText "devshell-env.bash" ''
            if [[ -n ''${IN_NIX_SHELL:-} || ''${DIRENV_IN_ENVRC:-} = 1 ]]; then
              # We know that PWD is always the current directory in these contexts
              PRJ_ROOT=$PWD
            elif [[ -z ''${PRJ_ROOT:-} ]]; then


              if [[ -z "''${PRJ_ROOT:-}" ]]; then
                echo "ERROR: please set the PRJ_ROOT env var to point to the project root" >&2
                return 1
              fi
            fi

          export PRJ_ROOT

          # Expose the folder that contains the assembled environment.
          export DEVSHELL_DIR=@DEVSHELL_DIR@

          # Prepend the PATH with the devshell dir and bash
          PATH=''${PATH%:/path-not-set}
          PATH=''${PATH#${bashBin}:}
          export PATH=$DEVSHELL_DIR/bin:${bashBin}:$PATH

          ${cfg.startup_env}

        ${builtins.concatStringsSep "\n" cfg.startup}

        # Interactive sessions
        if [[ $- == *i* ]]; then

        ${builtins.concatStringsSep "\n" cfg.interactive}

        fi # Interactive session

      '';

      # This is our entrypoint script.
      entrypoint = pkgs.writeScript "snow-blower-entrypoint" ''
        #!${bashPath}
        # Script that sets-up the environment. Can be both sourced or invoked.

        export DEVSHELL_DIR=@DEVSHELL_DIR@

        # If the file is sourced, skip all of the rest and just source the env
        # script.
        if (return 0) &>/dev/null; then
          source "$DEVSHELL_DIR/env.bash"
          return
        fi

        # Be strict!
        set -euo pipefail

        while (( "$#" > 0 )); do
          case "$1" in
            -h|--help)
              help=1
              ;;
            --pure)
              pure=1
              ;;
            --prj-root)
              if (( "$#" < 2 )); then
                echo 1>&2 'snow-blower: missing required argument to --prj-root'
                exit 1
              fi

              PRJ_ROOT="$2"

              shift
              ;;
            --env-bin)
              if (( "$#" < 2 )); then
                echo 1>&2 'snow-blower: missing required argument to --env-bin'
                exit 1
              fi

              env_bin="$2"

              shift
              ;;
            --)
              shift
              break
              ;;
            *)
              break
              ;;
          esac

          shift
        done

        if [[ -n "''${help:-}" ]]; then
          cat <<USAGE
        Usage: snow-blower
          $0 -h | --help          # show this help
          $0 [--pure]             # start a bash sub-shell
          $0 [--pure] <cmd> [...] # run a command in the environment

        Options:
          * --pure            : execute the script in a clean environment
          * --prj-root <path> : set the project root (\$PRJ_ROOT)
          * --env-bin <path>  : path to the env executable (default: /usr/bin/env)
        USAGE
          exit
        fi

        if (( "$#" == 0 )); then
          # Start an interactive shell
          set -- ${lib.escapeShellArg bashPath} --rcfile "$DEVSHELL_DIR/env.bash" --noprofile
        fi

        if [[ -n "''${pure:-}" ]]; then
          # re-execute the script in a clean environment.
          # note that the `--` in between `"$0"` and `"$@"` will immediately
          # short-circuit options processing on the second pass through this
          # script, in case we get something like:
          #   <entrypoint> --pure -- --pure <cmd>
          set -- "''${env_bin:-/usr/bin/env}" -i -- ''${HOME:+"HOME=''${HOME:-}"} ''${PRJ_ROOT:+"PRJ_ROOT=''${PRJ_ROOT:-}"} "$0" -- "$@"
        else
          # Start a script
          source "$DEVSHELL_DIR/env.bash"
        fi

        exec -- "$@"
      '';

      drvOrPackageToPaths = drvOrPackage:
        if drvOrPackage ? outputs
        then builtins.map (output: drvOrPackage.${output}) drvOrPackage.outputs
        else [drvOrPackage];

      # Builds the DEVSHELL_DIR with all the dependencies
      profile = pkgs.buildEnv rec {
        name = "${sanitizedName}-dir";
        paths = lib.flatten (builtins.map drvOrPackageToPaths config.snow-blower.packages);
        ignoreCollisions = true;
        postBuild = ''
          substitute ${envBash} $out/env.bash --subst-var-by DEVSHELL_DIR $out
          substitute ${entrypoint} $out/entrypoint --subst-var-by DEVSHELL_DIR $out
          chmod +x $out/entrypoint

          mainProgram="${meta.mainProgram}"
          # ensure mainProgram doesn't collide
          if [ -e "$out/bin/$mainProgram" ]; then
            echo "Warning: Cannot create entry point for this devshell at '\$out/bin/$mainProgram' because an executable with that name already exists." >&2
            echo "Set meta.mainProgram to something else than '$mainProgram'." >&2
          else
            # if $out/bin is a single symlink, transform it into a directory tree
            # (buildEnv does that when there is only one package in the environment)
            if [ -L "$out/bin" ]; then
              mv "$out/bin" bin-tmp
              mkdir "$out/bin"
              ln -s bin-tmp/* "$out/bin/"
            fi
            ln -s $out/entrypoint "$out/bin/$mainProgram"
          fi
        '';
        meta.mainProgram = sanitizedName;
      };

      #      # Write a bash profile to load
      #      setupShell = ''
      #        # devenv helper
      #        if [ ! type -p direnv &>/dev/null && -f .envrc ]; then
      #          echo "You have .envrc but direnv command is not installed."
      #          echo "Please install direnv: https://direnv.net/docs/installation.html"
      #        fi
      #
      #        #Setup Snowblower directory
      #        PRJ_DOTFILE="$FLAKE_ROOT/.sb"
      #        export PRJ_DOTFILE
      #        mkdir -p "$PRJ_DOTFILE"
      #
      #        #setup state directory
      #        PRJ_STATE="$PRJ_DOTFILE/state"
      #        export PRJ_STATE
      #        mkdir -p "$PRJ_STATE"
      #        if [ ! -L "$PRJ_DOTFILE/profile" ] || [ "$(${pkgs.coreutils}/bin/readlink $PRJ_DOTFILE/profile)" != "${profile}" ]
      #        then
      #          ln -snf ${profile} "$PRJ_DOTFILE/profile"
      #        fi
      #
      #        #setup runtime
      #        PRJ_RUNTIME="$FLAKE_ROOT/.sb-runtime"
      #        export PRJ_RUNTIME
      #        mkdir -p "$PRJ_RUNTIME"
      #        ln -snf "$PRJ_RUNTIME" "$PRJ_DOTFILE/run"
      #
      #        source "$PRJ_DOTFILE/profile/env.bash"`
      #      '';

      setupShell = ''
        # Remove all the unnecessary noise that is set by the build env
        unset NIX_BUILD_TOP NIX_BUILD_CORES NIX_STORE
        unset TEMP TEMPDIR TMP TMPDIR
        # $name variable is preserved to keep it compatible with pure shell https://github.com/sindresorhus/pure/blob/47c0c881f0e7cfdb5eaccd335f52ad17b897c060/pure.zsh#L235
        unset builder out shellHook stdenv system
        # Flakes stuff
        unset dontAddDisableDepTrack outputs

        # For `nix develop`. We get /noshell on Linux and /sbin/nologin on macOS.
        if [[ "$SHELL" == "/noshell" || "$SHELL" == "/sbin/nologin" ]]; then
          export SHELL=${bashPath}
        fi

        # devenv helper
        if [ ! type -p direnv &>/dev/null && -f .envrc ]; then
          echo "You have .envrc but direnv command is not installed."
          echo "Please install direnv: https://direnv.net/docs/installation.html"
        fi

        # Load the environment
        source "${profile}/env.bash"
      '';

      nakedStdenv = pkgs.writeTextFile {
        name = "naked-stdenv";
        destination = "/setup";
        text = ''
          # Fix for `nix develop`
          : ''${outputs:=out}

          runHook() {
            eval "$shellHook"
            unset runHook
          }
        '';
      };
    in {
      options.snow-blower.shell = {
        bashPackage = mkOption {
          internal = true;
          type = types.package;
          default = pkgs.bashInteractive;
          defaultText = "pkgs.bashInteractive";
          description = "Version of bash to use in the project";
        };

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
            {202}❄️ 💨 Snow Blower: Simple, Fast, Declarative, Reproducible, and Composable Developer Environments{reset}
          '';
          apply =
            lib.replaceStrings
            (map (key: "{${key}}") (lib.attrNames ansi))
            (lib.attrValues ansi);
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
        snow-blower.shell = {
          startup = lib.mkAfter [
            ''
              __devshell-motd() {
                cat <<DEVSHELL_PROMPT
              ${cfg.motd}
              Run 'just <recipe>' to get started
              DEVSHELL_PROMPT
              just --list
              }

              if [[ ''${DEVSHELL_NO_MOTD:-} = 1 ]]; then
                # Skip if that env var is set
                :
              elif [[ ''${DIRENV_IN_ENVRC:-} = 1 ]]; then
                # Print the motd in direnv
                __devshell-motd
              else
                # Print information if the prompt is displayed. We have to make
                # that distinction because `nix-shell -c "cmd"` is running in
                # interactive mode.
                __devshell-prompt() {
                  __devshell-motd
                  # Make it a noop
                  __devshell-prompt() { :; }
                }
                PROMPT_COMMAND=__devshell-prompt''${PROMPT_COMMAND+;$PROMPT_COMMAND}
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

        devShells.default = pkgs.mkShellNoCC {
          name = "snow blower";
          meta.description = ''
            Pure NixOS devshells.
          '';

          # `nix develop` actually checks and uses builder. And it must be bash.
          builder = bashPath;

          args = ["-ec" "${pkgs.coreutils}/bin/ln -s ${profile} $out; exit 0"];
          stdenv = nakedStdenv;

          # First we run our must haves then we run our enter shell commands.
          shellHook = ''
            # This is pretty critical for us to figure out where the flake is located
            FLAKE_ROOT="''$(${lib.getExe config.flake-root.package})"
            export FLAKE_ROOT
            ${setupShell}
          '';
          # Tell Direnv to shut up.
          DIRENV_LOG_FORMAT = "";
          packages = [
            config.snow-blower.packages
          ];
        };
      };
    });
  };
}
