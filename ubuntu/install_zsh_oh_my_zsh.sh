#!/bin/bash
sudo apt-get install curl zsh -y
# zsh-autosuggestion
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# oh-my-zsh
echo y |sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &
wait $!
if [[ $? -ne 0 ]];then
	echo "oh my zsh install faild"
else
	sudo chsh -s $(which zsh)
	echo "oh my zsh install success"
fi

