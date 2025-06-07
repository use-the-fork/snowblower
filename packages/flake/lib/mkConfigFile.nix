_: let
  mkConfigFile = {
    name,
    format,
    settings ? {},
  }: {
    files.config = [
      {
        inherit name;
        inherit format;
        inherit settings;
      }
    ];
  };
in {
  inherit mkConfigFile;
}
