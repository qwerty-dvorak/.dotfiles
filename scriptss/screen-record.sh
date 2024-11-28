#!/bin/bash

# Set up recordings directory
RECORDINGS_DIR="$HOME/Videos/ScreenRecordings"
mkdir -p "$RECORDINGS_DIR"

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Debug function
debug_info() {
    echo -e "${BLUE}=== Debug Information ===${NC}"
    echo "FFmpeg version: $(ffmpeg -version | head -n1)"
    echo "Display resolution: $(xdpyinfo | awk '/dimensions:/ {print $2}')"
    echo "Available PulseAudio sources:"
    pactl list sources short
    echo "Available PulseAudio sinks:"
    pactl list sinks short
}

# Help message
show_help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h    Show this help"
    echo "  -d    Show debug info"
    echo "  -sm   Silent mode (no audio)"
    echo "  -mm   Mixed mode (speaker + mic)"
    echo
    echo "Default: Records with speaker audio only"
}

# Function to get output filename
get_output_filename() {
    echo "${RECORDINGS_DIR}/$(date '+%Y-%m-%d_%H-%M-%S')_recording.mp4"
}

# Function to record screen
record_screen() {
    local mode=$1
    local output_file=$(get_output_filename)
    local resolution=$(xdpyinfo | awk '/dimensions:/ {print $2}')
    
    echo -e "\n${GREEN}Recording started${NC}"
    echo -e "${RED}Press Ctrl+C to stop${NC}"
    
    case $mode in
        "speaker-only")
            ffmpeg -f x11grab -r 30 -s "$resolution" -i :0.0 \
                   -f pulse -i $(pactl get-default-sink).monitor \
                   -c:v libx264 -preset ultrafast -crf 18 \
                   -c:a aac -b:a 192k \
                   "$output_file"
            ;;
        "silent")
            ffmpeg -f x11grab -r 30 -s "$resolution" -i :0.0 \
                   -c:v libx264 -preset ultrafast -crf 18 \
                   "$output_file"
            ;;
        "mixed")
            ffmpeg -f pulse -i $(pactl get-default-sink).monitor \
                   -f pulse -i $(pactl get-default-source) \
                   -f x11grab -r 30 -s "$resolution" -i :0.0 \
                   -filter_complex amix=inputs=2:duration=longest \
                   -c:v libx264 -preset ultrafast -crf 18 \
                   -c:a aac -b:a 192k \
                   "$output_file"
            ;;
    esac
    
    echo -e "\n${GREEN}Recording saved:${NC} $output_file"
}

# Main script
main() {
    # Check for ffmpeg
    if ! command -v ffmpeg &> /dev/null; then
        echo -e "${RED}Error: ffmpeg not installed${NC}"
        echo "Install with: sudo pacman -S ffmpeg"
        exit 1
    fi

    case "$1" in
        -h)
            show_help
            ;;
        -d)
            debug_info
            ;;
        -sm)
            record_screen "silent"
            ;;
        -mm)
            record_screen "mixed"
            ;;
        *)
            record_screen "speaker-only"
            ;;
    esac
}

main "$@"
