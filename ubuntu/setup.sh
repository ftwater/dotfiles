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
function install_nerd_font(){
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/0xProto.zip
    mkdir 0xProto
    uzip -d 0xProto 0xProto.zip
    cp ./0xProto/*.ttf ~/.fonts
    fc-cache -fv
    rm -rf ./0xProto.zip /0xProto
}

log "...更新源..."
sudo apt-get update

log "...install base..."
sudo apt-get install curl wget unzip -y

log "...安装neovim..."
sudo apt-get install neovim -y

log "...安装jenv..."
install_jenv &

log "...安装zoxide..."
install_zoxide &

log "...install nerdFont..."
install_nerd_font &

# log "...创建配置文件链接..."
# log "HOME = $HOME"
# mkdir -p $HOME/.config 
# ln -sf $WORK_DIR/zshrc $HOME/.zshrc

log "设置完成，请重启生效"
