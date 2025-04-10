#!/bin/sh
set -eu

LOGFILE="/tmp/nixos-install.log"
# Redirect output to log file and console
exec > >(tee -a "$LOGFILE") 2>&1

echo "===== Starting Automated NixOS Installation ====="
date

echo "Step 1: Checking network connectivity..."
if ! ping -c 1 google.com >/dev/null 2>&1; then
  echo "Network connectivity test failed. Please ensure you are connected to the internet."
  exit 1
fi
echo "Network connectivity is OK."

echo "Step 2: Partitioning and mounting target disk..."
# Call the partitioning script, which will interactively prompt the user.
./replicate-partitions.sh

# -------------------------------------------------
# (At this point replicate-partitions.sh should have mounted the partitions.)
# For further steps, ask the user to re-enter the target disk to compute partition names.
echo -n "Re-enter the target disk used (e.g., /dev/sda or /dev/nvme0n1): "
read TARGET_DISK

case "$TARGET_DISK" in
  *[0-9])
    PART_SUFFIX="p"
    ;;
  *)
    PART_SUFFIX=""
    ;;
esac

EFI_PART="${TARGET_DISK}${PART_SUFFIX}1"
ROOT_PART="${TARGET_DISK}${PART_SUFFIX}2"
MOUNT_POINT="/mnt"

echo "Using root partition: $ROOT_PART and EFI partition: $EFI_PART."

echo "Step 3: Cloning the flake repository..."
# Change FLAKE_REPO_URL below to your flake repository URL.
FLAKE_REPO_URL="https://your.repo.url/flake.git"
git clone "$FLAKE_REPO_URL" "$MOUNT_POINT/flake"

echo "Step 4: Running nixos-install with flake configuration..."
# This command assumes your flake defines a NixOS system under the '#nixos' output.
nixos-install --flake "$MOUNT_POINT/flake#nixos"

echo "Step 5: Unmounting filesystems..."
umount -R "$MOUNT_POINT"

echo "Installation complete. Rebooting..."
reboot
