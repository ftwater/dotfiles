#!/bin/bash
sudo apt-get install neovim
DIR=$(pwd)
ln -s $DIR/nvim ~/.config/nvim 
ln -s $DIR/ideavimrc ~/.ideavimrc
