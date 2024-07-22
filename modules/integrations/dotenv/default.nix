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
      self',
      ...
    }: let
      inherit (lib) types mkOption;

      cfg = config.snow-blower.dotenv;

      normalizeFilenames = filenames:
        if lib.isList filenames
        then filenames
        else [filenames];
      dotenvFiles = normalizeFilenames cfg.filename;
      dotenvPaths = map (filename: (config.snow-blower.paths.root + "/" + filename)) dotenvFiles;

      # Parses a single line of an environment file.
      parseLine = line:
        let
          # Attempt to match the line to the pattern for an env variable declaration.
          # Supports optional export keyword, captures variable names and values.
          parts = builtins.match "^[[:space:]]*(export[[:space:]]+)?([^[:space:]=#]+)[[:space:]]*=[[:space:]]*(.*)[[:space:]]*$" line;
        in
        if parts != null && builtins.length parts == 4
        then
          # If a match is found and has the correct number of parts, create an attribute set.
          { name = parts[2]; value = parts[3]; }
        else
          # Return null if no valid match is found.
          null;

      # Parses the entire content of a .env file into a set of Nix attributes.
      parseEnvFile = content:
        builtins.listToAttrs (
          # Use lib.filter to remove any null results from unsuccessful line parses.
          lib.filter (x: x != null) (
            # Map parseLine over each line split from the input content.
            map parseLine (lib.splitString "\n" content)
          )
        );

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
        env = lib.mapAttrs (_: attrs: lib.mkDefault attrs) cfg.resolved;
        dotenv.resolved = mergeEnvFiles dotenvPaths;
      };
    });
  };
}
