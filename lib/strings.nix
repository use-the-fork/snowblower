{lib, ...}: let
  # Function to modify file content with substitutions, prepends, and appends
  modifyFileContent = {
    file, # The file or derivation to modify
    substitute ? {}, # Key-value pairs for search and replace
    prepend ? "", # Text to add at the beginning of the file
    append ? "", # Text to add at the end of the file
  }: let
    fileContent = builtins.readFile file;

    # Apply all substitutions
    contentWithSubstitutions =
      lib.foldl
      (
        content: name: let
          replacement = substitute.${name};
        in
          builtins.replaceStrings [name] [replacement] content
      )
      fileContent
      (builtins.attrNames substitute);

    # Add prepend and append
    finalContent =
      (
        if prepend != ""
        then prepend + "\n"
        else ""
      )
      + contentWithSubstitutions
      + (
        if append != ""
        then "\n" + append
        else ""
      );
  in
    finalContent;
in {
  inherit modifyFileContent;
}
