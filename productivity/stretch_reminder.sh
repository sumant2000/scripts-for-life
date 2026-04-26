#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PID_FILE="$SCRIPT_DIR/.stretch_reminder.pid"
LOG_FILE="$SCRIPT_DIR/.stretch_reminder.log"
DEFAULT_INTERVAL_MINUTES=50

notify_break() {
    local minutes="$1"
    osascript -e "display notification \"Take a short movement break now.\" with title \"Stretch Reminder\""
    say "Focus block of ${minutes} minutes is complete. Please stand up, stretch, and hydrate."
    afplay /System/Library/Sounds/Submarine.aiff
}

cleanup() {
    rm -f "$PID_FILE"
}

is_running() {
    if [ ! -f "$PID_FILE" ]; then
        return 1
    fi

    local pid
    pid=$(cat "$PID_FILE")

    if kill -0 "$pid" 2>/dev/null; then
        return 0
    fi

    rm -f "$PID_FILE"
    return 1
}

run_loop() {
    local interval_minutes="$1"
    local interval_seconds=$((interval_minutes * 60))

    trap 'cleanup; exit 0' INT TERM EXIT
    echo $$ > "$PID_FILE"

    osascript -e "display notification \"Stretch reminder started for every ${interval_minutes} minutes.\" with title \"Stretch Reminder\""
    say "Stretch reminder started. You will get a reminder every ${interval_minutes} minutes."

    while true; do
        sleep "$interval_seconds"
        notify_break "$interval_minutes"
    done
}

case "$1" in
    start)
        interval="${2:-$DEFAULT_INTERVAL_MINUTES}"

        if ! [[ "$interval" =~ ^[0-9]+$ ]] || [ "$interval" -le 0 ]; then
            echo "Please provide a valid positive number of minutes."
            echo "Usage: $0 start [minutes]"
            exit 1
        fi

        if is_running; then
            echo "Stretch reminder is already running."
            exit 0
        fi

        nohup "$0" run "$interval" > "$LOG_FILE" 2>&1 &
        echo $! > "$PID_FILE"
        echo "Stretch reminder started for every ${interval} minutes."
        ;;
    stop)
        if ! is_running; then
            echo "Stretch reminder is not running."
            exit 0
        fi

        kill "$(cat "$PID_FILE")" 2>/dev/null || true
        rm -f "$PID_FILE"
        osascript -e 'display notification "Stretch reminder stopped." with title "Stretch Reminder"'
        say "Stretch reminder stopped."
        echo "Stretch reminder stopped."
        ;;
    status)
        if is_running; then
            echo "Stretch reminder is running with PID $(cat "$PID_FILE")."
        else
            echo "Stretch reminder is not running."
        fi
        ;;
    run)
        run_loop "${2:-$DEFAULT_INTERVAL_MINUTES}"
        ;;
    *)
        echo "Usage: $0 {start [minutes]|stop|status}"
        exit 1
        ;;
esac