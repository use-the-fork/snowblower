lib: let
  functions = import ./functions.nix {inherit lib;};
  dag = import ./dag.nix {inherit lib;};
  shell = import ./shell.nix {inherit lib;};
in {
  sbl = {
    inherit (functions) mkIntegration mkLanguage mkCodeQualityTool mkCodeQualityCommand;
    inherit dag;
    inherit shell;
  };

  inherit (functions) mkIntegration mkLanguage mkCodeQualityTool mkCodeQualityCommand;
}
