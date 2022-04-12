FILE=/home/siripm73/arti.txt
TMP_FILE=/home/siripm73/arti.tmp

>$TMP_FILE

for link in `cat $FILE | grep -e 'lin_runner.sh\|win_runner.bat' | tr -d " \t\n\r" | sed 's/""/\n/g' | sed 's/^"//g' | sed 's/"$//g' | sort | uniq | cut -d'"' -f3`
do 
#echo $link
product_name=`echo $link | cut -d"/" -f7`
product_name=`grep $product_name $FILE | grep title | cut -d'"' -f4`
#echo Product Name: $product_name
product_version=`echo $link | cut -d"/" -f8`
product_version=`grep $product_version $FILE | grep title | cut -d'"' -f4 | uniq`
#echo Product Version: $product_version
modified_date=`egrep -B 2 $product_version $FILE | head -1 | cut -d'"' -f4`
#echo $modified_date
product_link=`echo $link | cut -d" " -f2`
#echo Product Link: $product_link
product_mod_date=`echo $modified_date | cut -d"." -f1`
product_mod_date=`date --date=$product_mod_date`
product_mod_date=`date -d"$product_mod_date" +%s`
#echo Product Modified Date: $product_mod_date
curr_date_sec=`date +%s`
diff=$(( ($curr_date_sec-$product_mod_date) / 86400 ))
#echo $diff
sub_verion_chk=`cat $FILE | grep -e 'lin_runner.sh\|win_runner.bat' | tr -d " \t\n\r" | sed 's/""/\n/g' | sed 's/^"//g' | sed 's/"$//g' | sort | uniq | cut -d'"' -f3 | grep $product_name | cut -d"/" -f8 | sort | uniq | wc -l`
if [ $sub_verion_chk -gt 1 ];then
if [ $diff -ge 15 ];then
echo Product Name: $product_name >>$TMP_FILE
echo Product Version: $product_version >>$TMP_FILE
#echo $modified_date
echo Product Link: $product_link >>$TMP_FILE
echo -e "\n" >>$TMP_FILE
fi
fi
done

if [ -s "$TMP_FILE" ]; then
sed -i "1i The listed products are modified 15days ago\n" $TMP_FILE
fi
cat $TMP_FILE



