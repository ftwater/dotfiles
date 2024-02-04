#!/bin/bash
sudo apt-get install curl zsh -y
echo y |sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &
wait $!
if [[ $? -ne 0 ]];then
	echo "oh my zsh install faild"
else
	sudo chsh -s $(which zsh)
	echo "oh my zsh install success"
fi

