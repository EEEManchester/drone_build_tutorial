#!/bin/bash

# Set image name and tag
IMAGE_NAME="px4_ros_noetic"
TAG="latest"

# Print information
echo "Building Docker image: $IMAGE_NAME:$TAG"
echo "---------------------------------------------"

# Build the Docker image
docker build -t $IMAGE_NAME:$TAG .

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "---------------------------------------------"
    echo "Build successful!"
    echo "You can run the container with:"
    echo "1. docker run -it --privileged --env=LOCAL_USER_ID="$(id -u)" -v ~/Desktop/Docker/PX4/PX4-Autopilot:/src/PX4-Autopilot/:rw -v /tmp/.X11-unix:/tmp/.X11-unix:ro -e DISPLAY=:0 --network host --name=px4-ros_noetic px4_ros_noetic:latest bash"
    echo "2. cd src/PX4-Autopilot    #In container; make px4_sitl_default gazebo-classic"
    echo "more informatoin can be found https://docs.px4.io/main/en/test_and_ci/docker.html"
else
    echo "---------------------------------------------"
    echo "Build failed!"
fi