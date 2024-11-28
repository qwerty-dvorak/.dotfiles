#!/usr/bin/env bash

# Take screenshots with optional region selection and window opacity adjustment using picom

# Function to display help and exit
function help_and_exit {
    if [ -n "${1}" ]; then
        echo "${1}"
    fi
    cat <<-EOF
    Usage: scregcp [-h|-s] [<screenshots_base_folder>]

    Take a screenshot of a whole screen or a specified region,
    save it to a specified folder (~/Pictures/Screenshots is default)
    and copy it to the clipboard. 

       -h   - print help and exit
       -s   - take a screenshot of a screen region
EOF
    if [ -n "${1}" ]; then
        exit 1
    fi
    exit 0
}

# Function to set window opacity
function set_opacity {
    case "$1" in
        max)
            for wid in $(xdotool search --onlyvisible --name '.*'); do
                xprop -id "$wid" -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY 0xffffffff
            done
            ;;
        reset)
            for wid in $(xdotool search --onlyvisible --name '.*'); do
                xprop -id "$wid" -remove _NET_WM_WINDOW_OPACITY
            done
            ;;
        *)
            echo "Invalid option for set_opacity function"
            ;;
    esac
}

# Default screenshot folder
default_folder="${HOME}/Pictures/Screenshots"

# Parse options and arguments
if [ "${1}" == '-h' ]; then
    help_and_exit
elif [ "${1:0:1}" == '-' ]; then
    if [ "${1}" != '-s' ]; then
        help_and_exit "error: unknown option ${1}"  
    fi
    base_folder="${2:-$default_folder}"
    params="region"  # Use region capture with maim
else
    base_folder="${1:-$default_folder}"
    params="full"  # Full-screen capture
fi  

# Ensure the base folder exists
mkdir -p "${base_folder}"

# Set window opacity to maximum
set_opacity max

# Optional: Reload picom to ensure it applies changes
if command -v pkill &> /dev/null; then
   pkill -USR1 picom  # Sends a signal to reload picom (if supported)
fi

# Generate file path and take screenshot
file_path="${base_folder}/$(date '+%Y-%m-%d_%H-%M-%S')_screenshot.png"

# Take screenshot based on the specified mode
if [ "${params}" == "region" ]; then
    # Region-based screenshot using slop for interactive selection
    maim -s "${file_path}"
else
    # Full-screen screenshot
    maim "${file_path}"
fi

# Check if screenshot was taken successfully
if [ $? -eq 0 ]; then
    echo "Screenshot saved to: ${file_path}"
else
    echo "Failed to take screenshot."
    set_opacity reset
    exit 1
fi

# Copy screenshot to clipboard
if command -v xclip &> /dev/null; then
    xclip -selection clipboard -target image/png -i < "${file_path}"
fi

# Add a small delay to ensure the screenshot process completes before resetting opacity
sleep 0.5

# Reset window opacity
set_opacity reset
