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
      sanitizedName = lib.strings.sanitizeDerivationName "❄️ 💨 Snow Blower";

      bashBin = "${cfg.bashPackage}/bin";
      bashPath = "${cfg.bashPackage}/bin/bash";

      mkFlakeApp = bin: {
        type = "app";
        program = "${bin}";
      };

      mkSetupHook = rc:
        pkgs.stdenvNoCC.mkDerivation {
          name = "devshell-setup-hook";
          setupHook = pkgs.writeText "devshell-setup-hook.sh" ''
            source ${rc}
          '';
          dontUnpack = true;
          dontBuild = true;
          dontInstall = true;
        };

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
      devshell_dir = pkgs.buildEnv rec {
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

      # Write a bash profile to load
      setupShell = ''
        # devenv helper
        if [ ! type -p direnv &>/dev/null && -f .envrc ]; then
          echo "You have .envrc but direnv command is not installed."
          echo "Please install direnv: https://direnv.net/docs/installation.html"
        fi
      '';
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
          type = types.lines;
          description = "Bash code to execute when entering the shell.";
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
        devShells.default = pkgs.mkShellNoCC {
          name = "❄️ 💨 Snow Blower";
          meta.description = ''
            Pure NixOS devshells.
          '';

          # First we run our must haves then we run our enter shell commands.
          shellHook = ''
            ${setupShell}
             ${config.snow-blower.shell.startup}
             echo
             echo "❄️ 💨 Snow Blower: Simple, Fast, Declarative, Reproducible, and Composable Developer Environments"
             echo
             echo "Run 'just <recipe>' to get started"
             just --list
          '';
          # Tell Direnv to shut up.
          DIRENV_LOG_FORMAT = "";

          inputsFrom = [(mkSetupHook "${devshell_dir}/env.bash")];
          packages = [
            #          entrypoint
            config.snow-blower.packages
          ];
        };

        packages = [mkFlakeApp "${devshell_dir}/entrypoint"];
      };
    });
  };
}
