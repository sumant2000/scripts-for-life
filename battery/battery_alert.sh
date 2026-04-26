#!/bin/bash

# Get battery percentage
BATT_LEVEL=$(pmset -g batt | grep -Eo "[0-9]+%" | cut -d% -f1)

# Check if charging (AC Power vs Battery Power)
CHARGING_STATUS=$(pmset -g batt | grep -o "AC Power\|Battery Power")

# Exit early if battery info couldn't be read
if [ -z "$BATT_LEVEL" ] || [ -z "$CHARGING_STATUS" ]; then
    exit 0
fi

# Trigger alert if level <= 25 and not charging
if [ "$BATT_LEVEL" -le 25 ] && [ "$CHARGING_STATUS" = "Battery Power" ]; then
    # Visual notification
    osascript -e "display notification \"Battery at ${BATT_LEVEL}%. Plug in now!\" with title \"Low Battery Alert\""

    # Audio alert (spoken)
    say "Warning: Battery is at ${BATT_LEVEL} percent. Please connect your charger."

    # System sound
    afplay /System/Library/Sounds/Ping.aiff
fi

# Trigger alert if level is 100 and charger is connected
if [ "$BATT_LEVEL" -eq 100 ] && [ "$CHARGING_STATUS" = "AC Power" ]; then
    # Visual notification
    osascript -e "display notification \"Battery is fully charged. You can remove the charger now.\" with title \"Battery Full Alert\""

    # Audio alert (spoken)
    say "The battery is 100 percent charged now. Please remove the wire connected for charging."

    # System sound
    afplay /System/Library/Sounds/Glass.aiff
fi
