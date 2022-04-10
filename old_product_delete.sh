#!/bin/bash
export PRODUCT_LOC=/home/siripm73
export LOG=products.lst
export LINK="https://"

>$LOG
for product_chk1 in `ls -l $PRODUCT_LOC|grep ^d | awk '{print $9}' |cut -d '-' -f1 | grep folder | uniq`
do
if [ `ls -ltrd $product_chk1-* | wc -l` -ne 1 ];then 
old_product=`ls -trd $product_chk1-* | head -1`
find $PRODUCT_LOC/$old_product -type f \( -name "*lin*.sh*" -o -name "*win*.bat*" \) -print -mmin 1 -exec ls {} \; >>$LOG
fi
done

for old_product in `cat $LOG`
do
curl -k -u user:password -X DELETE "$LINK/$old_product"
done




