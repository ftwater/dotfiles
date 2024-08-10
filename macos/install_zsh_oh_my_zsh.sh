#!/bin/bash
sudo -v
sudo apt-get install curl zsh -y
# oh-my-zsh
echo y |sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended &&
sudo chsh -s $(which zsh) $USER
echo "oh my zsh install success"
# zsh-autosuggestion
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
echo "zsh-autosuggestion install success"
