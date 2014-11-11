#!/bin/bash

DATETIME="`date --date="yesterday" +"%Y%m%d"`"
CDX_HDFS_PATH_REGEX="${CDX_HDFS_PATH}${CDX_LOCATION}/${DATETIME}_cdx/*.cdx"
WARC_TARGET_PATH="${WARC_HDFS_PATH}${WARC_LOCATION}/${DATETIME}_warc"
WARC_TARGET_PATH_REGEX="${WARC_TARGET_PATH}/*.warc"
TEMPFILE="/tmp/temp.file"
CDXTEMPFILE="/tmp/index.cdx"

touch $CDXTEMPFILE
echo " CDX N b a m s k r M S V g" >> $CDXTEMPFILE

mkdir -p $CDX_TARGET_PATH
hadoop dfs -copyToLocal $CDX_HDFS_PATH_REGEX $CDX_TARGET_PATH
cat $CDX_TARGET_PATH/* >> $CDXTEMPFILE

for filename in `hadoop dfs -ls $WARC_TARGET_PATH_REGEX | sed '1d;s/  */ /g' | cut -d\  -f8 | xargs -n 1 basename`; do
  echo "$filename $WARC_TARGET_PATH/$filename" >> $TEMPFILE
done

export LC_ALL=C;
sort $TEMPFILE > $PATH_INDEX
sort $CDXTEMPFILE > $CDXFILE

rm -rf $CDX_TARGET_PATH
rm $TEMPFILE
rm $CDXTEMPFILE
