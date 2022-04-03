cat credentials
#Please provide your credentials here
Username=myuser1
Password=mypassword1
=========================================================================================
cat housekeep_JFrog_artifact.sh

USER=`cat credentials | grep -e '^Username' | cut -d"=" -f2`
PASSWORD=`cat credentials | grep -e '^Password' | cut -d"=" -f2`
START_TIME=`date +%s%3N`
END_TIME=`date +%s%3N --date="15 days ago"`
REPO=<>
#
RESULTS=`curl -s -X GET -u $USER:$PASSWORD "https://localhost/<domain>/api/search/creation?from=$START_TIME&to=$END_TIME&repos=$REPO" | grep uri | awk '{print $3}' | sed s'/.$//' | sed s'/.$//' | sed -r 's/^.{1}//'`
for RESULT in $RESULTS ; do
    echo "fetching path from $RESULT"
	FILE_PATH=`curl -s -X GET -u $USER:$PASSWORD $RESULT | grep downloadUri | awk '{print $3}' | sed s'/.$//' | sed s'/.$//' | sed -r 's/^.{1}//'`
    echo "deleting path $FILE_PATH"
	curl -X DELETE -u $USER:$PASSWORD $FILE_PATH
	echo "deleted path $FILE_PATH"
done
================================================================================================