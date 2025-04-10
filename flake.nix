{
  # A flake to configure both NixOS and Home Manager for joji's machine.
  description = "NixOS flake configuration for joji's machine";

  inputs = {
    # Use the stable release of nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs?ref=stable";

    # Use the release channel of home-manager.
    home-manager.url = "github:nix-community/home-manager?ref=release";
  };

  outputs = { self, nixpkgs, home-manager }: let
    # Define the target system architecture.
    system = "x86_64-linux";

    # Import the package set from nixpkgs for the specified system.
    pkgs = import nixpkgs { inherit system; };
  in {
    # NixOS configuration for the physical machine.
    nixosConfigurations.nixos = pkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/nixos/default.nix   # Host-specific hardware and base configuration.
        ./modules/base.nix            # Global system options, fonts, and security settings.
        ./modules/desktop/kde.nix     # KDE desktop environment configuration.
        #./modules/desktop/hyprland.nix     # Hyprland configuration.
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

    # Example package export; here exposing the hello package.
    packages.${system}.default = pkgs.hello;
  };
}
