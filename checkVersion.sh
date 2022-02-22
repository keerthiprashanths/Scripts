#!/bin/bash
#my_dir="$1"
printf "Checking for file .bashrc"
list=`cat ~\.bashrc | grep 'export PATH' | tail -1 | grep -P /home/.*?goldenversions/.*?/ -o | cut -d ":" -f 1`
printf "\n Here is list of tools installed "
#echo "$list"
json_var="["
json_var=$json_var' \n "Tools" :'
for i in $list
do
	json_var=$json_var'{ \n'
	product_name=`echo $i | cut -d "/" -f 5`
	json_var=$json_var'"product" : "'$product_name'", \n'
	version=`echo $product_name | cut -d "-" -f 2`
	api_response=`curl https://reqbin.com/echo/get/json   2> /dev/null`
	printf "\n Version $product_name of is  $version"
	if [ "$api_response" = "{\"success\":\"tru2e\"}" ] ; then
		printf "\n Latest version is installed no changes req for $product_name"
	else
		printf "\n Calling cleanup script... for $product_name"
		op=`sh cleanup.sh`
		printf "\n Installing latest version"
	fi
	
	printf "Response $api_response "
done
