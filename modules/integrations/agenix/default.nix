{
  inputs,
  flake-parts-lib,
  ...
}: {
  # This is a modified implementation of https://github.com/aciceri/agenix-shell/blob/master/flakeModules/agenix-shell.nix
  # I prefer to use the agenix package and conform to the secrets and decrption style there. Its just easier to use that way.

  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.integrations = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      config,
      pkgs,
      system,
      ...
    }: let
      inherit (lib) mkOption types mkEnableOption;

      cfg = config.snow-blower.integrations.agenix;

      #We use this to figure out where our age file is in relation to the root of the flake.

      secretType = types.submodule ({config, ...}: {
        options = {
          name = mkOption {
            default = config._module.args.name;
            description = "Name of the Env file containing the secrets.";
            defaultText = lib.literalExpression "<name>";
            example = lib.literalExpression ''.env.local'';
          };

          file = mkOption {
            type = types.str;
            default = "secrets/${config._module.args.name}.age";
            description = ''
              Age file the secret is loaded from. Relative to flake root.
            '';
          };

          mode = mkOption {
            type = types.str;
            default = "0644";
            description = "Permissions mode of the decrypted secret in a format understood by chmod.";
          };

          publicKeys = mkOption {
            type = types.listOf types.str;
            description = "A list of public keys that are used to encrypt the secret.";
            example = lib.literalExpression ''["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDpVA+jisOuuNDeCJ67M11qUP8YY29cipajWzTFAobi"]'';
            default = cfg.settings.publicKeys;
          };
        };
      });
    in {
      options.snow-blower.integrations.agenix = {
        enable = mkEnableOption "Agenix .env Integration";

        package = mkOption {
          type = lib.types.package;
          description = "The package agenix should use.";
          default = inputs.agenix.packages.${system}.default;
        };

        secrets = mkOption {
          type = types.attrsOf secretType;
          description = "Attrset of secrets.";
          example = lib.literalExpression ''
            {
              ".env.local" = {
                publicKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDpVA+jisOuuNDeCJ67M11qUP8YY29cipajWzTFAobi"];
              };
            }
          '';
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
                                  ${lib.getExe' cfg.package "agenix"} -e "''${options[choice-1]}"
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
              echo "''${GREEN}[agenix] decrypting secret file: ${secret.name}''${NC}"
              (
                umask u=r,g=,o=
                test -f "${secret.file}" || echo "''${RED}[agenix] WARNING: encrypted file ${secret.file} does not exist! Is it part of your repo?''${NC}"
                ${lib.getExe' cfg.package "agenix"} --decrypt "${secret.file}" > ${secret.name}
              )

               # Capture the exit status of the subshell
               exit_status=$?

              if [ "$exit_status" -eq 0 ]; then
                  chmod ${secret.mode} ${secret.name}
                  echo "''${GREEN}[agenix] decrypted''${NC}"
              else
                  echo "''${RED}[agenix] Failed to prepare ${secret.name}.''${NC}"
                  echo "''${YELLOW}[agenix] This usually means the .age file dosen't exsist. Run 'just agenix' or 'edit-secret' to fix this. ''${NC}"
                  echo
              fi
            '';

            # this is an option in the agenix-shell package but since we want to make it condintally we move it here.
            # In addition we want to link up our own secrets file.
            installationScript =
              ''
                ln -sf ${builtins.toString secretsfile} ./secrets.nix
              ''
              + lib.concatStrings (lib.mapAttrsToList (_: _installSecret) cfg.secrets);
          in {
            # we need to have our install script run ahead of everything since it's decrptying things the env may use.
            startup = lib.mkBefore [installationScript];
          };
        };
      };
    });
  };
}
