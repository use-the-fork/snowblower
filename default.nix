# A pure Nix library that handles the treefmt configuration.
let
  # The base module configuration that generates and wraps the treefmt config
  # with Nix.
  module-options = ./module-options.nix;

  # Program to formatter mapping
  programs = import ./modules;

  all-modules = nixpkgs: [
    {
      _module.args = {
        pkgs = nixpkgs;
        lib = nixpkgs.lib;
      };
    }
    module-options
  ] ++ programs.modules;

  # treefmt-nix can be loaded into a submodule. In this case we get our `pkgs` from
  # our own standard option `pkgs`; not externally.
  submodule-modules = [
    ({ config, lib, ... }:
      let
        inherit (lib)
          mkOption
          types;
      in
      {
        options.pkgs = mkOption {
          type = types.uniq (types.lazyAttrsOf (types.raw or types.unspecified));
          description = ''
            Nixpkgs to use.
          '';
        };
        config._module.args = {
          pkgs = config.pkgs;
        };
      })
    module-options
  ] ++ programs.modules;

  # Use the Nix module system to validate the treefmt config file format.
  #
  # nixpkgs is an instance of <nixpkgs> that contains treefmt.
  # configuration is an attrset used to configure the nix module
  evalModule = nixpkgs: inputs: configuration:
    nixpkgs.lib.evalModules {
      specialArgs = {
        inherit inputs;
      };
      modules = all-modules nixpkgs ++ [ configuration ];
    };
in
{
  inherit
    module-options
    programs
    all-modules
    submodule-modules
    evalModule
    ;
}
