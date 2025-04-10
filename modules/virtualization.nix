{ config, pkgs, ... }:

{
  # Enable Libvirt to manage virtual machines.
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.managed = true;

  # Install packages required for virtualization.
  environment.systemPackages = with pkgs; [
    qemu         # Emulator for virtual machines.
    virt-manager # Graphical management tool for VMs.
  ];

  # Note: The kvm-amd module is already loaded via hardware.nix.
  # boot.kernelModules = [ "kvm-amd" ];
}
