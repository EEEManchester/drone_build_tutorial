1. Choose ROS2 version at http://docs.ros.org/
    <figure>
     <img src="8_ROS2/ROS2_Index.png"/>
    </figure>
    Version can be chosen according to OS. For example foxy is recommended for Ubuntu 22.04.

    The steps below are just following guidances given at http://docs.ros.org/en/foxy/Installation/Ubuntu-Install-Debians.html.

2. Get locale supports of UTF-8. 
   
   2.1 Check supoort by typing 
   ```bash
   local
   ```
   2.2 It is supported.
   It means they are already supported if we see 
    <figure>
     <img src="8_ROS2/check_local_support.png"/>
    </figure>
    
    which shows that LANG=en.UTF-8 and UTF-8 support is set alreay.

   2.3 It is not supported and needs to be installed
    Run the follwoing commands in the terminal. 
    
    ```bash
    sudo apt update && sudo apt install locales
    sudo locale-gen en_US en_US.UTF-8
    sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
    export LANG=en_US.UTF-8
    ```

3. Setup Sources for ROS2

    We should set universal apt available for the system. This can be checked by
    
    ```bash
        apt-cache policy | grep universal
    ```
    which results into
        <figure>
        <img src="8_ROS2/universal.png"/>
        </figure>    

    Then, add the ROS2 GPG key with apt.

    ```bash
        sudo apt update && sudo apt install curl -y
        sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
    ```
    and add the rep

    ```bash
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
    ```
4. Install ROS2 packages
   - update and upgrade 
    ```bash
        sudo apt update && sudo apt upgrade
    ```
   - install desktop (Recommended): ROS, RViz, demos, tutorials
    ```bash
        sudo apt install ros-foxy-desktop python3-argcomplete
    ```
    - install development tools like compilers
    ```bash
        sudo apt install ros-dev-tools
    ```
5. Make ROS2 compatible with ROS

    .bashrc needs to be modified in order to source ROS and ROS2.

    - find .bashrc in ~
    - find and comments source commands for ROS, like ROS noetic
        ```bash
        # ROS noetic
        #source /opt/ros/noetic/setup.bash
        #source ~/catkin_ws/devel/setup.bash  
        ```       
    - add source commands for ROS2 such that
        ```bash
        # ROS noetic
        #source /opt/ros/noetic/setup.bash
        #source ~/catkin_ws/devel/setup.bash

        # ROS2 foxy
        source /opt/ros/foxy/setup.bash    
        ```
    - NOTE switching between ROS and ROS2 is done through modifying .bashrc
      - use ROS by commenting source commands for ROS2
        ```bash
        # ROS noetic
        source /opt/ros/noetic/setup.bash
        source ~/catkin_ws/devel/setup.bash

        # ROS2 foxy
        #source /opt/ros/foxy/setup.bash    
        ```
      - use ROS2 by commenting source commands for ROS
        ```bash
        # ROS noetic
        #source /opt/ros/noetic/setup.bash
        #source ~/catkin_ws/devel/setup.bash

        # ROS2 foxy
        source /opt/ros/foxy/setup.bash    
        ```
6. Check ROS2 installation
   
   In a terminal
   ```bash
        ros2 run demo_nodes_cpp talker
   ```
   and in another
   ```bash
        ros2 run demo_nodes_cpp listener
   ```   

   Installation is completed if we can see 
        <figure>
        <img src="8_ROS2/talker_listener.png"/>
        </figure>   

    We can find the rqt_grap by typing rqt_gragh in termainl and 
         <figure>
        <img src="8_ROS2/grapsh_talker_listener.png"/>
        </figure>      