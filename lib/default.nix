lib: let
  # keep-sorted start
  command = import ./command.nix {inherit lib;};
  dag = import ./dag.nix {inherit lib;};
  docker = import ./docker.nix {inherit lib;};
  functions = import ./functions.nix {inherit lib;};
  hooks = import ./hooks.nix {inherit lib;};
  shell = import ./shell.nix {inherit lib;};
  strings = import ./strings.nix {inherit lib;};
  tool = import ./tool.nix {inherit lib;};
  types = import ./types {inherit lib;};
  # keep-sorted end
in {
  sbl = {
    # keep-sorted start
    inherit command;
    inherit dag;
    inherit docker;
    inherit functions;
    inherit hooks;
    inherit shell;
    inherit strings;
    inherit tool;
    inherit types;
    # keep-sorted end
  };

  inherit (functions) mkIntegration mkLanguage mkEnableOption' mkPackageManager;
  inherit (tool) mkTool mkToolCommand mkToolCommandHook;
  inherit (docker) mkDockerService mkDockerComposeService mkDockerComposeRuntimeService;
}
