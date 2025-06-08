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
    }: {
      config.snowblower = {
        # snowblower utility just commands
        just.recipes.bump-snowblower = {
          enable = lib.mkDefault true;
          justfile = lib.mkDefault ''
            # update flake inputs commit flake lock.
            bump:
              nix flake update && git commit flake.lock -m "flake: bump inputs"
          '';
        };
      };
    });
  };
}
