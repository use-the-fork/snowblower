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
