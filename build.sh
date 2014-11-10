#!/bin/bash
function find_war {
  LOCATION_TO_SEARCH=$1
  PATTERN=$2
  FILE=$(find ${LOCATION_TO_SEARCH}/*${PATTERN}*.war ! -name '*sources*' ! -name '*original*' -print -quit)
  echo ${FILE}
}

mvn clean package
export BASE_DIR=$(cd `dirname $0`; pwd -P)
export TARGET_LOCATION="${BASE_DIR}/wayback-webapp/target"
cp "${TARGET_LOCATION}/dependency/jetty-runner.jar" $TARGET_LOCATION
cp "${BASE_DIR}/wayback" $TARGET_LOCATION
cp "${BASE_DIR}/generate_cdx.sh" $TARGET_LOCATION
export WAR_LOCATION=`find_war ${TARGET_LOCATION} openwayback`
tar -C ${TARGET_LOCATION} -cvzf "${TARGET_LOCATION}/wayback.tar.gz" "`basename $WAR_LOCATION`" "jetty-runner.jar" "wayback" "generate_cdx.sh"
