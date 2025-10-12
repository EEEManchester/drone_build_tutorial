#!/bin/bash
# Get absolute path with realpath

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Script directory: $SCRIPT_DIR"
USER_ID=px4ros2
echo "User ID: $USER_ID"

xhost +local:docker

PX4_SRC_DIR="${SCRIPT_DIR}/src/PX4-Autopilot"
echo "PX4 Source Dir: $PX4_SRC_DIR"

docker run -it --rm --privileged \
            -v "${PX4_SRC_DIR}:/home/px4ros2/ros2_ws/src/PX4-Autopilot:rw" \
            -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
            -e ROS_DOMAIN_ID=132\
            -e DISPLAY=:0 \
            --network host \
            --name=ros2_px4 \
             ros2_px4:latest bash

