{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.services = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      pkgs,
      config,
      ...
    }: let
      inherit (lib) types mkOption;

      cfg = config.snow-blower.services.adminer;
    in {
      options.snow-blower.services.adminer = {
        enable = lib.mkEnableOption "Adminer process";

        package = lib.mkOption {
          type = types.package;
          description = "Which package of Adminer to use.";
          default = pkgs.adminer;
          defaultText = lib.literalExpression "pkgs.adminer";
        };

        listen = lib.mkOption {
          type = types.str;
          description = "Listen address for the Adminer.";
          default = "127.0.0.1:8080";
        };
      };

      config.process-compose.watch-server = {
        settings.processes = lib.mkIf cfg.enable {
          adminer.command = "${config.snow-blower.languages.php.package}/bin/php ${lib.optionalString config.snow-blower.services.mysql.enable "-dmysqli.default_socket=${config.snow-blower.env.MYSQL_UNIX_PORT}"} -S ${cfg.listen} -t ${cfg.package} ${cfg.package}/adminer.php";
        };
      };
    });
  };
}
