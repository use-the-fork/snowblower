#AI: Use this for refrence
topLevel @ {
  inputs,
  lib,
  flake-parts-lib,
  self,
  ...
}: {
  perSystem = {
    pkgs,
    system,
    inputs',
    self',
    ...
  }: let
    docModules =
      inputs.flake-parts.lib.evalFlakeModule {inherit inputs;}
      {
        imports = [topLevel.config.flake.flakeModules.default];
        options.perSystem = flake-parts-lib.mkPerSystemOption {
          config._module.args = {
            system = lib.mkDefault "x86_64-linux";
            pkgs = lib.mkDefault pkgs;
            inputs' = lib.mkDefault inputs';
            self' = lib.mkDefault self';
          };
        };
      };

    # Create a function that takes a filter string and returns a transformOptions function
    mkTransformOptions = option:
      option
      // rec {
        declarations =
          lib.concatMap
          (declaration:
            if lib.hasPrefix "${self}/modules/" declaration
            then [
              rec {
                name = lib.removePrefix "${self}/modules/" declaration;
                url = "modules/${builtins.head (builtins.split "," name)}";
              }
            ]
            else [])
          option.declarations;
        visible = declarations != [];
      };

    # Create a function to generate documentation with a specific filter
    mkOptionsDoc = pkgs.nixosOptionsDoc {
      options = docModules.options;
      transformOptions = mkTransformOptions;
      documentType = "none";
      warningsAreErrors = false;
    };
    # Define the documentation filters we want to generate
  in {
    packages = {
      # Main options-doc package that generates all documentation files
      options-doc =
        pkgs.runCommand "optionsdoc"
        {
          nativeBuildInputs = [pkgs.jq];
        } ''
          mkdir -p $out

          # Generate a separate JSON file for each filter
          cp -r ${mkOptionsDoc.optionsJSON} $out/options.json
          echo "Documentation generated successfully!"
        '';
    };
  };
}
