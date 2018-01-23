# Chromium-stats
This tool is to generate a result to track LGE Chromium contribution

# Instruction
## Install git_stats tool first.
```sh
$ sudo apt-get install ruby
$ sudo gem install git_stats
```

## Checkout Chromium
```sh
$ git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
$ export PATH="$PATH:/path/to/depot_tools"
$ mkdir ~/chromium && cd ~/chromium
$ fetch --nohooks chromium
```

## Download lge-chromium-contribution-stats repo
```sh
$ git clone git@github.com:ChromiumGitCoutner/lge-chromium-contribution-stats.git
```

## Modify ./script/runChromiumGitAnalyzer.sh
Register the chromium path in the file.

```sh
 CHROMIUM_PATH=/path/to/Chromium/src (i.e. $HOME/chromium-stats/chromium/Chromium/)
 OUTPUT_PATH=/path/to/lge-chromium-contribution-stats  (i.e. $HOME/github/LGE-Chromium-Stats/lge-chromium-contribution-stats/
 ```
 
## Replace ssh key files in .ssh for auto result update
 ```sh
$ mv id_rsa ~/.ssh
$ mv id_rsa.pub ~/.ssh
```
 
 ## Run
 There are 2 ways to run the tool automatically. One is to use the crontab. The other is to use ./script/boot.sh.
 
 If you want to use boot.sh, please replace user name in the boot.sh
 ```sh
 screen -d -m -t $user ./runChromiumGitAnalyzer.sh $user
 (i.e. screen -d -m -t gyuyoung ./runChromiumGitAnalyzer.sh gyuyoung)
 ```
 Or you just register ./script/runChromiumGitAnalyzer.sh to crontab with an execution time.
  

