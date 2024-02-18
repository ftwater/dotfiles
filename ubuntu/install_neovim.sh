#!/bin/bash
sudo apt-get update
sudo apt-get install git neovim -y
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
