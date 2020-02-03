#! /bin/bash

# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

env
if [ -z "$DRILL_VERS" ]; then
  echo "DRILL_VERS must be set to the desired Drill version" >&2
  exit 1
fi

# Distribution
export VERS_NAME=drill-$DRILL_VERS
export DIST_NAME=apache-${VERS_NAME}
export TAR_NAME=${DIST_NAME}.tar.gz
export MIRROR=http://apache.mirrors.hoobly.com

# User & group
export DRILL_USER=drill
export DRILL_UID=1000
export DRILL_GROUP=drill
export DRILL_GID=1000

# Drill setup
export DRILL_HOME=${DRILL_HOME:-/opt/drill}
export DRILL_LOG_DIR=${DRILL_LOG_DIR:-/var/log/drill}

# Create Drill group and user
# Drill users the user's home directory, so create
# one outside of the Drill install dir.
addgroup --gid "$DRILL_GID" "$DRILL_GROUP"
adduser \
    --disabled-password \
    --gecos "" \
    --home "/home/drill" \
    --ingroup "$DRILL_GROUP" \
    --no-create-home \
    --uid "$DRILL_UID" \
    "$DRILL_USER"
mkdir /home/drill
chown drill:drill /home/drill

# Curl needed to install Drill
apk add curl

# Download Drill, adjust directory name, discard tar file to save space
cd /opt
curl -o ${TAR_NAME} ${MIRROR}/drill/${VERS_NAME}/${TAR_NAME}
tar -xzf ${TAR_NAME}
rm ${TAR_NAME}

# Drill files owned by user drill
mv ${DIST_NAME} drill
chown -hR drill:drill drill

# Remove files not needed here to save space
cd $DRILL_HOME
rm git.properties
rm -R winutils
rm -R jars/tools
rm bin/drill-am.sh 
rm bin/drill-embedded
rm bin/drill-on-yarn.sh
rm bin/yarn-drillbit.sh
rm bin/*.bat
rm conf/drill-on-yarn-example.conf
rm conf/yarn-client-log.xml
rm conf/drill-am-log.xml

# Create log directory, owned by user drill
mkdir $DRILL_LOG_DIR
chown drill:drill $DRILL_LOG_DIR

