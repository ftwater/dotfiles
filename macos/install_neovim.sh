#!/bin/bash
brew install git
brew install neovim
# 安装包管理器 packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
# 安装tmp 用于管理tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
