topLevel@{ inputs, flake-parts-lib, ... }: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
    ./nixpkgs.nix
    ./shell.nix
  ];
  flake.flakeModules.common = flakeModule: {
    imports = [
      topLevel.config.flake.flakeModules.nixpkgs
      topLevel.config.flake.flakeModules.shell
    ];
    options.perSystem = flake-parts-lib.mkPerSystemOption ({ lib, ... }: {
      config.nixpkgs.config.allowUnsupportedSystem = true;
    });
  };
}
