#!/bin/bash
# Daily check-in reminder — triggered by cron weekdays at 5pm.
# Cron entry: 0 17 * * 1-5 /Users/iain.maitland/Code/iainmaitland88/claudia/scripts/checkin-reminder.sh

osascript -e 'display notification "cd ~/Code/iainmaitland88/claudia && claude, then /checkin" with title "Second Brain" subtitle "End-of-Day Check-in" sound name "Ping"'
