#!/bin/bash

if [ -z "$1" ]
    then
        echo "No email domain."
        echo "Usage : ./runChromiumGitAnalyzer.sh [email domain] (i.e. ./runChromiumGitAnalyzer.sh lge.com, igalia.com)"
        exit 1
fi

# Define pathes for this tool and Chromium source.
GIT_COUNTER_PATH=$HOME/github/LGE-Chromium-Stats/lge-chromium-contribution-stats
GIT_INSPECTOR_PATH=$HOME/github/LGE-Chromium-Stats/gitinspector-for-lge-chromium-stats
CHROMIUM_PATH=$HOME/chromium-stats/chromium/src
INDEX_ORG_PATH=$HOME/chromium-stats/log
START_DATE="2017-01-01"

export PATH=$GIT_INSPECTOR_PATH:$PATH

while :
do
    # Update Chromium source code.
    timestamp=$(date +"%T")
    echo "[$timestamp] Start updating  Chromium trunk, please wait..."
    cd $CHROMIUM_PATH
    git pull origin master:master
    git gc --auto
    timestamp=$(date +"%T")
    echo "[$timestamp] Finish to update Chromium."

    # Start to analyze commit counts.
    now="$(date +'%Y-%m-%d')"
    timestamp=$(date +"%T")
    echo "[$timestamp] Starting checking foo@$1 commits from $START_DATE to $now, please wait..."
    gitinspector.py --format=html --file-types=** --hard=false --since="$START_DATE" --until="$now" -T -x "email:^(?!([a-zA-Z0-9._-]+@$1))" $CHROMIUM_PATH > $INDEX_ORG_PATH/index-tmp.html
    cp $INDEX_ORG_PATH/index-tmp.html $GIT_COUNTER_PATH/index.html

    # Upload the result to github.
    cd $GIT_COUNTER_PATH
    git add index.html
    git commit -m "Update index.html by bot"
    git fetch origin master
    git rebase origin/master
    git push origin master:master
    timestamp=$(date +"%T")
    echo "[$timestamp] Finish to upload new index.html!\n"
    timestamp=$(date +"%T")
#    sleep 8h
done
