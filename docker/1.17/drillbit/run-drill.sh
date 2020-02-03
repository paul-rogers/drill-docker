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

if [ -z $ZK_CONNECT ]; then
  echo "ZK_CONNECT variable is required to identify your ZK server"
  exit 1
fi

# Pass the ZK server to Drill, overriding the setting in
# drill-override.conf. Unfortunately, this also replaces any
# generic Java arguments.
# TODO: Move ZK_CONNECT support into drill-config.sh

export DRILL_JAVA_OPTS=-Ddrill.exec.zk.connect=$ZK_CONNECT

# Run Drill as the root process
exec $DRILL_HOME/bin/drillbit.sh run
