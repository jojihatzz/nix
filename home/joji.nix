{ config, pkgs, ... }:

{
  home.username = "joji";
  home.homeDirectory = "/home/joji";

  # Enable Zsh and Git for the user.
  programs.zsh.enable = true;
  programs.git.enable = true;

  # Link the customized VS Code settings.
  xdg.configFile."/home/joji/.config/Code/User/settings.json".source = ./files/vscode-settings.json;

  # Configure KDE global settings to use the Whitesur Dark color scheme
  # and select Whitesur Dark as the icon theme.
  xdg.configFile."kdeglobals".text = ''
    [General]
    colorScheme=Whitesur-Dark

    [Icons]
    Theme=Whitesur-Dark
  '';

  # Configure KDE mouse settings for speed and pointer acceleration.
  xdg.configFile."kcminputrc".text = ''
    [Mouse]
    cursorSpeed=0.40
    cursorAcceleration=0
  '';
}
