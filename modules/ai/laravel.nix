{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.ai = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      pkgs,
      config,
      ...
    }: let
      inherit (lib) types mkOption;

      system_message = ''        You are a helpful assistant trained to generate Laravel commands based on the users request.

              Only respond with the laravel command, NOTHING ELSE, DO NOT wrap it in quotes or backticks.

              # Examples

              user: a command that sends emails.
              response: php artisan make:command SendEmails

              user: a model for flights include the migration
              response: php artisan make:model Flight --migration

              user: a model for flights include the migration resource and request
              response: php artisan make:model Flight --controller --resource --requests

              user: Flight model overview
              response: php artisan model:show Flight

              user: Flight controller
              response: php artisan make:controller FlightController

              user: erase and reseed the database forefully
              response: php artisan migrate:fresh --seed --force

              user: what routes are avliable?
              response: php artisan route:list

              user: rollback migrations 5 times
              response: php artisan migrate:rollback --step=5

              user: start a q worker
              response: php artisan queue:work
      '';

      ai-commit = pkgs.writeShellScriptBin "ai-commit" ''
        # The first argument is the file where the commit message is stored

        # Define the system message
        system_message="${system_message}"

        # Ask the user to input a command to run
        read -p "Command to Generate: " user_command

        # Validate the user input
        if [ -z "$user_command" ]; then
          echo "No command entered. Exiting."
          exit 1
        fi

        # Get the API key from the environment variable
        ENDPOINT="https://api.openai.com/v1/chat/completions"

        # Prepare the data for the OpenAI API using the system message
        json_payload=$(${pkgs.jq}/bin/jq -n \
                          --arg userCommand "$user_command" \
                          --arg systemMessage "$system_message" \
                          '{model: "gpt-4-turbo", messages: [
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
          echo "Failed to generate a valid command."
          exit 1
        fi

        # Write the AI-generated commit message to the Git commit message file
        echo
        echo $command_generated
        echo
        read -p "Execute this command? (Y/N): " confirmation

        case "$confirmation" in
          [yY][eE][sS]|[yY])
            # Executes the command
            $command_generated
            ;;
          *)
            echo "Command was rejected. Exiting."
            exit 1
            ;;
        esac

        # Exit after successful completion
        exit 0
      '';
    in {
      options.snow-blower.ai.laravel = {
        enable = lib.mkOption {
          type = lib.types.either lib.types.str (lib.types.listOf lib.types.str);
          default = ".env";
          description = "The name of the dotenv file to load, or a list of dotenv files to load in order of precedence.";
        };
        #        model = mkOption {
        #                                         type = types.str;
        #                                         default = "gpt-4-turbo";
        #                                         description = "The name of the dotenv file to load, or a list of dotenv files to load in order of precedence.";
        #                                       };
        #        temperature = mkOption {
        #                                         type = types.int;
        #                                         default = 1;
        #                                         description = "What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic.";
        #                                       };
        #        max_tokens = mkOption {
        #                                         type = types.str;
        #                                         default = ".env";
        #                                         description = "The name of the dotenv file to load, or a list of dotenv files to load in order of precedence.";
        #                                       };
      };

      config.snow-blower = {
        packages = [ai-commit];

        just.recipes.ai-laravel = {
          enable = true;
          justfile = lib.mkDefault ''
            #generates a `artisan` command.
            @ai-artisan:
              ${lib.getExe ai-commit}
          '';
        };
      };
    });
  };
}
