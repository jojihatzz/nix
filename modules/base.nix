{ config, pkgs, ... }:

{
  # Allow installation of proprietary (non-free) packages across the system.
  nixpkgs.config.allowUnfree = true;

  # Enable Wayland support for Electron applications such as VS Code.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Define primary fonts used by the system.
  fonts.fonts = with pkgs; [
    noto-fonts
    liberationFonts
  ];

  # Configure security: disable sandboxing for untrusted apps if needed.
  security.sandbox.allowAll = false;

  # Enable experimental features for the new nix command and flakes.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
