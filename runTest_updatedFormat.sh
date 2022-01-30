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
	#product_name=`echo $i | cut -d "\" -f 4`
	product_name=`echo $i | cut -d "/" -f 5`
	json_var=$json_var'"product" : "'$product_name'", \n'
	json_var=$json_var'"path" : "'$i'", \n'
	if [ -d $i ] ; then
		json_var=$json_var' "status" : "Available" \n'
	else 
		json_var=$json_var' "status" : "Not Available" \n'
	fi
	json_var=$json_var'}, \n'


done
json_var=$json_var" }}"
echo "updated $json_var"
#| grep 'export PATH' | tail -1 | grep -P goldenversions/.*? -o | cut -d "/" -f 2 | cut -d ":" -f 1
echo "$json_var" | tee output.json > /dev/null 
