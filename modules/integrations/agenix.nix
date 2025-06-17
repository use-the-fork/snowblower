{
  inputs,
  flake-parts-lib,
  ...
}: {
  # This is a modified implementation of https://github.com/aciceri/agenix-shell/blob/master/flakeModules/agenix-shell.nix
  # I prefer to use the agenix package and conform to the secrets and decrption style there. Its just easier to use that way.

  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    pkgs,
    system,
    ...
  }: let
    inherit (lib) mkOption types mkEnableOption;

    cfg = config.snowblower.integration.agenix;

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
          default = [];
        };
      };
    });
  in {
    options.snowblower.integration.agenix = {
      enable = mkEnableOption "Agenix .env Integration";

      package = mkOption {
        type = lib.types.package;
        description = "The package agenix should use.";
        inherit (inputs.agenix.packages.${system}) default;
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
      snowblower = let
        _installSecret = secret: ''
          echoInfo "decrypting secret file" "${secret.name}"
          (
            umask u=r,g=,o=
            test -f "${secret.file}" || echoWarn "encrypted file ${secret.file} does not exist!" "Is it part of your repo?"
            ${lib.getExe' cfg.package "agenix"} --decrypt "${secret.file}" > ${secret.name}
          )

           # Capture the exit status of the subshell
           exit_status=$?

          if [ "$exit_status" -eq 0 ]; then
              chmod ${secret.mode} ${secret.name}
              echoOk "decrypted" "${secret.name}"
          else
              echoFail "Failed to prepare" "${secret.name}"
              echoWarn "This usually means the .age file doesn't exist." "Run 'just agenix' or 'edit-secret' to fix this."
              echo
          fi
        '';

        listOfSecret = lib.concatStrings (lib.mapAttrsToList (_: _installSecret) cfg.secrets);

        # A utility script to quickly be able to edit secrets.
        decryptSecret = pkgs.writeShellScriptBin "decrypt-secrets" ''
          #!/usr/bin/env bash
          ${listOfSecret}
        '';

        # A utility script to quickly be able to edit secrets.
        editSecret = pkgs.writeShellScriptBin "sb-agenix" (''
            ${builtins.readFile ./../../lib-bash/utils.sh}

            # Define the list of options
            options=(''
          + (lib.concatStringsSep " "
            (lib.mapAttrsToList
              (_name: secret: "\"${toString secret.file}\"")
              cfg.secrets))
          + ''            )

            # Function to display main menu
            show_menu() {
                echoSnow "Agenix Secret Management"
                echoBlank "1) Edit secret"
                echoBlank "2) Rekey secrets"
                echoBlank "3) Decrypt secrets"
                echo
                read -rp "Enter option number: " choice

                case $choice in
                    1)
                        select_file
                        ;;
                    2)
                        rekey_secrets
                        ;;
                    3)
                        decrypt_secrets
                        ;;
                    *)
                        echoFail "Invalid selection."
                        exit 1
                        ;;
                esac
            }

            # Function to rekey all secrets
            rekey_secrets() {
                echoInfo "Rekeying all secrets..."
                ${lib.getExe' cfg.package "agenix"} -r
                source ${lib.getExe decryptSecret}
            }

            # Function to decrypt all secrets
            decrypt_secrets() {
                echoInfo "Decrypting all secrets..."
                source ${lib.getExe decryptSecret}
            }

            # Function to display options and prompt the user for choice
            select_file() {
                echoSnow "Select a file to edit:"
                for i in "''${!options[@]}"; do
                    echoBlank "$((i+1))) ''${options[i]}"
                done

                # Prompt for a choice
                read -rp "Enter option number: " choice

                # Validate the choice
                if [[ ! $choice =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ''${#options[@]} )); then
                    echoFail "Invalid selection."
                    exit 1
                fi

                # Execute agenix -e with the selected option
                ${lib.getExe' cfg.package "agenix"} -e "''${options[choice-1]}"

                # run script to update files after rekey
                source ${lib.getExe decryptSecret}
            }

            # Check for command line arguments
            case "$1" in
                -e|--edit)
                    select_file
                    ;;
                -r|--rekey)
                    rekey_secrets
                    ;;
                -d|--decrypt)
                    decrypt_secrets
                    ;;
                "")
                    show_menu
                    ;;
                *)
                    echoFail "Unknown option: $1"
                    echo "Usage: sb-agenix [-e|--edit] [-r|--rekey] [-d|--decrypt]"
                    exit 1
                    ;;
            esac
          '');
      in {
        packages = [cfg.package editSecret];

        command."agenix" = {
          displayName = "Agenix";
          description = "Secret Management";
          exec = "sb-agenix";
          subcommand = {
            "rekey" = {
              description = "Rekey secrets";
              exec = "sb-agenix --rekey";
            };
          };
        };

        # hook.switch.activation."agenix-install"

        # this is an option in the agenix-shell package but since we want to make it condintally we move it here.
        # In addition we want to link up our own secrets file.
        file."secrets.nix" = {
          enable = true;
          text =
            "{\n"
            + (lib.concatStringsSep "\n"
              (lib.mapAttrsToList
                (_name: secret:
                  "\"${toString secret.file}\".publicKeys = [\n"
                  + lib.concatStringsSep " " (map (key: "\t\"${key}\"\n") secret.publicKeys)
                  + "];\n")
                cfg.secrets))
            + "\n}";
        };
      };
    };
  });
}
