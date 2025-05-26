{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    # Provide a formatter package for `nix fmt`. Setting this
    # to `config.treefmt.build.wrapper` will use the treefmt
    # package wrapped with my desired configuration.
    formatter = config.treefmt.build.wrapper;

    treefmt = {
      projectRootFile = "flake.nix";
      enableDefaultExcludes = true;

      settings = {
        global.excludes = ["*.age" "*.envrc" "*/sources.json"];
      };

      # Most often than not, most of those checks will not run on baremetal. Which
      # means that we can afford to be generous with what formatters we provide.
      programs = {
        alejandra.enable = true;
        deadnix.enable = true;
        statix = {
          enable = true;
          disabled-lints = [
            "manual_inherit_from"
          ];
        };
        mdformat.enable = true;
        taplo.enable = true;

        prettier = {
          enable = true;
          package = pkgs.prettierd;
          settings.editorconfig = true;
        };

        shfmt = {
          enable = true;
          # https://flake.parts/options/treefmt-nix.html#opt-perSystem.treefmt.programs.shfmt.indent_size
          indent_size = 2; # set to 0 to use tabs
        };
      };
    };
  };
}
