#!/bin/bash
xhost +local:docker
PX4_SRC_DIR=~/Desktop/Docker/PX4/PX4-Autopilot
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


docker run -it --rm --privileged \
            -v  ${PX4_SRC_DIR}:/src/PX4-Autopilot:rw \
            -v  ${SCRIPT_DIR}/data:/catkin_ws/data \
            -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
            -e DISPLAY=:0 \
            --network host \
            --name=px4-ros_noetic \
             px4_ros_noetic:latest bash

