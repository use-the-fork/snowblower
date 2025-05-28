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


   

    # Define the documentation filters we want to generate
  in {
    packages = {
      # Main options-doc package that generates all documentation files
      make-config =
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