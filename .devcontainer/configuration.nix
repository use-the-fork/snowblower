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
              settings = {
                exclude = [".bzr" ".direnv" ".eggs" ".git" ".git-rewrite" ".hg" ".ipynb_checkpoints" ".mypy_cache" ".nox" ".pants.d" ".pyenv" ".pytest_cache" ".pytype" ".ruff_cache" ".svn" ".tox" ".venv" ".vscode" "__pypackages__" "_build" "buck-out" "build" "dist" "node_modules" "site-packages" "venv"];
              };
            };
          };
        };
      };
    };
  };
}
