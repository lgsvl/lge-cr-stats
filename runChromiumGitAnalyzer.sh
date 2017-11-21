#!/bin/sh

# Define pathes for this tool and Chromium source.
GIT_COUNTER_PATH=$HOME/github/Chromium-stats
CHROMIUM_PATH=$HOME/chromium-stats/chromium

# Update Chromium source code.
cd "$CHROMIUM_PATH"
git pull
echo "Finish to update Chromium."

# Start to analyze LGE commit counts.
now="$(date +'%Y-%m-%d')"
echo "Starting checking foo@lge.com commits from 2017-01-01 to $now, please wait..."
gitinspector --format=html --since="2017-01-01" --until="$now" -T -x "email:^(?!([a-zA-Z0-9._-]+@lge.com))" $CHROMIUM_PATH > $GIT_COUNTER_PATH/index.html

# Upload the result to github.
cd "$GIT_COUNTER_PATH"
git add index.html
git commit -m "Update index.html by bot"
git push origin master:master

