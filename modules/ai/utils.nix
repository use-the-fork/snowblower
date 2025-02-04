{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types mkOption mkEnableOption;

  # a utility helper to standerdize ai options.
  mkAi = {
    name,
    message,
    examples,
    model ? "gpt-4-turbo",
    temperature ? 1,
    maxTokens ? null,
    extraOptions ? {}, # used to define additional modules
  }: {
    enable = mkEnableOption "${name} ai command";
    prompt = {
      message = mkOption {
        type = types.lines;
        default = message;
        description = "The system message that will be used at the start of the prompt.";
      };
      examples = mkOption {
        type = types.lines;
        default = examples;
        description = "A good prompt should always be a few shot or multi shot prompt.";
      };
    };
    settings =
      {
        model = mkOption {
          type = types.enum [
            "gpt-4-turbo"
            "gpt-4o"
            "gpt-4o-mini"
          ];
          default = model;
          description = "The name of the dotenv file to load, or a list of dotenv files to load in order of precedence.";
        };

        temperature = mkOption {
          type = types.int;
          default = temperature;
          description = "What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic.";
        };

        maxTokens = mkOption {
          type = types.nullOr types.int;
          default = maxTokens;
          description = "The maximum number of tokens that can be generated in the chat completion. The total length of input tokens and generated tokens is limited by the model's context length.";
        };
      }
      // extraOptions;
  };

  mkAiScript = {
    system_message,
    model,
    name,
    temperature ? "",
    maxTokens ? "",
  }: let
    maxTokensPart =
      if maxTokens == null
      then ""
      else ''max_tokens: ${toString maxTokens},'';
  in
    pkgs.writeShellScriptBin "ai-${name}" ''
          #!/usr/bin/env bash

          UNAMEOUT="$(uname -s)"

          # Verify operating system is supported...
          case "''${UNAMEOUT}" in
              Linux*)             MACHINE=linux;;
              Darwin*)            MACHINE=mac;;
              *)                  MACHINE="UNKNOWN"
          esac

          if [ "$MACHINE" == "UNKNOWN" ]; then
              echo "Unsupported operating system [$(uname -s)]. These commands are only supported in macOS, Linux, and Windows (WSL2)." >&2

              exit 1
          fi


          # Determine if stdout is a terminal...
          if test -t 1; then
              # Determine if colors are supported...
              ncolors=$(tput colors)

              if test -n "$ncolors" && test "$ncolors" -ge 8; then
                # Text attributes
                BOLD="$(tput bold)"
                UNDERLINE="$(tput smul)"
                BLINK="$(tput blink)"
                REVERSE="$(tput rev)"
                NC="$(tput sgr0)"  # No Color

                # Regular colors
                BLACK="$(tput setaf 0)"
                RED="$(tput setaf 1)"
                GREEN="$(tput setaf 2)"
                YELLOW="$(tput setaf 3)"
                BLUE="$(tput setaf 4)"
                MAGENTA="$(tput setaf 5)"
                CYAN="$(tput setaf 6)"
                WHITE="$(tput setaf 7)"
              fi
          fi

          # Check if OPENAI_API_KEY environment variable is set
          if [ -z "$OPENAI_API_KEY" ]; then
            echo "''${RED}The environment variable OPENAI_API_KEY is not set.''${NC}"
            echo "''${RED}Please set this variable and try again.''${NC}"
            exit 1
          fi

          # The first argument is the file where the commit message is stored

          # Define the system message
          system_message="${system_message}"

          # Ask the user to input a command to run
          read -p "Command to Generate: " user_command

          # Validate the user input
          if [ -z "$user_command" ]; then
            echo "''${RED}No command entered. Exiting.''${NC}"
            exit 0
          fi

          # Get the API key from the environment variable
          ENDPOINT="https://api.openai.com/v1/chat/completions"

          # Prepare the data for the OpenAI API using the system message
          json_payload=$(${pkgs.jq}/bin/jq -n \
                            --arg userCommand "$user_command" \
                            --arg systemMessage "$system_message" \
                            '{model: "${model}", temperature: ${toString temperature}, ${maxTokensPart} messages: [
                                {role: "system", content: $systemMessage},
                                {role: "user", content: $userCommand}
                              ]}')

          # Call the OpenAI API
          response=$(curl -s -X POST $ENDPOINT \
                             -H "Content-Type: application/json" \
                             -H "Authorization: Bearer $OPENAI_API_KEY" \
                             -d "$json_payload")

          # Extract the commit message from the response
          command_generated=$(echo $response | ${pkgs.jq}/bin/jq -r '.choices[0].message.content')

          # Check if the commit message is empty or not generated properly
          if [[ -z "$command_generated" || "$command_generated" == "null" ]]; then
            echo "''${RED}Failed to generate a valid command.''${NC}"
            exit 1
          fi

      # Write the AI-generated commit message to the Git commit message file
      echo
      echo ''${GREEN}$command_generated''${NC}
      echo
      read -p "Execute this command? (Press Enter or type Y for Yes): " confirmation

      case "$confirmation" in
        ""|[yY]|[yY][eE][sS])
          # Executes the command if Enter is pressed or Y/Yes is input
          $command_generated
          ;;
        *)
          echo "Command was rejected. Exiting."
          exit 0
          ;;
      esac

      # Exit after successful completion
      exit 0
    '';
in {
  inherit mkAi mkAiScript;
}
