# Copyright 2020-2024 Tiryoh<tiryoh@gmail.com>
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
# This Dockerfile is based on https://github.com/AtsushiSaito/docker-ubuntu-sweb
# which is released under the Apache-2.0 license.

FROM px4io/px4-dev-ros-noetic:latest

SHELL ["/bin/bash", "-c"]

# Add Package
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        supervisor wget curl gosu git sudo \
        vim sudo lsb-release locales \
        bash-completion && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*


# Install catkin tools
RUN apt-get update && \
    apt-get install -y python3-catkin-tools python3-osrf-pycommon && \
    rm -rf /var/lib/apt/lists/*





# Set correct permissions for home directory
RUN mkdir -p /catkin_ws/src

WORKDIR /catkin_ws

RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && catkin init"

COPY ./drone_simulation_tools /catkin_ws/src/drone_simulation_tools

# Build the workspace
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && catkin build"
    
    

# Enable apt-get completion after running `apt-get update` in the container
RUN rm /etc/apt/apt.conf.d/docker-clean

COPY ./entrypoint.sh /
ENTRYPOINT [ "/bin/bash", "-c", "/entrypoint.sh" ]