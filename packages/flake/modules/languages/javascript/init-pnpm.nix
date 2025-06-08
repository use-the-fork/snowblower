{
  pkgs,
  lib,
  config,
}: let
  cfg = config.snowblower.languages.javascript;
  nodeModulesPath = "${lib.optionalString (cfg.directory != config.snowblower.paths.root) ''"${cfg.directory}/"''}node_modules";
in
  pkgs.writeShellScript "init-pnpm.sh" ''
    function _devenv-pnpm-install()
    {
      # Avoid running "pnpm install" for every shell.
      # Only run it when the "package-lock.json" file or nodejs version has changed.
      # We do this by storing the nodejs version and a hash of "package-lock.json" in node_modules.
      local ACTUAL_PNPM_CHECKSUM="${cfg.pnpm.package.version}:$(${pkgs.nix}/bin/nix-hash --type sha256 ${lib.optionalString (cfg.directory != config.snowblower.paths.root) ''"${cfg.directory}/"''}pnpm-lock.yaml)"
      local PNPM_CHECKSUM_FILE="${nodeModulesPath}/pnpm-lock.yaml.checksum"
      if [ -f "$PNPM_CHECKSUM_FILE" ]
        then
          read -r EXPECTED_PNPM_CHECKSUM < "$PNPM_CHECKSUM_FILE"
        else
          EXPECTED_PNPM_CHECKSUM=""
      fi

      if [ "$ACTUAL_PNPM_CHECKSUM" != "$EXPECTED_PNPM_CHECKSUM" ]
      then
        if ${cfg.pnpm.package}/bin/pnpm install ${lib.optionalString (cfg.directory != config.snowblower.paths.root) "--dir ${cfg.directory}"}
        then
          echo "$ACTUAL_PNPM_CHECKSUM" > "$PNPM_CHECKSUM_FILE"
        else
          echo "Install failed. Run 'pnpm install' manually."
        fi
      fi
    }

    if [ ! -f ${lib.optionalString (cfg.directory != config.snowblower.paths.root) ''"${cfg.directory}/"''}package.json ]
    then
      echo "No package.json found${lib.optionalString (cfg.directory != config.snowblower.paths.root) ''"in ${cfg.directory}"''}. Run '${lib.optionalString (cfg.directory != config.snowblower.paths.root) ''"cd ${cfg.directory}/ && "''}pnpm init' to create one." >&2
    else
      _snow_blower-pnpm-install
    fi
  ''
