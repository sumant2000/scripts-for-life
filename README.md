# Scripts for Life

This repository started as a small collection of battery-related scripts for macOS.

The first script here was built to help with battery monitoring and spoken alerts, and over time this repository will keep growing as new everyday automation ideas come up.

The goal of this repo is simple: keep practical personal scripts in one place so they are easy to run, improve, and reuse.

## Current Scripts

### `battery_alert.sh`

Battery monitoring script for macOS.

- Speaks an alert when battery level drops to 25% or below while on battery power
- Speaks an alert when battery reaches 100% while connected to AC power
- Uses macOS notifications, spoken audio, and system sounds

### `Pomodoro.sh`

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

## Notes

- This repository began with battery-related work
- More scripts will be added here as new ideas come up
- The current layout keeps existing scripts at the top level so already working local usage does not break

## Platform

These scripts are currently designed for macOS because they rely on built-in tools such as:

- `say`
- `osascript`
- `afplay`
- `pmset`

## Future Direction

As the repository grows, scripts can be grouped into folders such as battery, productivity, and other daily utilities.