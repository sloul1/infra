#!/bin/bash

# Load environment variables
set -a
source "$(dirname "$0")/.env"
set +a

get_confirmation() {
    while true; do
        read -p "This script will attach disks scsi1, scsi2 and scsi3 to vmid $VMID. Do you want to proceed? (y/n): " answer
        answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
        case $answer in
            y|yes) echo "User confirmed: Yes"; return 0 ;;
            n|no)  echo "User confirmed: No";  return 1 ;;
            *)     echo "Invalid input. Please enter 'y' or 'n'." ;;
        esac
    done
}

if get_confirmation; then
    echo "Attaching disks..."
    qm set "$VMID" -scsi1 "$SCSI1_DISK"
    qm set "$VMID" -scsi2 "$SCSI2_DISK"
    qm set "$VMID" -scsi3 "$SCSI3_DISK"
else
    echo "Aborting operation."
    exit 0
fi