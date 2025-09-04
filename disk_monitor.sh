#!/bin/bash

# DevOps Intern Exercise - Disk Usage Monitor
# Author: DevOps Intern Candidate
# Date: $(date +%Y-%m-%d)

# Configuration
LOG_FILE="/var/log/disk_monitor.log"
THRESHOLD=80
EMAIL_ALERT=false  # Set to true if you want email alerts

# Function to log messages with timestamp
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to check if running as root for log file access
check_permissions() {
    if [[ ! -w "$(dirname "$LOG_FILE")" ]]; then
        echo "Warning: Cannot write to $LOG_FILE, using local log file"
        LOG_FILE="./disk_monitor.log"
    fi
}

# Function to get disk usage for all mounted filesystems
get_disk_usage() {
    df -h | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{print $5 " " $6}' | while read output; do
        usage=$(echo $output | awk '{print $1}' | cut -d'%' -f1)
        partition=$(echo $output | awk '{print $2}')
        
        if [ $usage -ge $THRESHOLD ]; then
            log_message "WARNING: Disk usage on $partition is ${usage}% (Above ${THRESHOLD}% threshold)"
            
            # Show detailed disk usage for the problematic partition
            log_message "Detailed usage for $partition:"
            du -sh $partition/* 2>/dev/null | sort -hr | head -10 | while read line; do
                log_message "  $line"
            done
            
            return 1  # Return error code for high usage
        else
            log_message "INFO: Disk usage on $partition is ${usage}% (Below ${THRESHOLD}% threshold)"
        fi
    done
}

# Function to display system information
show_system_info() {
    log_message "=== System Information ==="
    log_message "Hostname: $(hostname)"
    log_message "Uptime: $(uptime)"
    log_message "Available Memory: $(free -h | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')"
    log_message "Load Average: $(cat /proc/loadavg | cut -d' ' -f1-3)"
}

# Function to cleanup old log entries (keep last 1000 lines)
cleanup_logs() {
    if [ -f "$LOG_FILE" ]; then
        tail -n 1000 "$LOG_FILE" > "${LOG_FILE}.tmp" && mv "${LOG_FILE}.tmp" "$LOG_FILE"
    fi
}

# Main execution
main() {
    echo "Starting Disk Usage Monitor..."
    
    check_permissions
    cleanup_logs
    
    log_message "=== Disk Usage Monitor Started ==="
    show_system_info
    
    log_message "=== Checking Disk Usage (Threshold: ${THRESHOLD}%) ==="
    
    # Get overall disk usage status
    if get_disk_usage; then
        log_message "SUCCESS: All partitions are below the ${THRESHOLD}% threshold"
        exit 0
    else
        log_message "ALERT: One or more partitions exceed the ${THRESHOLD}% threshold"
        
        # Additional system diagnostics for high usage
        log_message "=== Additional Diagnostics ==="
        log_message "Largest files in /tmp:"
        find /tmp -type f -exec ls -lh {} \; 2>/dev/null | sort -k5 -hr | head -5 | while read line; do
            log_message "  $line"
        done
        
        log_message "Active processes by memory usage:"
        ps aux --sort=-%mem | head -6 | while read line; do
            log_message "  $line"
        done
        
        exit 1
    fi
}

# Handle script interruption gracefully
trap 'log_message "Script interrupted by user"; exit 130' INT TERM

# Run main function
main "$@"
