{
  pkgs,
  lib,
  config,
}: let
  cfg = config.snow-blower.languages.javascript;
  nodeModulesPath = "${lib.optionalString (cfg.directory != config.devenv.root) ''"${cfg.directory}/"''}node_modules";
in
  pkgs.writeShellScript "init-npm.sh" ''
    function _devenv-npm-install()
    {
      # Avoid running "npm install" for every shell.
      # Only run it when the "package-lock.json" file or nodejs version has changed.
      # We do this by storing the nodejs version and a hash of "package-lock.json" in node_modules.
      local ACTUAL_NPM_CHECKSUM="${cfg.npm.package.version}:$(${pkgs.nix}/bin/nix-hash --type sha256 ${lib.optionalString (cfg.directory != config.devenv.root) ''"${cfg.directory}/"''}package-lock.json)"
      local NPM_CHECKSUM_FILE="${nodeModulesPath}/package-lock.json.checksum"
      if [ -f "$NPM_CHECKSUM_FILE" ]
        then
          read -r EXPECTED_NPM_CHECKSUM < "$NPM_CHECKSUM_FILE"
        else
          EXPECTED_NPM_CHECKSUM=""
      fi

      if [ "$ACTUAL_NPM_CHECKSUM" != "$EXPECTED_NPM_CHECKSUM" ]
      then
        if ${cfg.npm.package}/bin/npm install ${lib.optionalString (cfg.directory != config.devenv.root) "--prefix ${cfg.directory}"}
        then
          echo "$ACTUAL_NPM_CHECKSUM" > "$NPM_CHECKSUM_FILE"
        else
          echo "Install failed. Run 'npm install' manually."
        fi
      fi
    }

    if [ ! -f ${lib.optionalString (cfg.directory != config.devenv.root) ''"${cfg.directory}/"''}package.json ]
    then
      echo "No package.json found${lib.optionalString (cfg.directory != config.devenv.root) ''"in ${cfg.directory}"''}. Run '${lib.optionalString (cfg.directory != config.devenv.root) ''"cd ${cfg.directory}/ && "''}npm init' to create one." >&2
    else
      _devenv-npm-install
    fi
  ''
