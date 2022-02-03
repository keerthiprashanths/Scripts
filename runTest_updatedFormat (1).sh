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
	log_file=$i"/log.txt"
	if [ -e $log_file ] ; then
		log_file=$i"/log.txt"
		product_name_2=`cat -A $log_file | egrep -o 'PLAY \[install .*]' | sed -n -e 's/^PLAY \[install\(.*\)]/\1/p'`
		#if [ "$product_name" != "${product_name_2##*( )}"] ; then
		#	echo "Name mismtach"
		#fi		
		dateTime=`cat -A $log_file | egrep 'PLAY \[install .*]' | cut -d ' ' -f 1,2`		
		is_Failed=`cat -A $log_file | egrep 'PLAY RECAP' -A 2 | tail -1 | grep -P -o 'failed=.*? '| cut -d '=' -f 2 | sed 's/ *$//g'`
		if [ "$is_Failed" -eq "0" ] ; then
			json_var=$json_var' "Ansible_status" : "Success", \n'
			json_var=$json_var' "date_time" : "'$dateTime'", \n'

		else   
			json_var=$json_var' "Ansible_status" : "Failed", \n' 
		fi 
	else 
		json_var=$json_var' "Ansible_status" : "Not Available" \n'
	fi
	json_var=$json_var'}, \n'
done
json_var=$json_var" }]"
echo "updated $json_var"
#| grep 'export PATH' | tail -1 | grep -P goldenversions/.*? -o | cut -d "/" -f 2 | cut -d ":" -f 1
echo -e "$json_var" | tee output.json > /dev/null 
