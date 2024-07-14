{ pkgs, ... }: {
  projectRootFile = "snowblower.nix";
  treefmt.programs = {
    nixpkgs-fmt.enable = true;
  };
  just = {
    enable = true;
    recipes = {
      treefmt.enable = true;
    };
  };
  #  programs.mdsh.enable = true;
  #  programs.yamlfmt.enable = true;
  #  programs.deno.enable = pkgs.hostPlatform.system != "riscv64-linux";
  #  programs.nixpkgs-fmt.enable = true;
  #  programs.shfmt.enable = pkgs.hostPlatform.system != "riscv64-linux";
  #  programs.shellcheck.enable = pkgs.hostPlatform.system != "riscv64-linux";
  #  settings.global.excludes = [ "*.toml" ];
}
