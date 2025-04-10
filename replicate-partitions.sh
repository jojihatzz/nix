#!/bin/sh
set -eu

# =============================================
# Script: replicate-partitions.sh
# Purpose: Interactively replicate a GPT partition layout similar
#          to your current primary disk on a user-selected disk,
#          and mount the new filesystems.
#
# Layout to create:
#   Partition 1: EFI System partition (512 MiB, FAT32)
#   Partition 2: Linux filesystem (remaining disk, ext4)
#
# Requirements: lsblk, sgdisk, parted, mkfs.fat, mkfs.ext4, mount
#
# WARNING: This script will completely erase all data on the selected disk.
# =============================================

echo "Available disks:"
lsblk -d -o NAME,SIZE,MODEL
echo ""

echo -n "Enter the full path of the target disk (e.g., /dev/sda or /dev/nvme0n1): "
read TARGET_DISK

if [ ! -b "$TARGET_DISK" ]; then
  echo "Error: $TARGET_DISK is not a valid block device."
  exit 1
fi

echo "WARNING: ALL data on ${TARGET_DISK} WILL BE ERASED."
echo -n "Type 'yes' to continue: "
read CONFIRM
if [ "$CONFIRM" != "yes" ]; then
  echo "Aborted."
  exit 1
fi

# Determine partition naming:
# If the target disk name ends with a digit (like /dev/nvme0n1), use "p" as separator.
case "$TARGET_DISK" in
  *[0-9])
    PART_SUFFIX="p"
    ;;
  *)
    PART_SUFFIX=""
    ;;
esac

echo "Replicating partition layout on ${TARGET_DISK}..."

# 1. Wipe any existing partition table
sgdisk --zap-all "$TARGET_DISK"

# 2. Create a new GPT partition table.
parted -s "$TARGET_DISK" mklabel gpt

# 3. Create EFI System Partition: from 1MiB to 513MiB.
parted -s "$TARGET_DISK" mkpart primary fat32 1MiB 513MiB
parted -s "$TARGET_DISK" set 1 esp on

# 4. Create Linux Filesystem Partition: from 513MiB to 100%.
parted -s "$TARGET_DISK" mkpart primary ext4 513MiB 100%

# Determine partition device names.
EFI_PART="${TARGET_DISK}${PART_SUFFIX}1"
ROOT_PART="${TARGET_DISK}${PART_SUFFIX}2"

echo "Formatting EFI partition $EFI_PART as FAT32..."
mkfs.fat -F32 "$EFI_PART"

echo "Formatting root partition $ROOT_PART as ext4..."
mkfs.ext4 "$ROOT_PART"

echo "Partitioning and formatting complete on $TARGET_DISK."
echo "EFI partition: $EFI_PART"
echo "Root partition: $ROOT_PART"

# -------------------------------------------------
# Step 3: Mount the New Filesystems
# -------------------------------------------------
MOUNT_POINT="/mnt"

echo "Mounting root partition $ROOT_PART to $MOUNT_POINT..."
mount "$ROOT_PART" "$MOUNT_POINT"

echo "Creating mount point and mounting EFI partition $EFI_PART to $MOUNT_POINT/boot..."
mkdir -p "$MOUNT_POINT/boot"
mount "$EFI_PART" "$MOUNT_POINT/boot"

echo "Filesystems are now mounted."
