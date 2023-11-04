{ inputs
, lib
, config
, pkgs
, ...
}: {
  imports = [ ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "user";
    homeDirectory = "/home/user";
  };

  programs.nix-index-database.comma.enable = true;
  programs.neovim.enable = true;

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      yzhang.markdown-all-in-one
      jnoortheen.nix-ide
    ];
  };

  home.packages = with pkgs; [
    firefox
    brave
    telegram-desktop
    qbittorrent
    vlc

    ghidra

    nixd
    nixfmt

    nix-output-monitor
    nix-tree
  ];
  programs.home-manager.enable = true;

  home.stateVersion = "23.05";
}
