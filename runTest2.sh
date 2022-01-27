#!/bin/bash

#my_dir="$1"


echo "Checking for file .bashrc"

list=`cat ~/.bashrc | grep 'export PATH' | tail -1 | grep -P goldenversions/.*?/ -o | cut -d "/" -f 2 | cut -d ":" -f 1`
echo "Here is list of tools installed "
echo "$list"
#| grep 'export PATH' | tail -1 | grep -P goldenversions/.*? -o | cut -d "/" -f 2 | cut -d ":" -f 1

