{
  inputs = {
    snow-blower.url = "github:use-the-fork/snow-blower";
  };

  outputs = inputs:
    inputs.snow-blower.mkSnowBlower {
      snow-blower = {pkgs, ...}: {
        paths.src = ./../../.;
        dotenv.enable = true;
        languages = {
          javascript.enable = true;
          javascript.npm.enable = true;
        };

        services = {
          redis.enable = true;
        };

        integrations = {
          aider = {
            enable = true;
            package = pkgs.aider-chat-full;
            commands = {
              start = {
                watchFiles = true;
                suggestShellCommands = false;
                readFiles = ["CONVENTIONS.MD"];
                lintCommands = ["treefmt"];
              };
            };
          };

          treefmt = {
            programs = {
              alejandra.enable = true;
              deadnix.enable = true;
              statix = {
                enable = true;
                disabled-lints = [
                  "manual_inherit_from"
                ];
              };
            };
          };

          agenix = {
            enable = true;
            secrets = {
              ".env.local" = {
                publicKeys = [
                  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0idNvgGiucWgup/mP78zyC23uFjYq0evcWdjGQUaBH"
                  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOSE69dmDxQ/UJ8k+8CL3lzc/PyJXXO/2aCcYQOjkTW+"
                ];
              };
            };
          };
        };
      };
    };
  # inputs.snow-blower.mkSnowBlower {

  #   imports = [
  #     #        inputs.snow-blower.flakeModules.optionsDocument
  #   ];

  #   perSystem = {...}: {
  #     # Per-system attributes can be defined here. The self' and inputs'
  #     # module parameters provide easy access to attributes of the same
  #     # system.
  #     # IE. You dont have to do `inputs.flake-parts.YOURSYSTEM.package` you can just do `inputs'.flake-parts.package`

  #     imports = [
  #       # ./foo.nix
  #     ];
  #     snow-blower = {
  #       paths.src = ./../../.;
  #       dotenv.enable = true;
  #       packages = [
  #       ];

  #       scripts = {
  #         "reload" = {
  #           just.enable = true;
  #           description = "reloads snow blower.";
  #           exec = ''
  #             direnv reload
  #           '';
  #         };
  #       };

  #       services = {
  #       };

  #       integrations = {

  #         aider = {
  #           enable = true;
  #           commands = {
  #             start = {
  #               watchFiles = true;
  #               suggestShellCommands = false;
  #               readFiles = ["CONVENTIONS.MD"];
  #               lintCommands = ["treefmt"];
  #             };
  #           };
  #         };

  #         agenix = {
  #           enable = true;
  #           secrets = {
  #             ".env.local" = {
  #               publicKeys = [
  #                 "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0idNvgGiucWgup/mP78zyC23uFjYq0evcWdjGQUaBH"
  #                 "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOSE69dmDxQ/UJ8k+8CL3lzc/PyJXXO/2aCcYQOjkTW+"
  #               ];
  #             };
  #           };
  #         };

  #         git-cliff.enable = true;

  #         git-hooks.hooks = {
  #           treefmt = {
  #             enable = true;
  #           };
  #         };
  #       };
  #     };
  #   };
  # };
}
