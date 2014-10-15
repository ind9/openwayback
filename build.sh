function find_war {
  LOCATION_TO_SEARCH=$1
  PATTERN=$2
  FILE=$(find ${LOCATION_TO_SEARCH}/*${PATTERN}*.war ! -name '*sources*' ! -name '*original*' -print -quit)
  echo ${FILE}
}

#mvn package
export BASE_DIR=$(cd `dirname $0`; pwd -P)
export BUILD_LOCATION="${BASE_DIR}/build"
export TARGET_LOCATION="${BASE_DIR}/wayback-webapp/target"
cp "${TARGET_LOCATION}/dependency/jetty-runner.jar" $BUILD_LOCATION
export WAR_LOCATION=`find_war wayback-webapp/target openwayback*`
echo $WAR_LOCATION
cp $WAR_LOCATION $BUILD_LOCATION
tar -cvzf "${BUILD_LOCATION}/wayback.tar.gz" "${BUILD_LOCATION}"
WAR_LOCATION=`find_war ${BUILD_LOCATION} openwayback*`
rm "${BUILD_LOCATION}/jetty-runner.jar" $WAR_LOCATION
