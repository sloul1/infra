#!/bin/bash

# Load environment variables
source "$(dirname "$0")/.env"

# Function to handle Yes/No input with validation
get_confirmation() {
    while true; do
        read -p "This script will remove disks ${SCSI1}, ${SCSI2} and ${SCSI3} from vmid ${VMID}. Do you want to proceed? (y/n): " answer

        answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

        case $answer in
            y|yes)
                echo "User confirmed: Yes"
                return 0
                ;;
            n|no)
                echo "User confirmed: No"
                return 1
                ;;
            *)
                echo "Invalid input. Please enter 'y' or 'n'."
                ;;
        esac
    done
}

if get_confirmation; then
    echo "Removing disks..."
    qm set "$VMID" --delete "$SCSI1"
    qm set "$VMID" --delete "$SCSI2"
    qm set "$VMID" --delete "$SCSI3"
else
    echo "Aborting operation."
    exit 0
fi