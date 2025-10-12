# FROM ros:humble-ros-base
FROM ubuntu:22.04
# 
SHELL ["/bin/bash", "-c"]
USER root
# # Fix GPG conflict BEFORE running apt update
RUN rm -f /etc/apt/sources.list.d/ros2-latest.list && \
    apt update && apt install -y curl gnupg2 lsb-release

# Add new ROS 2 apt source
RUN export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}') && \
    curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(lsb_release -cs)_all.deb" && \
    apt install -y /tmp/ros2-apt-source.deb && \
    rm -f /tmp/ros2-apt-source.deb

# Install basic pkgs
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        software-properties-common \
        supervisor wget curl gosu git sudo python3-pip python3-tk\
        build-essential  lsb-release locales tree vim \
        bash-completion tzdata && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# Install PX4 pkgs specified by /setup/ubuntu.sh
COPY ./src/PX4-Autopilot/Tools/setup /setup

RUN ls -l /setup && cat /setup/ubuntu.sh && \
    chmod +x /setup/ubuntu.sh
RUN /setup/ubuntu.sh


# depencies
# RUN pip3 install --user -U empy pyros-genmsg setuptools
RUN pip3 install empy==3.3.4 pyros-genmsg setuptools kconfiglib pyyaml jsonschema jinja2 empy 


# Create non-root user with home directory
RUN useradd -m -s /bin/bash px4ros2


# Give rotortm user permission to sudo if needed (optional)
RUN echo "px4ros2 ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


# Set correct permissions for home directory
RUN mkdir -p /home/px4ros2/ros2_ws/src && \
    chown -R px4ros2:px4ros2 /home/px4ros2/ros2_ws && \
    chmod -R 755 /home/px4ros2/ros2_ws


# Set up ros2_ws workspace and fix ownership
RUN mkdir -p /home/px4ros2/ros2_ws/src && \
    chown -R px4ros2:px4ros2 /home/px4ros2/ros2_ws


# Install xRACE-DDS
# Get source code
RUN git clone -b feature/xrce-agent-v2.4.2 https://github.com/ZhongmouLi/Micro-XRCE-DDS-Agent.git /home/px4ros2/ros2_ws/src/Micro-XRCE-DDS-Agent

# Build and install Micro-XRCE-DDS-Agent
RUN cd /home/px4ros2/ros2_ws/src/Micro-XRCE-DDS-Agent && \
    mkdir -p build && cd build && \
    cmake .. && \
    make -j4 && \
    make install && \
    ldconfig


# Switch to non-root user
USER px4ros2

# Set working directory inside the user's home
WORKDIR /home/px4ros2/ros2_ws

# Initialize the ros2_ws workspace
# RUN /bin/bash -c "source /opt/ros/humble/setup.bash && colcon build"