_: let 
shellAliases = {
    hm = "home-manager";
};
in {
  programs.zsh.shellAliases = shellAliases;
  programs.bash.shellAliases = shellAliases;
}
