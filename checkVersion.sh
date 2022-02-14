#!/bin/bash
#my_dir="$1"
echo "Checking for file .bashrc"
list=`cat ~/.bashrc | grep 'export PATH' | tail -1 | grep -P /home/.*?goldenversions/.*?/ -o | cut -d ":" -f 1`
echo "Here is list of tools installed "
#echo "$list"
json_var="["
json_var=$json_var' \n "Tools" :'
for i in $list
do
	json_var=$json_var'{ \n'
	product_name=`echo $i | cut -d "/" -f 5`
	json_var=$json_var'"product" : "'$product_name'", \n'
	version=`echo $product_name | cut -d "-" -f 2`
	api_response=`curl -X GET https://reqbin.com/echo/get/json -H "Accept: */*"  2> /dev/null`
	echo "Version $product_name of is  $version"
	echo "Response $api_response"
done
