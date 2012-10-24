#!/bin/bash

RECOVERY_FILE=$1
SDK_URL="http://dl.google.com/android/android-sdk_r20.0.3-linux.tgz"

installSDK(){
	checkJava
	echo "Downloading SDK..."
	wget $SDK_URL -O android_sdk.tgz
	echo "Extracting SDK..."
	tar xf android_sdk.tgz
	rm android_sdk.tgz
	cd android-sdk-linux/tools
	./android update sdk -u -t platform-tool
	cd ../..
	PATH_DIR=$(readlink -f android-sdk-linux/platform-tools)
	echo "export PATH=$PATH:$PATH_DIR" >> ~/.bashrc
	export PATH=$PATH:$PATH_DIR
}

findFastboot(){
	echo `find /root /home -name 'fastboot' 2>/dev/null | awk {'print $1'}`
}

addFastbootPath(){
	FASTBOOT=$(findFastboot)
	PATH_DIR=$(dirname $FASTBOOT)
	echo "export PATH=$PATH:$PATH_DIR" >> ~/.bashrc
	export PATH=$PATH:$PATH_DIR	
}

checkFastboot(){
	if ! type 'fastboot' > /dev/null 2>&1; then
		echo "No fastboot in path"
		read -p 'Download fastboot?[y/n] ' DOWNLOAD_ANSWER
		if [ "$DOWNLOAD_ANSWER" == "y" ]; then
			 #download sdk etc
			installSDK
		else 
			echo "Searching for fastboot..."
			addFastbootPath
		fi
	fi
}

checkJava(){
	if ! type 'java' > /dev/null 2>&1; then
		echo "Please install OpenJDK!"
		exit 1
	fi
}

source ~/.bashrc

checkFastboot
	
echo "Flashing Recovery..."
fastboot flash recovery $RECOVERY_FILE
