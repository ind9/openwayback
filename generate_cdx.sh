#!/bin/bash

DATETIME="`date --date="yesterday" +"%Y%m%d"`"
CDX_HDFS_PATH_REGEX="hdfs://cdh-hmaster.production-mr.indix.tv:54310/user/akshay/${DATETIME}_cdx/*.cdx"
CDX_TARGET_PATH="/data/openwayback/cdxindex"
WARC_TARGET_PATH="hdfs://cdh-hmaster.production-mr.indix.tv:54310/user/akshay/${DATETIME}_warc"
WARC_TARGET_PATH_REGEX="$WARC_TARGET_PATH/*.warc"
TEMPFILE="/data/openwayback/temp.file"
CDXTEMPFILE="/tmp/index.cdx"
CDXFILE="/data/openwayback/index.cdx"
PATH_INDEX="/data/openwayback/path-index.txt"

touch $CDXTEMPFILE
echo " CDX N b a m s k r M S V g" >> $CDXTEMPFILE

mkdir -p $CDX_TARGET_PATH
hadoop dfs -copyToLocal $CDX_HDFS_PATH_REGEX $CDX_TARGET_PATH
cat "$CDX_TARGET_PATH/*" >> $CDXTEMPFILE

for filename in `hadoop dfs -ls $WARC_TARGET_PATH_REGEX | sed '1d;s/  */ /g' | cut -d\  -f8 | xargs -n 1 basename`; do
  echo "$filename $WARC_TARGET_PATH/$filename" >> $TEMPFILE
done

export LC_ALL=C;
sort $TEMPFILE > $PATH_INDEX
sort $CDXTEMPFILE > $CDXFILE

rm -rf $CDX_TARGET_PATH
rm $TEMPFILE
rm $CDXTEMPFILE
