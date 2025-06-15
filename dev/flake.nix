{
  inputs = {
    # snow-blower.url = "path:./../";
    snow-blower.url = "git+https://github.com/use-the-fork/snowblower?ref=2.x-dev";
  };

  outputs = inputs:
    inputs.snow-blower.mkSnow ({config, ...}: {
      config.snowblower = {
        languages.javascript = {
          enable = true;
          npm.enable = true;
        };

        process."npm-dev" = {
          enable = true;
          exec = "npm run dev";
          port = {
            container = 5432;
            host = 5432;
          };
        };
      };
    });
}
