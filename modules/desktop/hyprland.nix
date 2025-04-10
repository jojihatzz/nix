{ config, pkgs, ... }:

{
  # Enable the X server to support XWayland applications in a Wayland session.
  services.xserver = {
    enable = true;
    layout = "us";
    # Disable launching a default xterm session.
    desktopManager.xterm.enable = false;
  };

  # Install Hyprland and accompanying packages.
  environment.systemPackages = with pkgs; [
    hyprland      # Hyprland compositor.
    waybar        # Status bar for Wayland.
    hyprpaper     # Wallpaper manager for Hyprland.
    kitty         # Terminal emulator.
  ];


  # Hyprland configuration deployment
  xdg.configFile."hypr/hyprland.conf".source = ./files/hyprland.conf;

  # Add further Hyprland-specific configuration settings as needed.
}
