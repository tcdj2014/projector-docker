#!/bin/sh

#
# Copyright 2019-2020 JetBrains s.r.o.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e # Any command which returns non-zero exit code will cause this shell script to exit immediately
set -x # Activate debugging to show execution details: all commands will be printed before execution

containerName=${1:-idea_u}
downloadUrl=${2:-https://download.jetbrains.com/idea/ideaIU-2019.3.5.tar.gz}

# build container:
docker build --progress=plain -t registry.cn-shanghai.aliyuncs.com/xmtang/idea_u:v1.0 --build-arg buildGradle=true --build-arg "downloadUrl=$downloadUrl" -f Dockerfile ..
