topLevel @ {
  inputs,
  lib,
  flake-parts-lib,
  self,
  ...
}: {
    perSystem  = {
        pkgs,
        system,
        inputs',
        self',
        ...
      }: let

          docModules = (inputs.flake-parts.lib.evalFlakeModule { inherit inputs; }
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
            });

            # Create a function that takes a filter string and returns a transformOptions function
            mkTransformOptions = filterString: option:
              option
              // rec {
                # Rename the option to remove the "perSystem." prefix
                name = if lib.hasPrefix "perSystem." option.name
                       then lib.removePrefix "perSystem." option.name
                       else option.name;

                declarations =
                  lib.concatMap
                  (declaration:
                    if lib.hasPrefix "${self}/modules/" declaration && lib.strings.hasInfix filterString declaration
                    then [
                      rec {
                        name = lib.removePrefix "${self}/modules/" declaration;
                        url = "modules/${builtins.head (builtins.split "," name)}";
                      }
                    ]
                    else [])
                  option.declarations;
                visible = declarations != [] && name != "" && name != "perSystem";
              };

            # Create a function to generate documentation with a specific filter
            mkOptionsDoc = filterString: pkgs.nixosOptionsDoc {
              inherit (docModules) options;
              transformOptions = mkTransformOptions filterString;
              documentType = "none";
              warningsAreErrors = false;
            };

            # Define the documentation filters we want to generate
            docFilters = [
              "integrations"
              "languages"
              "just"
              "processes"
              "services"
              "scripts"
            ];

      in {
        packages = {
          # Main options-doc package that generates all documentation files
          options-doc = pkgs.runCommand "optionsdoc"
                                  {
                                    nativeBuildInputs = [ pkgs.pandoc pkgs.gnused ];
                                  } ''
                                  mkdir -p $out

                                  # Generate a separate markdown file for each filter
                                  ${lib.concatMapStringsSep "\n" (filter: ''
                                    echo "Generating documentation for ${filter}..."
                                    # First generate the markdown file
                                    pandoc --from=commonmark --to=gfm --output=$out/${filter}.md \
                                      < ${(mkOptionsDoc filter).optionsCommonMark}
                                  '') docFilters}

                                  echo "Documentation generated successfully!"
                                '';
        };


#        packages = rec {
#          copy-options-document-to-current-directory =
#            (inputs.nixago.lib.${system}.make {
#              output = options-document.name;
#              data = options-document;
#              engine = {data, ...}: data;
#              hook.mode = "copy";
#            })
#            .install;
#
#          options-document =
#            (pkgs.nixosOptionsDoc {
#              options =
#                (
#                  inputs.flake-parts.lib.evalFlakeModule
#                  {inherit inputs;}
#                  {
#                    imports = [topLevel.config.flake.flakeModules.default];
#                    options.perSystem = flake-parts-lib.mkPerSystemOption {
#                      config._module.args = {
#                        # Generate document for Linux so that the document includes CUDA related options, which are not available on Darwin.
#                        system = lib.mkDefault "x86_64-linux";
#                        pkgs = lib.mkDefault pkgs;
#                        inputs' = lib.mkDefault inputs';
#                        self' = lib.mkDefault self';
#                      };
#                    };
#                  }
#                )
#                .options;
#              documentType = "none";
#              markdownByDefault = true;
#              warningsAreErrors = false;
#              transformOptions = option:
#                option
#                // rec {
#                  declarations =
#                    lib.concatMap
#                    (declaration:
#                      if lib.hasPrefix "${flakeModule.self}/modules/" declaration
#                      then [
#                        rec {
#                          name = lib.removePrefix "${flakeModule.self}/modules/" declaration;
#                          url = "modules/${builtins.head (builtins.split "," name)}";
#                        }
#                      ]
#                      else [])
#                    option.declarations;
#                  visible = declarations != [];
#                };
#            })
#            .optionsCommonMark;
#        };
      };
}
