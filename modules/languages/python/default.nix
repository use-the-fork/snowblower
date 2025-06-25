{flake-parts-lib, ...}: {
  imports = [
    ./uv.nix
  ];

  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    pkgs,
    config,
    ...
  }: let
    inherit (lib) mkLanguage;
    cfg = config.snowblower.language.python;
  in {
    options.snowblower.language.python = mkLanguage {
      name = "Python";
      package = pkgs.python312;
    };

    config.snowblower = lib.mkIf cfg.enable {
      packages.runtime = [
        cfg.package
      ];
    };
  });
}
