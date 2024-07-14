{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib) mkOption mkPackageOption types;

  # A new kind of option type that calls lib.getExe on derivations
  exeType = lib.mkOptionType {
    name = "exe";
    description = "Path to executable";
    check = x: lib.isString x || builtins.isPath x || lib.isDerivation x;
    merge =
      loc: defs:
      let
        res = lib.mergeOneOption loc defs;
      in
      if lib.isString res || builtins.isPath res then "${res}" else lib.getExe res;
  };

  configFormat = pkgs.formats.toml { };

in
{
  # Schema
  options = {

    projectRootFile = mkOption {
      description = ''
        File to look for to determine the root of the project in the
        build.wrapper.
      '';
      example = "flake.nix";
    };

    enterShell = mkOption {
      type = types.lines;
      description = "Bash code to execute when entering the shell.";
      default = "";
    };

    packages = mkOption {
      type = types.listOf types.package;
      description = "A list of packages to expose inside the developer environment. See https://search.nixos.org/packages for packages.";
      default = [ ];
    };

    stdenv = mkOption {
      type = types.package;
      description = "The stdenv to use for the developer environment.";
      default = pkgs.stdenv;
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
    devShell = (pkgs.mkShell.override { stdenv = config.stdenv; }) {
      packages = config.packages;
      shellHook = ''
        ${config.enterShell}
      '';
      nativeBuildInputs = [ ];
      #      ++ (lib.attrValues config.build.programs);
    };
  };
}
