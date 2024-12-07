#!/bin/bash
 
# Step 1: Find the disk by size (e.g., 3GB)
DISK=$(lsblk -o NAME,SIZE -b | grep '3221225472' | awk '{print $1}' | head -n 1)
DISK_PATH=/dev/$DISK
 
# Step 2: Partition the disk
echo -e 'n\np\n1\n\n\nw' | sudo fdisk $DISK_PATH
 
# Step 3: Append "1" to the disk name
DISK_PATH="${DISK_PATH}1"
 
# Step 4: Format the partition
sudo mkfs.ext4 $DISK_PATH
 
# Step 5: Get the UUID of the partition
PARTITION_UUID=$(sudo blkid -s UUID -o value $DISK_PATH)
 
# Step 6: Create the mount point
sudo mkdir -p /home/adminuser/workdir
 
# Step 7: Mount the partition
sudo mount UUID=$PARTITION_UUID /home/adminuser/workdir/
 
# Step 8: Persist in /etc/fstab
echo "UUID=$PARTITION_UUID /home/adminuser/workdir/ ext4 defaults 0 0" | sudo tee -a /etc/fstab
 
# Verify the mount
df -h
 
