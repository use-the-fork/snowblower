{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.processes = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      config,
      pkgs,
      ...
    }:
      with lib; let

      in {
        options.snow-blower = {
          processes = lib.mkOption {
                              type = lib.types.submoduleWith {
                                modules = [
                                  (inputs.process-compose-flake + "/nix/process-compose/settings/default.nix")
                                ];
                                specialArgs = {inherit pkgs;};
                                shorthandOnlyDefinesConfig = true;
                              };
                              default = {};
                              description = "Integration of https://github.com/Platonic-Systems/process-compose-flake";
                            };
        };

        config = {
          snow-blower = lib.mkIf (config.process-compose.watch-server.settings.processes != {}) {
            just.recipes.up = {
              enable = lib.mkDefault true;
              justfile = lib.mkDefault ''
                # Starts the environment.
                up:
                  nix run .#watch-server
              '';
            };
          };
        };
      });
  };
}
