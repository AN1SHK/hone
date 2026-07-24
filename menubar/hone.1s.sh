#!/bin/bash
#
# <xbar.title>HONE Timer</xbar.title>
# <xbar.version>1.0</xbar.version>
# <xbar.author>HONE</xbar.author>
# <xbar.desc>Shows the running HONE deep-work block countdown in the macOS menu bar.</xbar.desc>
# <xbar.dependencies>bash,curl</xbar.dependencies>
#
# SwiftBar / xbar plugin.
# The ".1s." in the filename means "refresh every 1 second" — keep it.
# HONE writes the active block (end time + task) to this Firebase node when a
# block starts, and clears it when the block ends. This script just reads it.

URL="https://my-schedule-a0ded-default-rtdb.firebaseio.com/hone_timer.json"
DATA=$(curl -s -m 2 "$URL" 2>/dev/null)

# No block running (node empty or null) -> quiet idle dot
if [ -z "$DATA" ] || [ "$DATA" = "null" ]; then
  echo "◌"
  echo "---"
  echo "HONE — no block running"
  echo "Open HONE | href=https://an1shk.github.io/hone/"
  exit 0
fi

END=$(printf '%s' "$DATA"  | grep -oE '"end":[0-9]+' | grep -oE '[0-9]+')
TASK=$(printf '%s' "$DATA" | sed -nE 's/.*"task":"([^"]*)".*/\1/p')

if [ -z "$END" ]; then
  echo "◌"; echo "---"; echo "HONE"; exit 0
fi

NOW=$(date +%s)
REM=$(( END / 1000 - NOW ))

# Expired but not yet cleared -> treat as idle
if [ "$REM" -le 0 ]; then
  echo "◌"
  echo "---"
  echo "HONE — no block running"
  echo "Open HONE | href=https://an1shk.github.io/hone/"
  exit 0
fi

M=$(( REM / 60 ))
S=$(( REM % 60 ))

# Menu-bar line (no forced color, so it stays readable in light & dark menu bars)
printf "● %d:%02d | font='SF Mono' size=13\n" "$M" "$S"
echo "---"
[ -n "$TASK" ] && echo "$TASK | color=#8b9098"
echo "Deep-work block running"
echo "Open HONE | href=https://an1shk.github.io/hone/"
