{ config, pkgs, ... }:

{
  # Create and configure the user "joji".
  users.users.joji = {
    isNormalUser = true;
    # Replace the hash below with one generated for your password.
    password = "$6$I96JFDnZtlyBtgiD$kUYDT4aUcS9eXEK4WTYB4s0QwPmkPyD4jjZGArtUkm2g2uJQBAinPVS86FxPPXENrT25TycGFUlDsF8vLvFjm.";
    # Grant membership to wheel (for sudo) and libvirt (for managing virtual machines).
    extraGroups = [ "wheel" "libvirt" ];
  };

  # (Optional) Configure SSH key authentication.
  # users.users.joji.openssh.authorizedKeys.keyFiles = [ /path/to/your/key.pub ];
}
