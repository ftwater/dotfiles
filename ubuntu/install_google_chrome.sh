#!/bin/bash
if [[ ! -f google-chrome-stable_current_amd64.deb ]];then
	echo "downloading google chrome ..."
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O google-chrome-stable_current_amd64.deb > /dev/null
fi
CMD='sudo dpkg -i google-chrome-stable_current_amd64.deb' 
echo "installing google chrome ..."
${CMD} > /dev/null 
if [[ $? -ne 0 ]];then
	echo "retry install ..."
	sudo apt-get -f install -y && ${CMD}
	echo "install chrome success!"
else
	echo "install chrome success one time!"
fi
rm -rf google-chrome-stable_current_amd64.deb
