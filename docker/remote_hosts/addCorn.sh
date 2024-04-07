#!/bin/bash

# 定义新的 cron 任务
new_cron_job="* * * * * /Users/zhaoyanpeng/tools/dotfiles/docker/remote_hosts/updateHosts.sh >> /Users/zhaoyanpeng/tools/dotfiles/docker/remote_hosts/log.txt 2>&1"

# 使用 `crontab -l` 列出现有的 cron 任务，并将新的 cron 任务追加到这个列表中
# 使用 `crontab -` 将新的任务列表加载到 cron 中
(crontab -l; echo "$new_cron_job") | crontab -
