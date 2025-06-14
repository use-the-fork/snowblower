{pkgs, ...}: {
  yamlFormat = pkgs.formats.yaml {};

  textFormat = {
    generate = _name: content: pkgs.writeText "dockerfile" content;
  };
}
