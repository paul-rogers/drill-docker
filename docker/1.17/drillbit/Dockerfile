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

# Creates a Drill server container suitable for use by itself or
# with Kubernetes.

# Drill requires a ZooKeeper instance to be running. Use
# https://hub.docker.com/_/zookeeper/
#
# Required run argument: -e ZK_CONNECT=zk1,zk2...

ARG drill_vers
FROM gaucho84/drill:${drill_vers}-base

COPY run-drill.sh $DRILL_HOME/bin

# Log configuration to send logs to stdout
# Does not work yet, needs adjustments to drillbit.sh

#COPY logback.xml $DRILL_HOME/conf

RUN chown drill:drill $DRILL_HOME/bin/run-drill.sh && \
    chmod +x $DRILL_HOME/bin/run-drill.sh
#    chown drill:drill $DRILL_HOME/conf/logback.xml && \
#    chmod +x $DRILL_HOME/conf/logback.xml

# Assumes standard Drill ports
# https://drill.apache.org/docs/ports-used-by-drill/

EXPOSE 31010 31011 31012 8047

USER drill
ENTRYPOINT ["bin/run-drill.sh"]
