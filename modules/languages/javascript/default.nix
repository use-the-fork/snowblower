{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.languages = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      pkgs,
      config,
      ...
    }: let
      inherit (lib) types mkOption literalExpression;
      cfg = config.snow-blower.languages.javascript;
    in {
      options.snow-blower.languages.javascript = {
        enable = lib.mkEnableOption "tools for JavaScript development";
        directory = lib.mkOption {
          type = lib.types.str;
          default = config.devenv.root;
          defaultText = lib.literalExpression "config.devenv.root";
          description = ''
            The JavaScript project's root directory. Defaults to the root of the devenv project.
            Can be an absolute path or one relative to the root of the devenv project.
          '';
          example = "./directory";
        };

        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.nodejs-slim;
          defaultText = lib.literalExpression "pkgs.nodejs-slim";
          description = "The Node.js package to use.";
        };

        corepack = {
          enable = lib.mkEnableOption "wrappers for npm, pnpm and Yarn via Node.js Corepack";
        };

        npm = {
          enable = lib.mkEnableOption "install npm";
          package = lib.mkOption {
            type = lib.types.package;
            default = pkgs.nodejs;
            defaultText = lib.literalExpression "pkgs.nodejs";
            description = "The Node.js package to use.";
          };
          install.enable = lib.mkEnableOption "npm install during devenv initialisation";
        };

        pnpm = {
          enable = lib.mkEnableOption "install pnpm";
          package = lib.mkOption {
            type = lib.types.package;
            default = pkgs.nodePackages.pnpm;
            defaultText = lib.literalExpression "pkgs.nodePackages.pnpm";
            description = "The pnpm package to use.";
          };
          install.enable = lib.mkEnableOption "pnpm install during devenv initialisation";
        };

        yarn = {
          enable = lib.mkEnableOption "install yarn";
          package = lib.mkOption {
            type = lib.types.package;
            default = pkgs.yarn;
            defaultText = lib.literalExpression "pkgs.yarn";
            description = "The yarn package to use.";
          };
          install.enable = lib.mkEnableOption "yarn install during devenv initialisation";
        };

        bun = {
          enable = lib.mkEnableOption "install bun";
          package = lib.mkOption {
            type = lib.types.package;
            default = pkgs.bun;
            defaultText = lib.literalExpression "pkgs.bun";
            description = "The bun package to use.";
          };
          install.enable = lib.mkEnableOption "bun install during devenv initialisation";
        };
      };

      config.snow-blower = lib.mkIf cfg.enable {
        packages = with pkgs;
          [
            cfg.package
          ]
          ++ lib.optional cfg.npm.enable cfg.npm.package
          ++ lib.optional cfg.pnpm.enable cfg.pnpm.package
          ++ lib.optional cfg.yarn.enable (cfg.yarn.package.override {nodejs = cfg.package;})
          ++ lib.optional cfg.bun.enable cfg.bun.package
          ++ lib.optional cfg.corepack.enable (pkgs.runCommand "corepack-enable" {} ''
            mkdir -p $out/bin
            ${cfg.package}/bin/corepack enable --install-directory $out/bin
          '');

        shell.startup = lib.concatStringsSep "\n" (
          (lib.optional cfg.npm.install.enable ''
            source ${(./init-npm.nix {inherit pkgs lib config;})}
          '')
          ++ (lib.optional cfg.pnpm.install.enable ''
            source ${(./init-pnpm.nix {inherit pkgs lib config;})}
          '')
          ++ (lib.optional cfg.yarn.install.enable ''
            source ${(./init-yarn.nix {inherit pkgs lib config;})}
          '')
          ++ (lib.optional cfg.bun.install.enable ''
            source ${(./init-bun.nix {inherit pkgs lib config;})}
          '')
        );
      };
    });
  };
}
