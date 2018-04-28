#!/bin/bash

# Define pathes for this tool and Chromium source.
CHROMIUM_PATH=$HOME/chromium/Chromium
OUTPUT_PATH=$HOME/chromium-stats-tool/lge-cr-stats
GIT_STATS_PATH=$HOME/chromium-stats-tool/lge_git_stats/bin/git_stats

export LGE_EMAIL="@lge.com"

while :
do
    # Update Chromium source code.
    start_timestamp=$(date +"%T")
    timestamp=$start_timestamp
    echo "[$timestamp] Start updating  Chromium trunk, please wait..."
    cd $CHROMIUM_PATH
    git pull origin master:master
    git subtree add --prefix=v8-log https://chromium.googlesource.com/v8/v8.git master
    git subtree add --prefix=pdfium-log https://pdfium.googlesource.com/pdfium master
    git subtree add --prefix=angle-log https://chromium.googlesource.com/angle/angle.git master
    timestamp=$(date +"%T")
    echo "[$timestamp] Finish to update Chromium."

    # Start to analyze commit counts.
    now="$(date +'%Y-%m-%d')"
    timestamp=$(date +"%T")
    echo "[$timestamp] Starting checking LGE commits until $now, please wait..."
    git filter-branch -f --commit-filter '
        if echo "$GIT_AUTHOR_EMAIL" | grep -q "$LGE_EMAIL";
        then
            git commit-tree "$@";
        else
            skip_commit "$@";
        fi' HEAD

    timestamp=$(date +"%T")
    echo "[$timestamp] Finish to find LGE commits."

    $GIT_STATS_PATH generate -p $CHROMIUM_PATH -o $OUTPUT_PATH

    # Restore master branch
    git reset --hard refs/original/refs/heads/master
    git reset --hard HEAD~6

    # Upload the result to github.
    cd $OUTPUT_PATH
    git add .
    git commit -m "Update the new result by bot"
    git fetch origin master
    git rebase origin/master
    git push origin master:master

    timestamp=$(date +"%T")
    echo "[$timestamp] Finish to upload new result!"
    echo "- StartTime: $start_timestamp"
    echo "- EndTime: $timestamp"
done
