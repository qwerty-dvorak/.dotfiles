#!/bin/bash

# Function to check battery status and suspend if needed
monitor_battery() {
  while true; do
    # Get battery status and charge percentage
    read status charge <<< $(acpi -b | awk -F'[,:%]' '{print $2, $3}')

    # Check if the battery is discharging and below 10%
    if [[ "$status" == "Discharging" && "$charge" -lt 10 ]]; then
      echo "Battery low ($charge%). Suspending..."
      systemctl suspend
    fi

    # Wait for 60 seconds before checking again
    sleep 60
  done
}

# Run the monitoring function in the background
monitor_battery &
