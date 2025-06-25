# Credits to https://github.com/nix-community/home-manager/blob/master/modules/files.nix
# Massivly useful helper that lets us create files and then copy them locally as needed.
{
  lib,
  pkgs,
}: let
  inherit
    (lib)
    literalExpression
    mkDefault
    mkIf
    mkOption
    types
    ;
in {
  # Constructs a type suitable for a `home.file` like option. The
  # target path may be either absolute or relative, in which case it
  # is relative the `basePath` argument (which itself must be an
  # absolute path).
  #
  # Arguments:
  #   - opt            the name of the option, for self-references
  #   - basePathDesc   docbook compatible description of the base path
  #   - basePath       the file base path
  fileType = opt: basePathDesc: _basePath:
    types.attrsOf (
      types.submodule (
        {
          name,
          config,
          ...
        }: {
          options = {
            enable = mkOption {
              type = types.bool;
              default = true;
              description = ''
                Whether this file should be generated. This option allows specific
                files to be disabled.
              '';
            };

            target = mkOption {
              type = types.str;
              defaultText = literalExpression "name";
              description = ''
                Path to target file relative to ${basePathDesc}.
              '';
            };

            text = mkOption {
              default = null;
              type = types.nullOr types.lines;
              description = ''
                Text of the file. If this option is null then
                [](#opt-${opt}._name_.source)
                must be set.
              '';
            };

            source = mkOption {
              type = types.path;
              description = ''
                Path of the source file or directory. If
                [](#opt-${opt}._name_.text)
                is non-null then this option will automatically point to a file
                containing that text.
              '';
            };

            executable = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = ''
                Set the execute bit. If `null`, defaults to the mode
                of the {var}`source` file or to `false`
                for files created through the {var}`text` option.
              '';
            };
          };

          config = {
            target = mkDefault name;
            source = mkIf (config.text != null) (
              mkDefault (
                pkgs.writeTextFile {
                  name = config.target;
                  inherit (config) text;
                  executable =
                    if config.executable == null
                    then false
                    else config.executable;
                }
              )
            );
          };
        }
      )
    );
}
