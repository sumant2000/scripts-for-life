#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PID_FILE="$SCRIPT_DIR/.pomodoro.pid"
LOG_FILE="$SCRIPT_DIR/.pomodoro.log"
WORK_MINUTES=25
BREAK_MINUTES=5
WORK_SECONDS=$((WORK_MINUTES * 60))
BREAK_SECONDS=$((BREAK_MINUTES * 60))

notify() {
    local title="$1"
    local message="$2"
    local speech="$3"
    local sound="$4"

    osascript -e "display notification \"${message}\" with title \"${title}\""
    say "$speech"
    afplay "$sound"
}

cleanup() {
    rm -f "$PID_FILE"
}

stop_running_session() {
    local pid
    pid=$(cat "$PID_FILE")

    kill "$pid" 2>/dev/null || true
    rm -f "$PID_FILE"

    osascript -e 'display notification "Pomodoro timer stopped." with title "Pomodoro"'
    say "Pomodoro timer stopped."
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
    trap 'cleanup; exit 0' INT TERM EXIT
    echo $$ > "$PID_FILE"

    while true; do
        notify \
            "Pomodoro" \
            "Pomodoro session started for ${WORK_MINUTES} minutes." \
            "Pomodoro session started for ${WORK_MINUTES} minutes. I will focus on ${WORK_MINUTES} minutes." \
            "/System/Library/Sounds/Glass.aiff"

        sleep "$WORK_SECONDS"

        notify \
            "Pomodoro Break" \
            "The Pomodoro session is over. Now ${BREAK_MINUTES} minutes of break time started." \
            "The Pomodoro session is over. Now ${BREAK_MINUTES} minutes of break time started." \
            "/System/Library/Sounds/Ping.aiff"

        sleep "$BREAK_SECONDS"

        notify \
            "Pomodoro" \
            "${BREAK_MINUTES} minutes session is over. Starting the next Pomodoro." \
            "${BREAK_MINUTES} minutes session is over. Starting the next Pomodoro session for ${WORK_MINUTES} minutes." \
            "/System/Library/Sounds/Glass.aiff"
    done
}

case "$1" in
    start)
        if is_running; then
            echo "Pomodoro is already running."
            exit 0
        fi

        nohup "$0" run > "$LOG_FILE" 2>&1 &
        echo $! > "$PID_FILE"
        echo "Pomodoro started."
        ;;
    stop)
        if ! is_running; then
            echo "Pomodoro is not running."
            exit 0
        fi

        stop_running_session
        echo "Pomodoro stopped."
        ;;
    status)
        if is_running; then
            echo "Pomodoro is running with PID $(cat "$PID_FILE")."
        else
            echo "Pomodoro is not running."
        fi
        ;;
    run)
        run_loop
        ;;
    *)
        echo "Usage: $0 {start|stop|status}"
        exit 1
        ;;
esac