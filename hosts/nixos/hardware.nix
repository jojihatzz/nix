{ config, lib, pkgs, modulesPath, ... }:

{
  # Import detection modules to automatically scan for hardware.
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Set up available kernel modules for the initrd.
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  swapDevices = [ ];

  # Enable DHCP on network interfaces.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  # Define the host platform.
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Update AMD CPU microcode if firmware redistribution is enabled.
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
