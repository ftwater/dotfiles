#!/bin/bash
sudo apt-get install neovim zsh
DIR=$(pwd)
ln -s $DIR/nvim ~/.config/nvim 
ln -s $DIR/ideavimrc ~/.ideavimrc
ln -s $DIR/zshrc ~/.zshrc
