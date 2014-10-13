#!/bin/sh

# set +e +x
export DATETIME="`date +%d%m%y.%H%M%S`"
export BASE_DIR=$(cd `dirname $0`; pwd -P)
export JAVA_HOME="/usr/lib/jvm/java-7-oracle"

if [ -z $JAVA_HOME ]; then
  echo "JAVA_HOME not defined. Abort."
  exit 1
fi
export JAVA=${JAVA_HOME}/bin/java

# Location of the jar & war files
# Change according to environment
export JAR_WAR_DIR="/home/akshay/Arceus/indix/openwayback/wayback-webapp/target"

export HOST_NAME=`hostname`
export INSTANCE="`echo wayback.${HOST_NAME} | tr A-Z a-z`"
export LOG_DIR="/var/log/wayback"
export PID_DIR="/var/run/wayback"
export PID_FILE="${PID_DIR}/${INSTANCE}.pid"
export OUT_FILE="${LOG_DIR}/${INSTANCE}.out"
export LOG_FILE="${LOG_DIR}/${INSTANCE}.log"

export EXECUTABLE="$JAVA  -jar ${JAR_WAR_DIR}/jetty-runner.jar ${JAR_WAR_DIR}/openwayback-2.0.1-SNAPSHOT.war"

nohup python "${BASE_DIR}/cannonball-cluster" "${PID_FILE}" "${LOG_FILE}" "${EXECUTABLE}" > ${OUT_FILE} 2>&1 &
