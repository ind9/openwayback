#!/bin/bash

DATETIME="`date --date="yesterday" +"%Y%m%d"`"
CDX_HDFS_PATH_REGEX="${CDX_HDFS_PATH}${CDX_LOCATION}/${DATETIME}_cdx/*.cdx"
WARC_TARGET_PATH="${WARC_HDFS_PATH}${WARC_LOCATION}/${DATETIME}_warc"
S3_WARC_TARGET_PATH="s3n://${S3KEYID}:${S3KEYSECRET}@indix-wayback/${DATETIME}_warc"
WARC_TARGET_PATH_REGEX="${WARC_TARGET_PATH}/*.warc"
NEWTMPFILE="/tmp/temp2.file"
TEMPFILE="/tmp/temp.file"
CDXTEMPFILE="/tmp/index.cdx"
ONEDAYAGOCDX="`dirname $CDXFILE`/onedayago.cdx"
TWODAYSAGOCDX="`dirname $CDXFILE`/twodaysago.cdx"
THREEDAYSAGOCDX="`dirname $CDXFILE`/threedaysago.cdx"
FOURDAYSAGOCDX="`dirname $CDXFILE`/fourdaysago.cdx"
FIVEDAYSAGOCDX="`dirname $CDXFILE`/fivedaysago.cdx"
ONEDAYAGOPATHINDEX="`dirname $PATH_INDEX`/path-index1.txt"
TWODAYSAGOPATHINDEX="`dirname $PATH_INDEX`/path-index2.txt"
THREEDAYSAGOPATHINDEX="`dirname $PATH_INDEX`/path-index3.txt"
FOURDAYSAGOPATHINDEX="`dirname $PATH_INDEX`/path-index4.txt"
FIVEDAYSAGOPATHINDEX="`dirname $PATH_INDEX`/path-index5.txt"
touch $CDXTEMPFILE
echo " CDX N b a m s k r M S V g" >> $CDXTEMPFILE

mkdir -p $CDX_TARGET_PATH
hadoop dfs -copyToLocal $CDX_HDFS_PATH_REGEX $CDX_TARGET_PATH

# Using xargs to split ls into chunks of 32 arguments and
# spawning 8 different cat processes to handle it all
# NOTE: Doing a normal "cat ./*" here will result in an
# error because sometimes the argument list would be too long

cd $CDX_TARGET_PATH; ls | xargs -n 32 -P 8 cat >> $CDXTEMPFILE

for filename in `hadoop dfs -ls $WARC_TARGET_PATH_REGEX | sed '1d;s/  */ /g' | cut -d\  -f8 | xargs -n 1 basename`; do
  echo "$filename ${S3_WARC_TARGET_PATH}/$filename" >> $TEMPFILE
done
cp $TEMPFILE $NEWTMPFILE
cat $ONEDAYAGOPATHINDEX $TWODAYSAGOPATHINDEX $THREEDAYSAGOPATHINDEX $FOURDAYSAGOPATHINDEX >> $TEMPFILE

export LC_ALL=C;
sort $TEMPFILE > $PATH_INDEX
sort $CDXTEMPFILE > $CDXFILE

rm -rf $CDX_TARGET_PATH
rm $TEMPFILE
rm $CDXTEMPFILE
rm $FIVEDAYSAGOCDX
rm $FIVEDAYSAGOPATHINDEX
mv $FOURDAYSAGOCDX $FIVEDAYSAGOCDX
mv $THREEDAYSAGOCDX $FOURDAYSAGOCDX
mv $TWODAYSAGOCDX $THREEDAYSAGOCDX
mv $ONEDAYAGOCDX $TWODAYSAGOCDX
mv $CDXFILE $ONEDAYAGOCDX
mv $FOURDAYSAGOPATHINDEX $FIVEDAYSAGOPATHINDEX
mv $THREEDAYSAGOPATHINDEX $FOURDAYSAGOPATHINDEX
mv $TWODAYSAGOPATHINDEX $THREEDAYSAGOPATHINDEX
mv $ONEDAYAGOPATHINDEX $TWODAYSAGOPATHINDEX
mv $NEWTMPFILE $ONEDAYAGOPATHINDEX
