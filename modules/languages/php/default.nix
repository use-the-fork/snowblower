{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.languages-php = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      pkgs,
      config,
      ...
    }: let
      inherit (lib) types mkOption literalExpression attrValues getAttrs;

      filterDefaultExtensions = ext: builtins.length (builtins.filter (inner: inner == ext.extensionName) cfg.disableExtensions) == 0;

      configurePackage = package:
        package.buildEnv {
          extensions = {
            all,
            enabled,
          }:
            with all; (builtins.filter filterDefaultExtensions (enabled ++ attrValues (getAttrs cfg.extensions package.extensions)));
          extraConfig = cfg.ini;
        };

      cfg = config.snow-blower.languages.php;
      srv = config.snow-blower.services;
    in {
      options.snow-blower.languages.php = {
        enable = lib.mkEnableOption "tools for PHP development";

        version = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "The PHP version to use.";
        };

        package = lib.mkOption {
          type = lib.types.package;
          default = configurePackage pkgs.php;
          defaultText = literalExpression "pkgs.php";
          description = ''
            Allows you to [override the default used package](https://nixos.org/manual/nixpkgs/stable/#ssec-php-user-guide)
            to adjust the settings or add more extensions. You can find the
            extensions using `devenv search 'php extensions'`
          '';
          example = literalExpression ''
            pkgs.php.buildEnv {
              extensions = { all, enabled }: with all; enabled ++ [ xdebug ];
              extraConfig = '''
                memory_limit=1G
              ''';
            };
          '';
        };

        packages = lib.mkOption {
          type = lib.types.submodule {
            options = {
              composer = lib.mkOption {
                type = lib.types.nullOr lib.types.package;
                default = cfg.package.packages.composer;
                defaultText = lib.literalExpression "pkgs.phpPackages.composer";
                description = "composer package";
              };
            };
          };
          defaultText = lib.literalExpression "pkgs";
          default = {};
          description = "Attribute set of packages including composer";
        };

        ini = lib.mkOption {
          type = lib.types.nullOr lib.types.lines;
          default = "";
          description = ''
            PHP.ini directives. Refer to the "List of php.ini directives" of PHP's
          '';
        };

        extensions = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = ''
            PHP extensions to enable.
          '';
        };

        disableExtensions = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = ''
            PHP extensions to disable.
          '';
        };
      };

      config.snow-blower = lib.mkIf cfg.enable {
        languages.php = {
          ini = ''
            ${lib.optionalString srv.mysql.enable ''
              pdo_mysql.default_socket = ''${MYSQL_UNIX_PORT}
              mysqli.default_socket = ''${MYSQL_UNIX_PORT}
            ''}
            ${lib.optionalString srv.blackfire.enable ''
              blackfire.agent_socket = "${srv.blackfire.socket}";
            ''}
          '';
        };

        packages = with pkgs;
          [
            cfg.package
          ]
          ++ lib.optional (cfg.packages.composer != null) cfg.packages.composer;
      };
    });
  };
}
