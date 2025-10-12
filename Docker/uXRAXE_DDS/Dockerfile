# FROM ros:humble-ros-base
FROM ubuntu:22.04
# 
SHELL ["/bin/bash", "-c"]


RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        # software-properties-common \
        # supervisor wget curl gosu  sudo python3-pip python3-tk\
        # build-essential  lsb-release locales \
        # bash-completion && \
        build-essential lsb-release locales cmake git sudo pkg-config && \  
        apt-get autoclean && \
        apt-get autoremove && \
        rm -rf /var/lib/apt/lists/*

# Create non-root user with home directory
RUN useradd -m -s /bin/bash xrcadds


# Give rotortm user permission to sudo if needed (optional)
RUN echo "xrcadds ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


# Set correct permissions for home directory
RUN mkdir -p /home/xrcadds/ && \
    chown -R xrcadds:xrcadds /home/xrcadds && \
    chmod -R 755 /home/xrcadds


# # Copy XRCA-DDS source code
COPY ./src/Micro-XRCE-DDS-Agent /home/xrcadds/Micro-XRCE-DDS-Agent


# Build and install Micro-XRCE-DDS-Agent
RUN cd /home/xrcadds/Micro-XRCE-DDS-Agent && \
    mkdir -p build && cd build && \
    cmake .. && \
    make -j4 && \
    make install && \
    ldconfig

# Switch to non-root user
USER xrcadds

# Set working directory inside the user's home
WORKDIR /home/xrcadds/Micro-XRCE-DDS-Agent
