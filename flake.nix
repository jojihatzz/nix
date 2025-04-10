{
  description = "NixOS flake configuration for joji's machine";

  inputs = {
    # Use the latest stable Nixpkgs release (NixOS 24.11)
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";

    # Use the Home Manager branch corresponding to NixOS 24.11
    home-manager.url = "github:nix-community/home-manager?ref=release-24.11";
  };

  outputs = { self, nixpkgs, home-manager, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    # NixOS configuration for the physical machine.
    nixosConfigurations.nixos = pkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/nixos/default.nix   # Host-specific hardware and base configuration.
        ./modules/base.nix            # Global system options, fonts, security settings, etc.
        ./modules/desktop/kde.nix     # KDE desktop environment configuration.
        #./modules/desktop/hyprland.nix  # (Optional) Hyprland configuration.
        ./modules/users/joji.nix      # Configuration for the 'joji' user account.
        ./modules/virtualization.nix  # Virtualization support with libvirt.
        ./modules/gaming.nix          # Gaming packages and AMD GPU tweaks.
      ];
      # Pass a reference to the flake to any nested modules that require it.
      specialArgs = { inherit self; };
    };

    # Home Manager configuration for managing the 'joji' user's personal settings.
    homeConfigurations.joji = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ ./home/joji.nix ];
    };

    # Example package export.
    packages.${system}.default = pkgs.hello;
  };
}