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

if [ -f "$JSONFILE" ]
then
     OLD_VERSION=($($jq -r '.'$PRODUCT'.version' $JSONFILE))
     INSTALPATH=($($jq -r '.'$PRODUCT'."'$OLD_VERSION'".locationOfInstallation' $JSONFILE))
 else
echo "JsonFile Not Present"
fi


if [ -z "$INSTALPATH" ] || [ $INSTALPATH == 'null' ]
then
  INSTALPATH=`cat ~/.bashrc | grep 'export PATH' | tail -1 | grep -P /.*?/.*?goldenversions/.*?/ -o | egrep -i "$PRODUCT" | cut -d ":" -f 1`
  #OLD_VERSION="echo $INSTALPATH |cut -d "-" -f 4"
   echo "$INSTALPATH"
 else
   echo "old product installed in $INSTALPATH"
fi
[ -z "$INSTALPATH" ] && echo "there is no  older product installed in system"


echo $OLD_VERSION
echo $INSTALPATH

#sh $HOME/.script/cleanup.sh $PRODUCT $OLD_VERSION $INSTALPATH
