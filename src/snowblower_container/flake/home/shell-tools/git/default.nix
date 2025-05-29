{config, pkgs, lib, ...}: let 

  inherit (lib) mkOption mkEnableOption types;
  inherit (lib) mkIf;

  cfg = config.snowblower.shell-tools.git;


in {
  imports = [
    ./ignore.nix
  ];

  options.snowblower.shell-tools.git = {

    userName = mkOption {
      type = types.str;
      default = "No Name";
      description = "The Git Username";
    };

    userEmail = mkOption {
      type = types.str;
      default = "do-not-reply@not-set.xyz";
      description = "Yarn package to use";
    };

  };

  config = {
    home.packages = with pkgs; [
      gh
      gist # manage github gists
      act # local github actions
      delta # pager
    ];

    programs.git = {
      enable = true;
      package = pkgs.gitFull;

      userName = cfg.userName;
      userEmail = cfg.userEmail;

      lfs = {
        enable = true;
        skipSmudge = true;
      };

      extraConfig = {
        init.defaultBranch = "main";
        credential.helper = "store";

        core.whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";

        branch.autosetupmerge = "true";
        pull.ff = "only";
        color.ui = "auto";
        repack.usedeltabaseoffset = "true";

        push = {
          default = "current";
          followTags = true;
          autoSetupRemote = true;
        };

        merge = {
          conflictstyle = "diff3";
          stat = "true";
        };

        rebase = {
          autoSquash = true;
          autoStash = true;
        };

        rerere = {
          autoupdate = true;
          enabled = true;
        };
      };
    };
  };
}
