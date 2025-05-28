{config, pkgs, ...}: {
  config = {
    snowblower = {
      tools = {
        aider.enable = true;
        git = {
          userName = "use-the-fork";
          userEmail = "23747916+use-the-fork@users.noreply.github.com";
        };
      };
      languages = {
        python = {
          enable = true;
          package = pkgs.python311;
          tools = {
            uv = {
              enable = true;
             };
            ruff = {
              enable = true;
              settings = {
                config = {
                  exclude = [".bzr" ".direnv" ".eggs" ".git" ".git-rewrite" ".hg" ".ipynb_checkpoints" ".mypy_cache" ".nox" ".pants.d" ".pyenv" ".pytest_cache" ".pytype" ".ruff_cache" ".svn" ".tox" ".venv" ".vscode" "__pypackages__" "_build" "buck-out" "build" "dist" "node_modules" "site-packages" "venv"];
                };
              };
            };
          };
        };
      };
    };
  };
}
