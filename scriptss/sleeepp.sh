#!/bin/bash

export DISPLAY=:0
export XAUTHORITY=/home/afish/.Xauthority

# Constants
IDLE_THRESHOLD=${IDLE_THRESHOLD:-$((30 * 60 * 1000))}  # Idle threshold in milliseconds (default: 30 minutes)
LOCKFILE="$HOME/tmp/idle_shutdown.lock"              # Lock file to prevent multiple instances
PAUSEFILE="$HOME/tmp/idle_pause.flag"                      # Pause flag file
LOGFILE="$HOME/idle_shutdown.log"                    # Log file for activity
DEBUG_MODE=true                                      # Enable debug messages (set to false to disable)

rm "$LOGFILE"
touch "$LOGFILE"

rm "$PAUSEFILE"

# Function to log messages
log_message() {
    local message="$1"
    echo "$(date): $message" >> "$LOGFILE"
}


# Debugging function for additional information
debug_message() {
    if [ "$DEBUG_MODE" = true ]; then
        log_message "[DEBUG] $1"
    fi
}

# Check if required commands are available
if ! command -v xprintidle >/dev/null; then
    log_message "ERROR: xprintidle is not installed. Exiting."
    exit 1
fi

if ! command -v shutdown >/dev/null; then
    log_message "ERROR: shutdown command is not available. Exiting."
    exit 1
fi

# Prevent multiple instances of the script
if [ -e "$LOCKFILE" ]; then
    if ps -p "$(cat $LOCKFILE)" > /dev/null 2>&1; then
        log_message "ERROR: Script is already running. Exiting."
        exit 1
    else
        log_message "WARNING: Stale lock file found. Removing..."
        rm -f "$LOCKFILE"
    fi
fi

# Create lock file with current PID
echo $$ > "$LOCKFILE"


# Create lock file and ensure it is removed on exit
trap "rm -f $LOCKFILE" EXIT
touch "$LOCKFILE"

# Log environment information
debug_message "Environment Variables: DISPLAY=$DISPLAY"
debug_message "Script PID: $$"
debug_message "User: $(whoami)"

# Main loop
log_message "Idle shutdown script started. Threshold: $((IDLE_THRESHOLD / 60000)) minutes."

while true; do

    if [ -e "$PAUSEFILE" ]; then
        log_message "Script is paused. Waiting for unpause..."
        while [ -e "$PAUSEFILE" ]; do
            sleep 30
        done
        log_message "Script unpaused. Resuming operations."
    fi

    # Get the current idle time
    idle=$(xprintidle 2>/dev/null)
    debug_message "Idle threshold (seconds): $((IDLE_THRESHOLD / 1000))"
    debug_message "Idle time in seconds: $idle_seconds"
    debug_message "Raw idle time from xprintidle: $idle"

    # Validate idle value
    if ! [[ "$idle" =~ ^[0-9]+$ ]]; then
        log_message "WARNING: xprintidle returned invalid value: $idle. Retrying..."
        sleep 1
        continue
    fi

    # Convert idle time to seconds with two decimal places
    idle_seconds=$(awk "BEGIN { printf \"%.2f\", $idle / 1000 }")

    # Log current idle time in seconds
    debug_message "Validated idle time: $idle_seconds seconds"

    # Check if idle time exceeds the threshold
    
    idle_milliseconds=$(( ${idle%.*} ))

    # Compare idle time in milliseconds directly to threshold
    if [ "$idle_milliseconds" -ge "$IDLE_THRESHOLD" ]; then
        log_message "Idle time exceeded threshold. Initiating shutdown..."
        shutdown -h now
        exit 0
    fi

    # Wait for 60 seconds before checking again
    sleep 60
done

