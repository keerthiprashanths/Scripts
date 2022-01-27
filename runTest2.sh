#!/bin/bash
#my_dir="$1"
echo "Checking for file .bashrc"
list=`cat ~/.bashrc | grep 'export PATH' | tail -1 | grep -P /home/.*?goldenversions/.*?/ -o `
echo "Here is list of tools installed "
#echo "$list"
json_var="{"
json_var=$json_var" \"tools\": ["
for i in $list
do
	json_var=$json_var' "'$i'",'
done
json_var=$json_var"]}"
echo "updated $json_var"
#| grep 'export PATH' | tail -1 | grep -P goldenversions/.*? -o | cut -d "/" -f 2 | cut -d ":" -f 1
echo "$json_var" | tee output.json > /dev/null 
