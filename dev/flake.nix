{
  inputs = {
    snow-blower.url = "path:./../";
  };

  outputs = inputs:
    inputs.snow-blower.mkSnowBlower {
      snow-blower = {pkgs, ...}: {
        paths.src = ./.;
        dotenv.enable = true;
        languages = {
          javascript.enable = true;
          javascript.npm.enable = true;
        };

        services = {
          redis.enable = false;
        };

        codeQuality = {
          ruff.enable = false;
          alejandra.enable = true;
          nixfmt.enable = false;
          biome.enable = false;
          deadnix.enable = true;
          mdformat.enable = true;
          statix = {
            enable = true;
            settings.config = {
              disabled-lints = [
                "manual_inherit_from"
              ];
            };
          };
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

          # treefmt = {
          #   programs = {
          #     alejandra.enable = true;
          #     deadnix.enable = true;
          #     statix = {
          #       enable = true;
          #       disabled-lints = [
          #         "manual_inherit_from"
          #       ];
          #     };
          #   };
          # };

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
}
