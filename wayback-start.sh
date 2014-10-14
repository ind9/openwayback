#!/bin/sh

# set +e +x

# Finds the jar inside the specified directory
# Inspired from - http://git.io/yeYy9Q
# Usage: find_war $(JAR_WAR_DIR} "wayback*"
function find_war {
    LOCATION_TO_SEARCH=$1
    PATTERN=$2
    FILE=$(find ${LOCATION_TO_SEARCH}/*${PATTERN}*.war ! -name '*sources*' ! -name '*original*' -print -quit)
    echo ${FILE}
}

export BASE_DIR=$(cd `dirname $0`; pwd -P)

if [ -z $JAVA_HOME ]; then
  echo "JAVA_HOME not defined. Abort."
  exit 1
fi
export JAVA=${JAVA_HOME}/bin/java

# Location of the jar & war files
# Change according to environment
export JAR_WAR_DIR="${BASE_DIR}/wayback-webapp/target"
export WAR_LOCATION=`find_war ${JAR_WAR_DIR} "openwayback*"`
export HOST_NAME=`hostname`
export INSTANCE="`echo wayback.${HOST_NAME} | tr A-Z a-z`"
export LOG_DIR="/var/log/wayback"
export PID_DIR="/var/run/wayback"
export PID_FILE="${PID_DIR}/${INSTANCE}.pid"
export OUT_FILE="${LOG_DIR}/${INSTANCE}.out"
export LOG_FILE="${LOG_DIR}/${INSTANCE}.log"

export EXECUTABLE="$JAVA  -jar ${JAR_WAR_DIR}/dependency/jetty-runner.jar ${WAR_LOCATION}"
nohup python "${BASE_DIR}/wayback-pyjob" "${PID_FILE}" "${LOG_FILE}" "${EXECUTABLE}" > ${OUT_FILE} 2> ${LOG_FILE} &
