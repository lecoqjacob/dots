{pkgs, ...}: let
  hms = pkgs.writeShellScriptBin "hms" ''
    ${pkgs.home-manager}/bin/home-manager switch
  '';
in {
  home.packages = with pkgs; [
    # Custom Packages
    hms

    # Nix
    alejandra
    deadnix
    nil
    statix

    # Security
    age
    bitwarden
    bitwarden-cli

    # System
    nerdfonts
    watchman

    # Shell
    atuin
    chezmoi
    direnv
    fd
    fzf
    gh
    gitFull
    lsd
    neofetch

    # Apps
    asciinema
    ion
    neovim
    tmux
    vim-full
    vivid
    vscode-fhs
  ];
}
