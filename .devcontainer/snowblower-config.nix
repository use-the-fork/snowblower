{config, ...}: {
  config = {
    modules.tools.aider.enable = true;
    modules.languages = {
      python = {
        enable = true;
      };
      javascript = {
        enable = false;
      };
      php = {
        enable = false;
        settings = {
          extensions = ["grpc" "redis" "imagick" "memcached" "xdebug"];
          ini = {
            PHP = {
              memory_limit = "5G";
              max_execution_time = "90";
            };
          };
        };
      };
    };
  };
}
