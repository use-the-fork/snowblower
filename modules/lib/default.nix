lib: let
  functions = import ./functions.nix {inherit lib;};
in {
  snowblower = {
    inherit (functions) mkIntegration mkLanguage mkCodeQualityTool mkCodeQualityCommand;
  };

  inherit (functions) mkIntegration mkLanguage mkCodeQualityTool mkCodeQualityCommand;
}
