#!/bin/sh

HOST_NAME=`hostname`
INSTANCE="`echo wayback.${HOST_NAME} | tr A-Z a-z`"
PID_FILE="/var/run/wayback/${INSTANCE}.pid"
PROCESS_ID=`cat ${PID_FILE}`

cat $PID_FILE | xargs kill -9
rm  $PID_FILE

echo "Wayback machine stopped, killing process PID: ${PROCESS_ID}"
