#!/bin/bash

# 定义要删除的 cron 任务中包含的关键词
keyword_to_remove="updateHosts.sh"

# 使用 `crontab -l` 列出现有的 cron 任务
# 使用 `grep -v` 删除包含指定关键词的行
# 使用 `crontab -` 将结果加载回 cron
(crontab -l | grep -v "$keyword_to_remove") | crontab -
