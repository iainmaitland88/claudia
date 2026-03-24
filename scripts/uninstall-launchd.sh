#!/bin/bash
# Uninstall claudia launchd agents.

set -euo pipefail

AGENTS_DIR="$HOME/Library/LaunchAgents"
CHECKIN_LABEL="com.claudia.checkin-reminder"
WEEKLY_LABEL="com.claudia.weekly-reminder"

launchctl bootout "gui/$(id -u)/$CHECKIN_LABEL" 2>/dev/null || true
launchctl bootout "gui/$(id -u)/$WEEKLY_LABEL" 2>/dev/null || true

rm -f "$AGENTS_DIR/$CHECKIN_LABEL.plist"
rm -f "$AGENTS_DIR/$WEEKLY_LABEL.plist"

echo "Uninstalled claudia launchd agents."
