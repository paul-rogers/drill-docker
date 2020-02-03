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

# Creates an image that will run Sqlline in interactive mode, connected
# a Drillbit discovered via Zookeeper.
#
# Required run argument: -e ZK_CONNECT=zk1,zk2...

ARG drill_vers
FROM gaucho84/drill:${drill_vers}-base

COPY run-sqlline.sh $DRILL_HOME/bin
RUN chown drill:drill $DRILL_HOME/bin/run-sqlline.sh && \
    chmod +x $DRILL_HOME/bin/run-sqlline.sh

USER drill
ENTRYPOINT ["bash", "bin/run-sqlline.sh"]
