# The core snowblower package IE "snow"
{flake-parts-lib, ...}: let
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  options.perSystem = mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) literalExpression mkOption types;

    cfg = config.snowblower;
  in {
    options.snowblower = {
      environmentVariables = mkOption {
        default = {};
        type = with types;
          lazyAttrsOf (oneOf [
            str
            path
            int
            float
          ]);
        example = {
          EDITOR = "emacs";
          GS_OPTIONS = "-sPAPERSIZE=a4";
        };
        description = ''
          Environment variables to always set at login.

          The values may refer to other environment variables using
          POSIX.2 style variable references. For example, a variable
          {var}`parameter` may be referenced as
          `$parameter` or `''${parameter}`. A
          default value `foo` may be given as per
          `''${parameter:-foo}` and, similarly, an alternate
          value `bar` can be given as per
          `''${parameter:+bar}`.

          Note, these variables may be set in any order so no session
          variable may have a runtime dependency on another session
          variable. In particular code like
          ```nix
          snowblower.environmentVariables = {
            FOO = "Hello";
            BAR = "$FOO World!";
          };
          ```
          may not work as expected. If you need to reference another
          session variable (even if it is declared by using other options
          like [](#opt-xdg.configHome)), then do so inside Nix instead.
          The above example then becomes
          ```nix
          snowblower.environmentVariables = {
            FOO = "Hello";
            BAR = "''${config.home.environmentVariables.FOO} World!";
          };
          ```
        '';
      };

      environmentVariablesPackage = mkOption {
        type = types.package;
        internal = true;
        description = ''
          The package containing the
          {file}`hm-session-vars.sh` file.
        '';
      };

      sessionPath = mkOption {
        type = with types; listOf str;
        default = [];
        example = [
          "$HOME/.local/bin"
          "\${xdg.configHome}/emacs/bin"
          ".git/safe/../../bin"
        ];
        description = ''
          Extra directories to prepend to {env}`PATH`.

          These directories are added to the {env}`PATH` variable in a
          double-quoted context, so expressions like `$HOME` are
          expanded by the shell. However, since expressions like `~` or
          `*` are escaped, they will end up in the {env}`PATH`
          verbatim.
        '';
      };

      activation = mkOption {
        type = lib.sbl.types.dagOf types.str;
        default = {};
        example = literalExpression ''
          {
            myActivationAction = lib.sbl.dag.entryAfter ["writeBoundary"] '''
              run ln -s $VERBOSE_ARG \
                  ''${builtins.toPath ./link-me-directly} $HOME
            ''';
          }
        '';
        description = ''
          The activation scripts blocks to run when activating a Home
          Manager generation. Any entry here should be idempotent,
          meaning running twice or more times produces the same result
          as running it once.

          If the script block produces any observable side effect, such
          as writing or deleting files, then it
          *must* be placed after the special
          `writeBoundary` script block. Prior to the
          write boundary one can place script blocks that verifies, but
          does not modify, the state of the system and exits if an
          unexpected state is found. For example, the
          `checkLinkTargets` script block checks for
          collisions between non-managed files and files defined in
          [](#opt-home.file).

          A script block should respect the {var}`DRY_RUN` variable. If it is set
          then the actions taken by the script should be logged to standard out
          and not actually performed. A convenient shell function {command}`run`
          is provided for activation script blocks. It is used as follows:

          {command}`run {command}`
          : Runs the given command on live run, otherwise prints the command to
          standard output.

          {command}`run --quiet {command}`
          : Runs the given command on live run and sends its standard output to
          {file}`/dev/null`, otherwise prints the command to standard output.

          {command}`run --silence {command}`
          : Runs the given command on live run and sends its standard and error
          output to {file}`/dev/null`, otherwise prints the command to standard
          output.

          The `--quiet` and `--silence` flags are mutually exclusive.

          A script block should also respect the {var}`VERBOSE` variable, and if
          set print information on standard out that may be useful for debugging
          any issue that may arise. The variable {var}`VERBOSE_ARG` is set to
          {option}`--verbose` if verbose output is enabled. You can also use the
          provided shell function {command}`verboseEcho`, which acts as
          {command}`echo` when verbose output is enabled.
        '';
      };

      home.activationPackage = mkOption {
        internal = true;
        type = types.package;
        description = "The package containing the complete activation script.";
      };
    };

    config = {
      snowblower = {
        environmentVariables = {
        };

        # Provide a file holding all session variables.
        environmentVariablesPackage = pkgs.writeTextFile {
          name = "sb-session-vars.sh";
          text = ''
            function setupEnvironmentVariables() {
              # Only source this once.
              if [ -v __SB_SESS_VARS_SOURCED ]; then return; fi
              export __SB_SESS_VARS_SOURCED=1

              ${lib.sbl.shell.exportAll cfg.environmentVariables}
            }

            setupEnvironmentVariables
          '';
        };

        # The entry acting as a boundary between the activation script's "check" and
        # the "write" phases. This is where we commit to attempting to actually
        # activate the configuration.
        activation.writeBoundary = lib.sbl.dag.entryAnywhere ''
          if [[ ! -v oldGenPath || "$oldGenPath" != "$newGenPath" ]] ; then
              _i "Creating new profile generation"
              run nix-env $VERBOSE_ARG --profile "$genProfilePath" --set "$newGenPath"
          else
              _i "No change so reusing latest profile generation"
          fi
        '';

        # Text containing Bash commands that will initialize the Home Manager Bash
        # library. Most importantly, this will prepare for using translated strings
        # in the `hm-modules` text domain.
        activation.initSnowBlowerLib = ''
          ${builtins.readFile ./../lib-bash/utils.sh}
        '';

        file."snow" = let
          #  ${lib.concatStringsSep "\n" (lib.mapAttrsToList
          # (name: cmd:
          #   lib.sbl.command.formatCommand {
          #     inherit name;
          #     inherit (builtins.trace cmd cmd) description lib.sbl.dag.resolveDag subcommands;
          #   })
          # config.snowblower.commands)}
          activationPackage = pkgs.writeTextFile {
            name = "sb-activation-package";
            text = ''
              ${builtins.readFile ./../lib-bash/utils.sh}

                ${builtins.readFile config.snowblower.directoriesPackage}

                ${builtins.readFile ./../lib-bash/boot.sh}

                ${builtins.readFile config.snowblower.environmentVariablesPackage}

                ${builtins.readFile ./../lib-bash/welcome.sh}
                ${builtins.readFile config.snowblower.commandHelpPackage}

                ${builtins.readFile ./../lib-bash/help.sh}

                ${builtins.readFile ./../lib-bash/docker-commands.sh}
                ${builtins.readFile config.snowblower.commandRunPackage}


            '';
          };
        in {
          enable = true;
          executable = true;
          source = activationPackage;
        };
      };
    };
  });
}
