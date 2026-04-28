# Scripts for Life

This repository started as a small collection of battery-related scripts for macOS.

The first script here was built to help with battery monitoring and spoken alerts, and over time this repository will keep growing as new everyday automation ideas come up.

The goal of this repo is simple: keep practical personal scripts in one place so they are easy to run, improve, and reuse.

## Repository Layout

```text
scripts-for-life/
├── battery/
│   └── battery_alert.sh
├── productivity/
│   ├── pomodoro.sh
│   └── stretch_reminder.sh
├── battery_alert.sh     (compatibility launcher)
└── Pomodoro.sh          (compatibility launcher)
```

Top-level launcher files are intentionally kept so existing local commands and paths continue to work.

## Current Scripts

### `battery/battery_alert.sh`

Battery monitoring script for macOS.

- Speaks an alert when battery level drops to 25% or below while on battery power
- Speaks an alert when battery reaches 100% while connected to AC power
- Uses macOS notifications, spoken audio, and system sounds

### `productivity/pomodoro.sh`

Simple Pomodoro timer for macOS.

- Starts a 25-minute focus session
- Follows with a 5-minute break
- Repeats continuously until stopped manually
- Uses macOS notifications, spoken audio, and system sounds

Commands:

```bash
pomodoro start
pomodoro stop
pomodoro status
```

To run with repo-relative path:

```bash
./productivity/pomodoro.sh start
./productivity/pomodoro.sh stop
./productivity/pomodoro.sh status
```

### `productivity/stretch_reminder.sh`

Movement/hydration reminder that runs continuously until you stop it.

- Default reminder interval: every 50 minutes
- Supports custom interval in minutes
- Uses macOS notifications, spoken audio, and system sounds

Commands:

```bash
./productivity/stretch_reminder.sh start
./productivity/stretch_reminder.sh start 45
./productivity/stretch_reminder.sh stop
./productivity/stretch_reminder.sh status
```

## Setup

### Global command for Pomodoro

If not already configured, create the global command:

```bash
ln -sf /Users/sumantkhapre/battery/Pomodoro.sh /opt/homebrew/bin/pomodoro
```

Then use:

```bash
pomodoro start
pomodoro stop
pomodoro status
```

### Battery Alert Usage

Run manually:

```bash
./battery_alert.sh
```

Or directly from organized folder:

```bash
./battery/battery_alert.sh
```

### Auto-Start Battery Alert On Login/Restart

Install or reinstall the LaunchAgent with one command:

```bash
./battery/install_battery_launchagent.sh
```

This sets up a user LaunchAgent that runs every 60 seconds and starts automatically when you log in after restart.

## Notes

- This repository began with battery-related work
- More scripts will be added here as new ideas come up
- The repository now has category folders for cleaner growth
- Compatibility launchers keep old commands working

## Platform

These scripts are currently designed for macOS because they rely on built-in tools such as:

- `say`
- `osascript`
- `afplay`
- `pmset`

## Future Direction

More utility scripts will be added over time under category folders (battery, productivity, and others) while preserving easy command usage.