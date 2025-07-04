{flake-parts-lib, ...}: let
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  options.perSystem = mkPerSystemOption ({
    lib,
    pkgs,
    config,
    ...
  }: let
    inherit (lib) types mkOption;

    cfg = config.snowblower.integration.just;

    recipes = lib.filterAttrs (_n: f: f.enable) cfg.recipe;

    recipeModule = {
      imports = [./../../lib/types/just-recipe-module.nix];
      config._module.args = {inherit pkgs;};
    };

    recipeType = types.submodule recipeModule;
  in {
    imports = [
      {
        options.snowblower.integration.just.recipe = mkOption {
          type = types.submoduleWith {
            modules = [{freeformType = types.attrsOf recipeType;}];
            specialArgs = {inherit pkgs;};
          };
          default = {};
          description = ''
            The recipe that are avaliable to just
          '';
        };
      }
    ];

    options.snowblower.integration.just = {
      package = mkOption {
        type = types.package;
        default = pkgs.just;
        defaultText = lib.literalExpression "pkgs.just";
        description = "The just package to use.";
      };
    };

    config.snowblower = {
      packages.tools = [
        cfg.package
      ];

      file."justfile" = let
        recipeCommands = lib.concatStringsSep "\n\n" (lib.mapAttrsToList (name: recipe: let
          printPrefix =
            if recipe.printCommand
            then "@"
            else "";
          parameters = lib.concatStringsSep " " (["${printPrefix}${name}"] ++ recipe.parameters);

          attributes = lib.lists.flatten [
            "[group('${recipe.group}')]"
            (lib.optional recipe.private "[private]")
            (lib.optional recipe.positionalArguments "[positional-arguments]")
            (lib.optional (recipe.description != "") "[doc('${recipe.description}')]")
            "${parameters}:"
          ];

          attributesLine = lib.concatStringsSep "\n" attributes;
        in ''
          ${attributesLine}
          	${recipe.exec}'')
        recipes);
      in {
        enable = true;
        text = ''
          # This file is automatically generated by SnowBlower.
          # Do not edit this file directly as your changes will be overwritten.
          # Instead, modify your flake.nix configuration to update just commands.

          [private]
          [doc('Display the list of recipes')]
          default:
            @just --list

          ${recipeCommands}
        '';
      };
    };
  });
}
