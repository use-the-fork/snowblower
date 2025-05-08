{lib, ...}: let
  inherit (lib) mkOption mkEnableOption types;
in {
  options = {
    enable = mkEnableOption "this command";

    model = mkOption {
      description = "Specify the model to use for the main chat.";
      default = "sonnet";
      type = types.str;
    };

    gitCommitVerify = mkOption {
      description = "Enable/disable git pre-commit hooks with --no-verify";
      default = true;
      type = types.bool;
    };

    watchFiles = mkOption {
      description = "Enable/disable watching files for changes";
      default = false;
      type = types.bool;
    };

    readFiles = mkOption {
      description = "Specify read-only files (can be used multiple times)";
      default = [];
      type = types.listOf types.str;
    };

    suggestShellCommands = mkOption {
      description = "Enable/disable suggesting shell commands";
      default = false;
      type = types.bool;
    };

    detectUrls = mkOption {
      description = "Enable/disable detection and offering to add URLs to chat";
      default = false;
      type = types.bool;
    };

    lintCommands = mkOption {
      description = "Specify lint commands to run for different languages, eg: 'python: flake8 --select=...'";
      default = [];
      type = types.listOf types.str;
    };

    testCommands = mkOption {
      description = "Specify commands to run tests";
      default = [];
      type = types.listOf types.str;
    };

    description = mkOption {
      description = "Description of this Aider command";
      default = "Run Aider AI assistant";
      type = types.str;
    };

    extraArgs = mkOption {
      description = "Extra command line arguments to pass to Aider";
      default = "";
      type = types.str;
    };
  };
}
