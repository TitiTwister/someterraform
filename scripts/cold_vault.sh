#! /bin/bash
dnf install epel-release -y
hostnamectl set-hostname home-eu-cold-vault

# Setup and mount the data volume
DATA_DEVICE="/dev/xvdb"
MOUNT_POINT="/srv/notusbkey"

# Wait for the volume to be attached
while [ ! -b "$DATA_DEVICE" ]; do
  echo "Waiting for $DATA_DEVICE to be available..."
  sleep 5
done

# Create filesystem if not already formatted
if ! blkid "$DATA_DEVICE" > /dev/null 2>&1; then
  echo "Creating xfs filesystem on $DATA_DEVICE"
  mkfs.xfs "$DATA_DEVICE"
fi

# Create mount point
mkdir -p "$MOUNT_POINT"

# Add to /etc/fstab if not already present
if ! grep -q "$DATA_DEVICE" /etc/fstab; then
  echo "$DATA_DEVICE $MOUNT_POINT xfs defaults,noatime 0 0" >> /etc/fstab
fi

# Mount the volume
mount "$MOUNT_POINT"

# Set proper permissions
chmod 755 "$MOUNT_POINT"
