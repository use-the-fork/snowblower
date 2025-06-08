_: let
  mkConfigFile = {
    name,
    format,
    settings ? {},
  }: {
    files = [
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
