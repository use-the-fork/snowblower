{config, pkgs, ...}: {
  config = {
    snowblower = {
      languages = {
        python = {
          enable = true;
          package = pkgs.python311;
          tools = {
            ruff = {
              enable = true;
            };
          };
        };
        javascript = {
          enable = true;
          package = pkgs.nodejs_22;
          tools = {
            yarn = {
              enable = true;
              package = pkgs.yarn-berry;
            };
            prettier = {
              enable = true;
              package = pkgs.prettierd;
            };
          };
        };
      };
      shell_tools = {
        aider = {
          enable = true;
          package = pkgs.aider-chat;
        };
        git = {
          enable = true;
          user_name = "use-the-fork";
          user_email = "23747916+use-the-fork@users.noreply.github.com";
          package = pkgs.gitFull;
        };
      };
    };
  };
}
