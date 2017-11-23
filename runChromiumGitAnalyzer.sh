#!/bin/bash

# Define pathes for this tool and Chromium source.
GIT_COUNTER_PATH=$HOME/github/Chromium-stats
CHROMIUM_PATH=$HOME/chromium-stats/chromium
export PATH=$GIT_COUNTER_PATH:$PATH

while :
do
    # Update Chromium source code.
    cd $CHROMIUM_PATH
    git pull origin master:master
    timestamp=$(date +"%T")
    echo "[$timestamp] Finish to update Chromium."

    # Start to analyze LGE commit counts.
    cd $GIT_COUNTER_PATH
    now="$(date +'%Y-%m-%d')"
    timestamp=$(date +"%T")
    echo "[$timestamp] Starting checking foo@lge.com commits from 2017-01-01 to $now, please wait..."
    gitinspector.py --format=html --since="2017-01-01" --until="$now" -T -x "email:^(?!([a-zA-Z0-9._-]+@lge.com))" $CHROMIUM_PATH > $GIT_COUNTER_PATH/index.html

    # Upload the result to github.
    git add index.html
    git commit -m "Update index.html by bot"
    git push origin master:master
    timestamp=$(date +"%T")
    echo "[$timestamp] Finish to upload new index.html!"
done
