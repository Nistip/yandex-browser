#!/bin/sh
set -e

mkdir -p "$HOME/.vnc"
chmod 700 "$HOME/.vnc"

if [ ! -f "$HOME/.vnc/passwd" ]; then
    x11vnc -storepasswd "${VNC_PASSWORD:-test}" "$HOME/.vnc/passwd"
    chmod 600 "$HOME/.vnc/passwd"
fi

exec "$@"