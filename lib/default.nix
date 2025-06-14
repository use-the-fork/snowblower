lib: let
  types = import ./types {inherit lib;};
  functions = import ./functions.nix {inherit lib;};
  command = import ./command.nix {inherit lib;};
  dag = import ./dag.nix {inherit lib;};
  shell = import ./shell.nix {inherit lib;};
  strings = import ./strings.nix {inherit lib;};
in {
  sbl = {
    inherit (functions) mkIntegration mkLanguage mkCodeQualityTool mkCodeQualityCommand mkEnableOption' mkPackageManager;
    inherit types;
    inherit command;
    inherit dag;
    inherit shell;
    inherit strings;
  };

  inherit (functions) mkIntegration mkLanguage mkCodeQualityTool mkCodeQualityCommand mkEnableOption' mkPackageManager;
}
