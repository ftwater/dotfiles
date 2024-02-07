#!/bin/bash

WORK_DIR=$(pwd)

# 实现一个接受字符串参数的函数 打印绿色的log到控制台
function log() {
    echo -e "\033[32m$1\033[0m"
} 

function install_jenv() {
    git clone https://github.com/jenv/jenv.git ~/.jenv 
}
function install_zoxide() {
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash 
}

log "...更新源..."
sudo apt-get update

log "...install base..."
sudo apt-get install curl wget unzip -y

log "...install input method rime-ibus..."
sudo apt-get install ibus-rime librime-data-luna-pinyin -y

log "...安装neovim..."
sudo apt-get install neovim -y

log "...安装jenv..."
install_jenv &

log "...安装zoxide..."
install_zoxide &

# log "...创建配置文件链接..."
# log "HOME = $HOME"
# mkdir -p $HOME/.config 
# ln -sf $WORK_DIR/zshrc $HOME/.zshrc

./install_nerd_font.sh
./install_java_env.sh
./install_google_chrome.sh
./install_zsh_oh_my_zsh.sh

log "设置完成，请重启生效"
