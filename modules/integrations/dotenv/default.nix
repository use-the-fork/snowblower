{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.integrations = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      config,
      ...
    }: let
      inherit (lib) types mkOption;

      cfg = config.snow-blower.dotenv;

      normalizeFilenames = filenames:
        if lib.isList filenames
        then filenames
        else [filenames];
      dotenvFiles = normalizeFilenames cfg.filename;
      dotenvPaths = map (filename: ("${config.snow-blower.paths.root}" + "/" + filename)) dotenvFiles;

      # Parses a single line of an environment file.
      parseLine = line: let
        parts = builtins.match "([[:space:]]*export[[:space:]]+)?([^[:space:]=#]+)[[:space:]]*=[[:space:]]*(.*)" line;
      in
        if parts != null && builtins.length parts == 3
        then {
          name = builtins.elemAt parts 1;
          value = builtins.elemAt parts 2;
        }
        else null;

      parseEnvFile = content: builtins.listToAttrs (lib.filter (x: !builtins.isNull x) (map parseLine (lib.splitString "\n" content)));

      mergeEnvFiles = files:
        lib.foldl' (acc: file:
          lib.recursiveUpdate acc (
            if lib.pathExists file
            then parseEnvFile (builtins.readFile file)
            else {}
          )) {}
        files;
    in {
      options.snow-blower.dotenv = {
        enable = lib.mkEnableOption ".env integration, doesn't support comments or multiline values.";

        filename = lib.mkOption {
          type = lib.types.either lib.types.str (lib.types.listOf lib.types.str);
          default = ".env";
          description = "The name of the dotenv file to load, or a list of dotenv files to load in order of precedence.";
        };

        resolved = lib.mkOption {
          type = lib.types.attrsOf lib.types.anything;
          internal = true;
        };
      };

      config.snow-blower = lib.mkIf cfg.enable {
        # Maps the resolved .env to the flakes env using a new attribute structure
        # env Varibles should always override flake varibles.
        env = lib.mapAttrs (_: attrs: lib.mkForce attrs) cfg.resolved;
        dotenv.resolved = mergeEnvFiles dotenvPaths;
      };
    });
  };
}
