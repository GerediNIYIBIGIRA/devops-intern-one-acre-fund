#!/bin/bash
# Recovery script for DevOps Exercise

echo "=== DevOps Exercise Recovery Script ==="

# Function to restore from backup
restore_backup() {
    local backup_file=$1
    echo "Restoring from $backup_file..."
    tar -xzf "$backup_file" -C ./restored/
    echo "Backup restored to ./restored/"
}

# List available backups
echo "Available backups:"
find backups/ -name "*.tar.gz" | sort

echo "Usage: $0 <backup-file>"
echo "Example: $0 backups/20240101/app-backup-120000.tar.gz"

if [ $# -eq 1 ]; then
    mkdir -p restored
    restore_backup $1
fi
