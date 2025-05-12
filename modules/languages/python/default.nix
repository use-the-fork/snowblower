{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.languages = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      pkgs,
      config,
      ...
    }: let
      inherit (lib) types mkOption literalExpression;

      cfg = config.snow-blower.languages.python;
    in {
      options.snow-blower.languages.python = {
        enable = lib.mkEnableOption "tools for Python development";

        version = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = "3.11";
          description = ''
            The Python version to use.
            This is used by UV to download the proper python version.
          '';
          example = "3.11 or 3.11.2";
        };

        venv.enable = lib.mkEnableOption "Python virtual environment";

        uv = {
          package = lib.mkOption {
            type = lib.types.package;
            default = pkgs.uv;
            defaultText = lib.literalExpression "pkgs.uv";
            description = "The uv package to use.";
          };
        };
      };

      config.snow-blower = lib.mkIf cfg.enable {
        packages = [cfg.uv.package];

        env = {
          UV_CACHE_DIR = config.snow-blower.env.PROJECT_STATE + "/uv/cache";
          UV_PROJECT_ENVIRONMENT = config.snow-blower.env.PROJECT_STATE + "/uv/environment";
          UV_PYTHON_BIN_DIR = config.snow-blower.env.PROJECT_STATE + "/uv/python/bin";
          UV_PYTHON_CACHE_DIR = config.snow-blower.env.PROJECT_STATE + "/uv/python/cache";
          UV_PYTHON_INSTALL_DIR = config.snow-blower.env.PROJECT_STATE + "/uv/python/install";
          UV_TOOL_BIN_DIR = config.snow-blower.env.PROJECT_STATE + "/uv/tools/bin";
          UV_TOOL_DIR = config.snow-blower.env.PROJECT_STATE + "/uv/tools";
        };

        scripts = lib.mkIf (!cfg.venv.enable) {
          # remap PIP command to point at UV
          # pip.exec = ''${lib.getExe cfg.uv.package} $@'';

          # remap python commands to point at uv run
          # python3.exec = ''${lib.getExe cfg.uv.package} run $@'';
          # python.exec = ''${lib.getExe cfg.uv.package} run $@'';

          # convince wrapper for the UV tool function
          # tool.exec = ''${lib.getExe cfg.uv.package} tool $@'';
        };

        shell.startup =
          [
            ''
              ${lib.getExe cfg.uv.package} python install ${cfg.version}
              if [ ! -f ./pyproject.toml ]; then
                ${lib.getExe cfg.uv.package} init
              fi

            ''
          ]
          # Create a virtual Env if needed and log into it.
          ++ (lib.optional cfg.venv.enable ''
            source ${config.snow-blower.env.UV_PROJECT_ENVIRONMENT}/bin/activate
          '');
      };
    });
  };
}
