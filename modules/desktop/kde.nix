{ config, pkgs, ... }:

{
  # Enable the X server, display manager, and KDE Plasma 6.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Install KDE-specific applications and the Whitesur Dark theme package,
  # which provides both the color scheme and the icon theme.
  environment.systemPackages = with pkgs; [
    kdeApplications.konsole
    kdeApplications.kate
    kdeApplications.kdeplasma-addons
    whitesur-dark-kde  # Package providing Whitesur Dark theme and icons
  ];
}
