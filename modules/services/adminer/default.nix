{
  inputs,
  flake-parts-lib,
  self,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.services = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      pkgs,
      config,
      lib,
      ...
    }: let
      inherit (self.lib.sb) mkService;

      cfg = config.snow-blower.services.adminer;
    in {
      options.snow-blower.services.adminer = mkService {
        name = "Adminer";
        package = pkgs.adminer;
        port = 8080;
      };

      config.snow-blower.processes = lib.mkIf cfg.enable {
        adminer.exec = "${config.snow-blower.languages.php.package}/bin/php ${lib.optionalString config.snow-blower.services.mysql.enable "-dmysqli.default_socket=${config.snow-blower.env.MYSQL_UNIX_PORT}"} -S ${cfg.settings.host}:${toString cfg.settings.port} -t ${cfg.package} ${cfg.package}/adminer.php";
      };
    });
  };
}
