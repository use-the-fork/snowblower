{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.env = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      config,
      pkgs,
      ...
    }:
      with lib; let
        envOptions = {
          value = mkOption {
            type = with types; nullOr (oneOf [str int bool package]);
            default = null;
            description = "Shell-escaped value to set";
          };

          eval = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = ''
              Like value but not evaluated by Bash. This allows to inject other
              variable names or even commands using the `$()` notation.
            '';
            example = "$OTHER_VAR";
          };

          prefix = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = ''
              Prepend to PATH-like environment variables.
              For example, setting prefix = "bin"; will expand the path of
              ./bin and prepend it to the PATH, separated by ':'.
            '';
            example = "bin";
          };

          unset = mkEnableOption "unsets the variable";

          __toString = mkOption {
            type = types.functionTo types.str;
            internal = true;
            readOnly = true;
            default = envToBash;
            description = "Function used to translate this submodule to Bash code";
          };
        };

        envToBash = {
          name,
          value,
          eval,
          prefix,
          ...
        } @ args: let
          vals = filter (key: args.${key} != null && args.${key}) [
            "eval"
            "prefix"
            "unset"
            "value"
          ];
          valType = head vals;
        in
          assert assertMsg ((length vals) > 0) "[[environ]]: ${name} expected one of (value|eval|prefix|unset) to be set.";
          assert assertMsg ((length vals) < 2) "[[environ]]: ${name} expected only one of (value|eval|prefix|unset) to be set. Not ${toString vals}";
          assert assertMsg (!(name == "PATH" && valType == "value")) "[[environ]]: ${name} should not override the value. Use 'prefix' instead.";
            if valType == "value"
            then "export ${name}=${escapeShellArg (toString value)}"
            else if valType == "eval"
            then "export ${name}=${eval}"
            else if valType == "prefix"
            then ''export ${name}=$(${pkgs.coreutils}/bin/realpath --canonicalize-missing "${prefix}")''${${name}+:''${${name}}}''
            else if valType == "unset"
            then ''unset ${name}''
            else throw "BUG in the env.nix module. This should never be reached.";
      in {
        options.snow-blower = {
          env = mkOption {
            type = types.attrsOf (types.submodule {options = envOptions;});
            default = [];
            description = ''
              Add environment variables to the shell.
            '';
            example = literalExpression ''
              {
                HTTP_PORT = {
                  value = 8080;
                };
                PATH = {
                  prefix = "bin";
                };
                XDG_CACHE_DIR = {
                  eval = "$PRJ_ROOT/.cache";
                };
                CARGO_HOME = {
                  unset = true;
                };
              }
            '';
          };
        };

        config.snow-blower = {
          # Default env
          env = lib.mkBefore {
            # Expose the path to nixpkgs
            "NIXPKGS_PATH" = {
              value = toString pkgs.path;
            };

            # This is used by bash-completions to find new completions on demand
            "XDG_DATA_DIRS" = {
              eval = ''$DEVSHELL_DIR/share:''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}'';
            };

            # A per-project data directory for packages.
            "PRJ_DATA_DIR" = {
              eval = "\${PRJ_DATA_DIR:-$PRJ_ROOT/.snow-blower/data}";
            };

            # A per-project data directory for runtime information.
            "PRJ_RUNTIME_DIR" = {
              eval = "\${PRJ_RUNTIME_DIR:-$PRJ_ROOT/.snow-blower/runtime}";
            };
          };

          shell.startup_env = concatStringsSep "\n" (mapAttrsToList (
              name: attrs:
                envToBash ({inherit name;} // attrs)
            )
            config.snow-blower.env);
        };
      });
  };
}
