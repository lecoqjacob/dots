{
  imports = [
    ./apps
    ./programs
    ];

  home = {
    stateVersion = "23.11";
    username = "n16hth4wk";
    homeDirectory = "/home/n16hth4wk";

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs.home-manager.enable = true;
}
