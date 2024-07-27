{
  inputs,
  flake-parts-lib,
  ...
}: {
  # This is a direct implementation of https://github.com/aciceri/agenix-shell/blob/master/flakeModules/agenix-shell.nix

  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.integrations = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      config,
      pkgs,
      ...
    }: let
      inherit (lib) mkOption mkPackageOption types mkEnableOption;

      cfg = config.snow-blower.integrations.agenix;

      #We use this to figure out where our age file is in relation to the root of the flake.
      cfgPath = config.snow-blower.paths.src;

      secretType = types.submodule ({config, ...}: {
        options = {
          name = mkOption {
            default = config._module.args.name;
            description = "Name of the Env variable containing the secret.";
            defaultText = lib.literalExpression "<name>";
          };

          namePath = mkOption {
            default = "${config._module.args.name}_PATH";
            description = "Name of the variable containing the path to the secret.";
            defaultText = lib.literalExpression "<name>_PATH";
          };

          file = mkOption {
            type = types.str;
            description = ''
              Age file the secret is loaded from. Relative to your flake root.
            '';
          };

          mode = mkOption {
            type = types.str;
            default = "0400";
            description = "Permissions mode of the decrypted secret in a format understood by chmod.";
          };

          publicKeys = mkOption {
            type = types.listOf types.str;
            description = "A list of public keys that are used to encrypt the secret.";
            example = lib.literalExpression ''["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDpVA+jisOuuNDeCJ67M11qUP8YY29cipajWzTFAobi"]'';
          };

          ageFilePath = mkOption {
            type = types.str;
            internal = true;
            default = "${cfgPath}/${config.file}";
          };

          path = mkOption {
            type = types.str;
            default = "${cfg.settings.secretsPath}/${config.name}";
            internal = true;
            description = "Path where the decrypted secret is installed.";
            defaultText = lib.literalExpression ''"''${config.snow-blower.integrations.agenix.settings.secretsPath}/<name>"'';
          };
        };
      });
    in {
      options.snow-blower.integrations.agenix = {
        enable = mkEnableOption "Agenix Integration";

        package = mkPackageOption pkgs "age" {
          default = "rage";
        };

        secrets = mkOption {
          type = types.attrsOf secretType;
          description = "Attrset of secrets.";
          example = lib.literalExpression ''
            {
              foo = {
                file = "secrets/bar.age";
                mode = "0440";
                publicKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDpVA+jisOuuNDeCJ67M11qUP8YY29cipajWzTFAobi"];
              };
            }
          '';
        };

        settings = {
          flakeName = mkOption {
            type = types.str;
            default = "git rev-parse --show-toplevel | xargs basename";
            description = "Command returning the name of the flake, used as part of the secrets path.";
          };

          secretsPath = mkOption {
            type = types.str;
            default = ''/run/user/$(id -u)/snow-blower/$(${cfg.settings.flakeName})/$(uuidgen)'';
            defaultText = lib.literalExpression ''"/run/user/$(id -u)/agenix-shell/$(''${config.snow-blower.integrations.agenix.settings.flakeName})/$(uuidgen)"'';
            description = "Where the secrets are stored.";
          };

          identityPaths = mkOption {
            type = types.listOf types.str;
            default = [
              "$HOME/.ssh/id_ed25519"
              "$HOME/.ssh/id_rsa"
            ];
            description = ''
              Path to SSH keys to be used as identities in age decryption.
            '';
          };
        };
      };

      config = lib.mkIf cfg.enable {
        snow-blower = let
          # A utility script to quickly be able to edit secrets.
          editSecret = pkgs.writeShellScriptBin "edit-secret" (''
              #!/usr/bin/env bash

              # Define the list of options
              options=(''
            + (lib.concatStringsSep " "
              (lib.mapAttrsToList
                (_name: secret: "\"${toString secret.file}\"")
                cfg.secrets))
            + ''              )
                              # Function to display options and prompt the user for choice
                              select_option() {
                                  echo "Available options:"
                                  for i in "''${!options[@]}"; do
                                      printf "%3d) %s\n" $((i+1)) "''${options[i]}"
                                  done

                                  # Prompt for a choice
                                  read -rp "Enter option number: " choice

                                  # Validate the choice
                                  if [[ ! $choice =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ''${#options[@]} )); then
                                      echo "Invalid selection."
                                      exit 1
                                  fi

                                  # Execute agenix -e with the selected option
                                  agenix -e "''${options[choice-1]}"
                              }

                              # Call the function to execute the selection process
                              select_option
            '');
        in {
          packages = [cfg.package editSecret];

          just.recipes.agenix = {
            enable = lib.mkDefault true;
            justfile = lib.mkDefault ''
              # Choose a secret to edit.
              agenix:
                ${lib.getExe editSecret}
            '';
          };

          shell = let
            #This script puts tougether the secrets.nix file
            secretsfile = pkgs.writeTextFile {
              name = "secrets";
              text =
                "{\n"
                + (lib.concatStringsSep "\n"
                  (lib.mapAttrsToList
                    (_name: secret:
                      "\"${toString secret.file}\".publicKeys = ["
                      + lib.concatStringsSep " " (map (key: "\"${key}\"") secret.publicKeys)
                      + "];\n")
                    cfg.secrets))
                + "\n}";
            };

            _installSecret = secret: ''
               SECRET_PATH=${secret.path}

               # shellcheck disable=SC2193
               [ "$SECRET_PATH" != "${cfg.settings.secretsPath}/${secret.name}" ] && mkdir -p "$(dirname "$SECRET_PATH")"
               (
                 umask u=r,g=,o=
                 test -f "${secret.ageFilePath}" || echo "''${RED}[agenix] WARNING: encrypted file ${secret.file} does not exist! Is it part of your repo?''${NC}"
                 test -d "$(dirname "$SECRET_PATH")" || echo "''${RED}[agenix] WARNING: $(dirname "$SECRET_PATH") does not exist!''${NC}"
                 LANG=${config.i18n.defaultLocale or "C"} ${lib.getExe cfg.package} --decrypt "''${IDENTITIES[@]}" -o "$SECRET_PATH" "${secret.ageFilePath}"
               )

               # Capture the exit status of the subshell
               exit_status=$?

              if [ "$exit_status" -eq 0 ]; then
                ["echo '[agenix] decrypting secrets...'"]

                chmod ${secret.mode} "$SECRET_PATH"

                ${secret.name}=$(cat "$SECRET_PATH")
                ${secret.namePath}="$SECRET_PATH"
                export ${secret.name}
                export ${secret.namePath}
              else
                  echo "''${RED}Failed to prepare ${secret.name}.''${NC}"
                  echo "''${YELLOW}This usually means the .age file dosen't exsist. Run 'just agenix' or 'edit-secret' to fix this. ''${NC}"
                  echo
              fi
            '';

            # this is an option in the agenix-shell package but since we want to make it condintally we move it here.
            # In addition we want to link up our own secrets file.
            installationScript =
              ''
                ln -sf ${builtins.toString secretsfile} ./secrets.nix

                # shellcheck disable=SC2086
                rm -rf "${cfg.settings.secretsPath}"

                IDENTITIES=()
                # shellcheck disable=2043
                for identity in ${builtins.toString cfg.settings.identityPaths}; do
                  test -r "$identity" || continue
                  IDENTITIES+=(-i)
                  IDENTITIES+=("$identity")
                done

                test "''${#IDENTITIES[@]}" -eq 0 && echo "[agenix] WARNING: no readable identities found!"

                mkdir -p "${cfg.settings.secretsPath}"
              ''
              + lib.concatStrings (lib.mapAttrsToList (_: _installSecret) cfg.secrets);
          in {
            startup = [installationScript];
          };
        };
      };
    });
  };
}
