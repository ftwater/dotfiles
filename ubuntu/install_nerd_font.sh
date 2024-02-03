#!/bin/bash
function install_nerd_font(){
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/0xProto.zip
    if [[ -d 0xProto ]];then
	rm -rf 0xProto
    fi
    mkdir 0xProto
    unzip -d 0xProto 0xProto.zip
    if [[ ! -d ~/.fonts ]];then
	mkdir ~/.fonts	
    fi
    cp ./0xProto/*.ttf ~/.fonts
    fc-cache -fv > /dev/null
    rm -rf ./0xProto.zip ./0xProto
}

install_nerd_font

