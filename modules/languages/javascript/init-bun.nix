{
pkgs,
lib,
config
}:let
  cfg = config.snow-blower.languages.javascript;
  nodeModulesPath = "${lib.optionalString (cfg.directory != config.devenv.root) ''"${cfg.directory}/"''}node_modules";
in
pkgs.writeShellScript "init-bun.sh" ''
    function _devenv-bun-install()
    {
      # Avoid running "bun install --yarn" for every shell.
      # Only run it when the "yarn.lock" file or nodejs version has changed.
      # We do this by storing the nodejs version and a hash of "yarn.lock" in node_modules.
      local ACTUAL_BUN_CHECKSUM="${cfg.bun.package.version}:$(${pkgs.nix}/bin/nix-hash --type sha256 ${lib.optionalString (cfg.directory != config.devenv.root) ''"${cfg.directory}/"''}yarn.lock)"
      local BUN_CHECKSUM_FILE="${nodeModulesPath}/yarn.lock.checksum"
      if [ -f "$BUN_CHECKSUM_FILE" ]
        then
          read -r EXPECTED_BUN_CHECKSUM < "$BUN_CHECKSUM_FILE"
        else
          EXPECTED_BUN_CHECKSUM=""
      fi

      if [ "$ACTUAL_BUN_CHECKSUM" != "$EXPECTED_BUN_CHECKSUM" ]
      then
        if ${cfg.bun.package}/bin/bun install --yarn ${lib.optionalString (cfg.directory != config.devenv.root) "--cwd ${cfg.directory}"}
        then
          echo "$ACTUAL_BUN_CHECKSUM" > "$BUN_CHECKSUM_FILE"
        else
          echo "Install failed. Run 'bun install --yarn' manually."
        fi
      fi
    }

    if [ ! -f ${lib.optionalString (cfg.directory != config.devenv.root) ''"${cfg.directory}/"''}package.json ]
    then
      echo "No package.json found${lib.optionalString (cfg.directory != config.devenv.root) ''"in ${cfg.directory}"''}. Run '${lib.optionalString (cfg.directory != config.devenv.root) ''"cd ${cfg.directory}/ && "''}bun init' to create one." >&2
    else
      _devenv-bun-install
    fi
  ''
