#!/bin/bash

SOURCE_PATH="${BASH_SOURCE[0]}"
while [ -L "$SOURCE_PATH" ]; do
    SOURCE_DIR=$(cd "$(dirname "$SOURCE_PATH")" && pwd)
    SOURCE_PATH=$(readlink "$SOURCE_PATH")
    [[ "$SOURCE_PATH" != /* ]] && SOURCE_PATH="$SOURCE_DIR/$SOURCE_PATH"
done

SCRIPT_DIR=$(cd "$(dirname "$SOURCE_PATH")" && pwd)
exec "$SCRIPT_DIR/battery/battery_alert.sh" "$@"
