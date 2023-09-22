#!/bin/bash

WORK_DIR=$(pwd)

# 实现一个接受字符串参数的函数 打印绿色的log到控制台
function log() {
    echo -e "\033[32m$1\033[0m"
} 

function install_oh_my_zsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" 
}
function install_zsh_autosuggestions(){
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}
function install_jenv() {
    git clone https://github.com/jenv/jenv.git ~/.jenv 
}
function install_zoxide() {
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash 
}
function install_vim_plug() {
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

log "...更新源..."
sudo apt-get update

log "...安装neovim..."
sudo apt-get install neovim -y

log "...安装vim_plug..."
install_vim_plug  &
wait $!

log "...安装zsh..."
sudo apt-get install zsh -y

log "...安装ohmyzsh..."
install_oh_my_zsh &
wait $!

log "...安装zsh autosuggestions..."
install_zsh_autosuggestions &
wait $!

log "...安装jenv..."
install_jenv &
wait $!

log "...安装zoxide..."
install_zoxide &
wait $!

log "...创建配置文件链接..."
log "HOME = $HOME"
mkdir -p $HOME/.config 
ln -s $WORK_DIR/nvim $HOME/.config/nvim 
ln -s $WORK_DIR/ideavimrc $HOME/.ideavimrc 
ln -sf $WORK_DIR/zshrc $HOME/.zshrc

log "设置完成，请重启生效"
log "重启后进入vim,执行PlugInstall安装插件"