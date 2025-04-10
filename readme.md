# Automated NixOS Flake Installation

This repository contains a flake-based NixOS configuration along with two helper scripts to automate the installation process. In particular, the installation process includes:

- **Interactive Partitioning and Mounting:**  
  The `replicate-partitions.sh` script lists available disks, lets you select a target disk, wipes and partitions it (creating a 512 MiB EFI partition and a Linux filesystem partition), formats both partitions, and mounts them.

- **Automated Installation:**  
  The `automated-install.sh` script verifies network connectivity, calls the partitioning script, clones the flake repository to the newly mounted filesystem, and runs `nixos-install` using the flake configuration.

- **Experimental Features Enabled:**  
  The configuration in `modules/base.nix` enables the experimental features for the new `nix` command and flakes:
  
  ```nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

Repository Structure

flake/
├── automated-install.sh
├── flake.nix
├── home
│   ├── files
│   │   ├── hyprland.conf
│   │   └── vscode-settings.json
│   └── joji.nix
├── hosts
│   └── nixos
│       ├── default.nix
│       └── hardware.nix
├── modules
│   ├── base.nix                # Global system settings (includes experimental features)
│   ├── desktop
│   │   ├── hyprland.nix
│   │   └── kde.nix
│   ├── gaming.nix
│   ├── users
│   │   └── joji.nix
│   └── virtualization.nix
└── replicate-partitions.sh     # Script for partitioning and mounting

Installation Process

    Boot the Minimal NixOS Installer:
    Boot into the NixOS minimal installer and ensure you have a working network connection.

    Run the Automated Installation Script:
    In your live session, navigate to the repository root and make the scripts executable (if not already):

chmod +x replicate-partitions.sh automated-install.sh

Then run the automated installation script:

    ./automated-install.sh

    Follow Prompts:
    The script will list available disks—select your target disk by entering its full path (e.g., /dev/nvme0n1 for your primary 1TB disk). Confirm any warnings about erasing all data on the disk.

    Installation Completion:
    The script will partition and format the disk, mount the filesystems, clone your flake repository, run nixos-install with the flake configuration, and finally reboot into your new NixOS installation.

Important Notes

    Data Destruction:
    Both scripts are destructive—ensure you back up any important data before running them.

    Device Names:
    The scripts automatically detect whether the target disk requires a "p" separator (common on NVMe devices) for partition names.

    Configuration Adjustments:
    Make sure to update the FLAKE_REPO_URL in automated-install.sh to point to your actual flake repository.

    Experimental Features:
    Your NixOS configuration enables the experimental features nix-command and flakes. This allows you to use commands like nix flake and benefit from flake-based workflows.

License

[Specify your license here, e.g. MIT License.]

Happy installing!