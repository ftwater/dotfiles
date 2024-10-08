#!/bin/bash
brew install wget tar openjdk@8
if [[ ! -f apache-maven-3.9.6-bin.tar.gz ]];then
	wget -O apache-maven-3.9.6-bin.tar.gz https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz 
fi
if [[ ! -d ~/tools ]];then
    mkdir -p ~/tools
fi
if [[ -f apache-maven-3.9.6-bin.tar.gz ]];then
	tar -zxvf apache-maven-3.9.6-bin.tar.gz -C ~/tools/ 
	cp -f ./config/settings.xml ~/tools/apache-maven-3.9.6/conf
	rm -rf apache-maven-3.9.6-bin.tar.gz
	echo "maven install success"
else	
	echo "maven install faild:apache-maven-3.9.6-bin.tar.gz not exist"
	return 1
fi
