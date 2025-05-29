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
    };
  };
}
