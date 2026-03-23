#!/bin/bash
# Weekly review reminder — triggered by cron every Friday at 4pm.
# Cron entry: 0 16 * * 5 /Users/iain.maitland/Code/iainmaitland88/claudia/scripts/weekly-reminder.sh

osascript -e 'display notification "cd ~/Code/iainmaitland88/claudia && claude, then /weekly" with title "Second Brain" subtitle "Weekly Review Due" sound name "Ping"'
