FILE=/home/siripm73/arti.txt

cat $FILE | grep -e 'lin_runner.sh\|win_runner.bat' | while read line
do
echo $link
echo ""
echo ""
echo ""
product_name=`echo $link | cut -d"/" -f7`
product_name=`grep $product_name $FILE | grep title | cut -d'"' -f4`
echo Product Name: $product_name
product_version=`echo $link | cut -d"/" -f8`
product_version=`grep $product_version $FILE | grep title | cut -d'"' -f4`
echo Product Version: $product_version
modified_date=`egrep -B 2 $product_version $FILE | head -1 | cut -d'"' -f4`
echo $modified_date
product_link=`echo $link | cut -d" " -f2`
echo Product Link: $product_link
product_mod_date=`echo $modified_date | cut -d"." -f1`
product_mod_date=`date --date=$product_mod_date`
product_mod_date=`date -d"$product_mod_date" +%s`
echo Product Modified Date: $product_mod_date
curr_date_sec=`date +%s`
diff=$(( ($curr_date_sec-$product_mod_date) / 86400 ))
echo $diff
if [ $diff -ge 15 ];then
echo "The below product listed modified 15days ago"
echo Product Name: $product_name
echo Product Version: $product_version
echo $modified_date
echo Product Link: $product_link
echo -e "\n"
fi
done


