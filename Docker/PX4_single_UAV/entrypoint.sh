#!/bin/bash
set -e

# Source ROS setup immediately for this script
source /opt/ros/noetic/setup.bash


# Source the built workspace
if [ -f /catkin_ws/devel/setup.bash ]; then
    source /catkin_ws/devel/setup.bash
else
    echo "WARNING: /catkin_ws/devel/setup.bash not found — did you forget to build?"
fi



# PX4-Autopilot path (mounted from host)
PX4_PATH=/src/PX4-Autopilot

# Check if PX4 directory exists
if [ ! -d "$PX4_PATH" ]; then
    echo "ERROR: PX4 source directory $PX4_PATH not found (did you mount it with -v?)"
    exit 1
fi

# If arguments were passed, execute them
if [ $# -gt 0 ]; then
    exec "$@"
else
    # Go to PX4 directory
    cd $PX4_PATH

    # Build PX4 (based on mounted host code)
    echo "Building PX4 SITL (this may take a while)..."
    # DONT_RUN=1 make px4_sitl_default gazebo-classic
    DONT_RUN=1 make px4_sitl_default gazebo

    # Source Gazebo Classic + PX4 simulation setup
    # source Tools/simulation/gazebo-classic/setup_gazebo.bash $(pwd) $(pwd)/build/px4_sitl_default
    source Tools/setup_gazebo.bash $(pwd) $(pwd)/build/px4_sitl_default

    # Extend ROS package path
    # export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$(pwd)
    # export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$(pwd)/Tools/simulation/gazebo-classic/sitl_gazebo-classic

    export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$(pwd)
    export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$(pwd)/Tools/sitl_gazebo

    # Optional: confirm PX4 is visible to ROS
    echo "ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH"
    rospack find px4 || { echo "ERROR: PX4 ROS package not found"; exit 1; }

    # Launch PX4 SITL + Gazebo Classic
    exec roslaunch drone_simulation_tools drone_px4_gps_mavros.launch
    bash
fi
