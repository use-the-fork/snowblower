{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types;
  # A new kind of option type that calls lib.getExe on derivations
in {
  # Schema
  options = {
    projectRootFile = mkOption {
      description = ''
        File to look for to determine the root of the project in the
        build.wrapper.
      '';
      example = "flake.nix";
    };

    shellPreHook = mkOption {
      type = types.lines;
      description = "Bash code to execute when entering the shell.";
      default = "";
    };

    shellPostHook = mkOption {
      type = types.lines;
      description = "Bash code to execute when entering the shell but after `shellPreHook`.";
      default = "";
    };

    packages = mkOption {
      type = types.listOf types.package;
      description = "A list of packages to expose inside the developer environment. See https://search.nixos.org/packages for packages.";
      default = [];
    };

    stdenv = mkOption {
      type = types.package;
      description = "The stdenv to use for the developer environment.";
      default = pkgs.stdenv;
    };

    shell = lib.mkOption {
      type = types.package;
      internal = true;
    };

    assertions = lib.mkOption {
      type = types.listOf types.unspecified;
      internal = true;
      default = [];
      example = [
        {
          assertion = false;
          message = "you can't enable this for that reason";
        }
      ];
      description = ''
        This option allows modules to express conditions that must
        hold for the evaluation of the configuration to succeed,
        along with associated error messages for the user.
      '';
    };

    warnings = lib.mkOption {
      type = types.listOf types.str;
      internal = true;
      default = [];
      example = ["you should fix this or that"];
      description = ''
        This option allows modules to express warnings about the
        configuration. For example, `lib.mkRenamedOptionModule` uses this to
        display a warning message when a renamed option is used.
      '';
    };

    enableDefaultExcludes = mkOption {
      description = ''
        Enable the default excludes in the treefmt configuration.
      '';
      type = types.bool;
      default = true;
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

  # Config
  config.build = {
    devShell = (pkgs.mkShell.override {inherit (config) stdenv;}) {
      inherit (config) packages;
      shellHook = ''
        ${config.shellPreHook}
        ${config.shellPostHook}
        echo
        echo "Snow Blower: Simple, Fast, Declarative, Reproducible, and Composable Developer Environments"
        echo
        echo "Run 'just <recipe>' to get started"
        just --list
      '';
      nativeBuildInputs = [];
      #      ++ (lib.attrValues config.build.programs);
    };
  };
}
