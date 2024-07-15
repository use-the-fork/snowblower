{
  pkgs,
  lib,
  config,
}: let
  cfg = config.snow-blower.languages.javascript;
  nodeModulesPath = "${lib.optionalString (cfg.directory != config.devenv.root) ''"${cfg.directory}/"''}node_modules";
in
  pkgs.writeShellScript "init-yarn.sh" ''
    function _devenv-yarn-install()
    {
      # Avoid running "yarn install" for every shell.
      # Only run it when the "yarn.lock" file or nodejs version has changed.
      # We do this by storing the nodejs version and a hash of "yarn.lock" in node_modules.
      local ACTUAL_YARN_CHECKSUM="${cfg.yarn.package.version}:$(${pkgs.nix}/bin/nix-hash --type sha256 ${lib.optionalString (cfg.directory != config.devenv.root) ''"${cfg.directory}/"''}yarn.lock)"
      local YARN_CHECKSUM_FILE="${nodeModulesPath}/yarn.lock.checksum"
      if [ -f "$YARN_CHECKSUM_FILE" ]
        then
          read -r EXPECTED_YARN_CHECKSUM < "$YARN_CHECKSUM_FILE"
        else
          EXPECTED_YARN_CHECKSUM=""
      fi

      if [ "$ACTUAL_YARN_CHECKSUM" != "$EXPECTED_YARN_CHECKSUM" ]
      then
        if ${cfg.yarn.package}/bin/yarn install ${lib.optionalString (cfg.directory != config.devenv.root) "--cwd ${cfg.directory}"}
        then
          echo "$ACTUAL_YARN_CHECKSUM" > "$YARN_CHECKSUM_FILE"
        else
          echo "Install failed. Run 'yarn install' manually."
        fi
      fi
    }

    if [ ! -f ${lib.optionalString (cfg.directory != config.devenv.root) ''"${cfg.directory}/"''}package.json ]
    then
      echo "No package.json found${lib.optionalString (cfg.directory != config.devenv.root) ''"in ${cfg.directory}"''}. Run '${lib.optionalString (cfg.directory != config.devenv.root) ''"cd ${cfg.directory}/ && "''}yarn init' to create one." >&2
    else
      _devenv-yarn-install
    fi
  ''
