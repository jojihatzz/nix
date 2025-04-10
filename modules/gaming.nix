{ config, pkgs, ... }:

{
  # Install gaming packages optimized for Wayland.
  environment.systemPackages = with pkgs; [
    steam          # Steam client with Proton for Wayland support.
    lutris         # Game launcher and library manager.
    openrgb        # RGB hardware control utility.
    vulkan-loader  # Vulkan API loader.
    vulkan-tools   # Vulkan diagnostic tools.
    mesa-demos     # OpenGL demo applications.
  ];

  # Enable full AMD GPU support (both 64-bit and 32-bit).
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  # Legacy applications may fall back to XWayland automatically.
}
