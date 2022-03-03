#!/usr/bin/env bash
PRODUCT=jruby
VERSION=	
SUBPROID=$2
JSONFILE="$HOME/.script/JsonFile"
OS=$3
JQPRODUCT="jq-linux"
JQVERSION="1.6"
#JQ integration


if type -p unzip; then
   echo "unzip avaialble"
elif [ $OS == rh ]  then
    then
   sudo  yum install unzip -y
else
    sudo apt install unzip
fi

if [ -d "$JQPRODUCT" ]
then
  echo "jq is present"
  export  jq=$HOME/.script/jq-linux/jq

 else
   wget -P $HOME/.script https://artifactory.global.standardchartered.com/artifactory/technology-standard-release/application/business-application/corporate/commercial-and-institutional-banking/jq/$JQVERSION/$JQPRODUCT-$JQVERSION.zip
   unzip $HOME/.script/$JQPRODUCT-$JQVERSION.zip
   export  jq=$HOME/.script/jq-linux/jq
   rm -rf $HOME/.script/$JQPRODUCT-$JQVERSION.zip
   
fi

OLD_VERSION_FOUND="False"
OLD_VERSION=""
if [ -f "$JSONFILE" ]
then
	OLD_VERSION=($($jq -r '.'$PRODUCT'.version' $JSONFILE))
	OLD_INSTALPATH=($($jq -r '.'$PRODUCT'."'$OLD_VERSION'".locationOfInstallation' $JSONFILE))
	if [ "$OLD_VERSION" == "null" ] ; then 
		OLD_VERSION=""
	fi
else
	echo "JsonFile Not Present"
fi


if [ "$OLD_VERSION" = "" ] ; then
	# Checking old version
	printf "Checking for file .bashrc"
	list=`cat ~/.bashrc | grep 'export PATH' | tail -1 | grep -P /home/.*?goldenversions/.*?/ -o | cut -d ":" -f 1`
	#echo "$list"
	for i in $list
	do
		product_name=`echo $i | cut -d "/" -f 5`
		if [ "$product_name" = "$PRODUCT" ] ; then 
			OLD_VERSION=`echo $product_name | cut -d "-" -f 2`
		fi
	done
fi

gold_dir="/home/infr/*"

if [ "$OLD_VERSION" = "" ] ; then

	for dir in $gold_dir
	do
		temp_dir="${dir##*/}"
		version=`echo $temp_dir | cut -d "-" -f 2`
		temp_name=`echo $temp_dir | cut -d "-" -f 1`
		if [ "$temp_name" = "$PRODUCT" ] ; then
			INSTALPATH="$dir"
			OLD_VERSION="$version"
		fi
	done
fi



echo $OLD_VERSION
echo $INSTALPATH


if [ "$OLD_VERSION" = "" ] ; then
	api_response_new=`curl https://reqbin.com/echo/get/json   2> /dev/null`
	if [ "$api_response_new" = "{\"success\":\"true\"}" ] ; then
		exit "New version is vulnerable"
	fi
else
	api_response_old=`curl https://reqbin.com/echo/get/json   2> /dev/null`
	api_response_new=`curl https://reqbin.com/echo/get/json   2> /dev/null`
	if [ "$api_response_old" = "{\"success\":\"true\"}" ] ; then
		printf "\n Older version is vulnerable"
		printf "\n Calling cleanup script... for $product_name"
		op=`sh cleanup.sh`
		old_removed="True"
	fi
	if [ "$api_response_new" = "{\"success\":\"true\"}" ] ; then
		exit "New version is vulnerable"
	fi
	if [ "$old_removed" = "False" ] ; then
		op=`sh cleanup.sh`
	fi
	printf "\n Installing latest version"
fi

#sh $HOME/.script/cleanup.sh $PRODUCT $OLD_VERSION $INSTALPATH
