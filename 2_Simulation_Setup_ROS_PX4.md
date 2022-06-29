# Setup of ROS, PX4 (Gazebo) and Mavros (mavlink) 
This is to setup ros environment and autoploit framework
There are several things to be installed
- **ROS**
- **PX4** as framwork of autoploit
- **Mavros** for communication between PX4 and ROS
- Controller library (optional)

## Step 1 Install ROS

## Step 2 Build PX4 from source code
1. Download PX4 of version 1.12.3
```bash
git clone -b v1.12.3 https://github.com/PX4/PX4-Autopilot.git --recursive
```
Check PX4 version with
```bash
git describe
```
we should get
<figure>
    <img src="2_ROS_PX4/px4_version.png"
         height="40">
    <figcaption>px4 version</figcaption>
</figure>

2. Run the script to install dependencies and tools for nuttx, jMAVSim, Gazebo s
```bash
bash ./PX4-Autopilot/Tools/setup/ubuntu.sh
```
3.  Test PX4 within Gazebo
```bash
make px4_sitl gazebo
```
## Step 2.5 Enable rosluanch to launch PX4 in Gazebo
Following steps of *Install PX4 SITL(Only to Simulate)* [here](https://github.com/ZhongmouLi/mavros_controllers)
```
cd <Firmware_directory>
DONT_RUN=1 make px4_sitl_default gazebo
```
In cases of errors, do
```bash
cd <Firmware_directory>
make clean
rm -r ~/catkin_ws/devel ~/catkin_ws/build 
```

Modify .bashrc by adding
(replace <span style="color:red"> *address_of_PX4-Autopilot* </span>by where you install PX4-Autopilot int the following commande)


```bash
source Tools/setup_gazebo.bash address_of_PX4-Autopilot $address_of_PX4-Autopilot/build/px4_sitl_default
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$address_of_PX4-Autopilot
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$address_of_PX4-Autopilot/Tools/sitl_gazebo
```
5. Check if ros can find px4 package
```bash
rospack find px4
```
It should give

<figure>
    <img src="2_ROS_PX4/px4_ros.png"
         height="50">
    <figcaption>px4 found by ros</figcaption>
</figure>

6. Check if ros can launch px4 in gazebo
```bash
roslaunch px4 posix_sitl.launch
```
Errors like 
<figure>
    <img src="2_ROS_PX4/gazebo_errors.png"
         height="40">
    <figcaption>gazebo errors</figcaption>
</figure>
do 
```
ps aux | grep gzserver
kill -2 <pid associated with gzserver>
```

## Step 3 Build Mavros from source code
Following steps in [ROS with MAVROS Installation Guide](https://docs.px4.io/master/en/ros/mavros_installation.html)

Here we show do to build MAVROS from source code .

[ROS with MAVROS Installation Guide | PX4 User Guide](https://docs.px4.io/master/en/ros/mavros_installation.html)

1. install building and managing tools, catkin tools and wstool see the section below,
2. initialize your source space with wstool
    1. the target directory of wstool is src
    
    ```bash
    $ wstool init ~/catkin_ws/src
    ```
    
3. Install MAVLink
    1. note: tee is to write the output of rosinstall_generator into the file mavros.rosinstall
    
    ```bash
    # We use the Kinetic reference for all ROS distros as it's not distro-specific and up to date
    rosinstall_generator --rosdistro kinetic mavlink | tee /tmp/mavros.rosinstall
    ```
    
4. install MAVROS with stable one
        
        ```bash
        rosinstall_generator --upstream mavros | tee -a /tmp/mavros.rosinstall
        ```
        
    3. as a consequence, we can cat the "/temp/mavros.rosinstall" that is shown below. We can see from that, wstool just records the git rep information, such as URL, branch name and version.
        
        ```bash
        - git:
            local-name: mavlink
            uri: https://github.com/mavlink/mavlink-gbp-release.git
            version: release/kinetic/mavlink/2021.3.3-1
        
        - git:
            local-name: mavros
            uri: https://github.com/mavlink/mavros.git
            version: 1.10.0
        ```
        
5. Create workspace & deps (explanation of wstool see [here](https://docs.ros.org/en/independent/api/rosinstall/html/rosws.html))
    
    ```bash
    #  run this commande in /catkin_ws which merges config in /tmp/mavros.rosinstall to src/.rosinstall
    wstool merge -t src /tmp/mavros.rosinstall  
    
    #  This command pulls changes from remote to your local filesystem.
    # download the source codes from git 
    wstool update -t src -j4
    
    // 
    rosdep install --from-paths src --ignore-src -y
    ```
    
6. Install [GeographicLib](https://geographiclib.sourceforge.io/) dataset
    
    ```bash
    ./src/mavros/mavros/scripts/install_geographiclib_datasets.sh
    
    # if /bin/bash^M: bad interpreter: No such file or directory
    Try running *dos2unix* on the script:
    
    http://dos2unix.sourceforge.net/
    ```
    
7. build source
    
    ```bash
    catkin build
    ```
    
8. use setup.bash or setup.zsh from workspace.
    
    ```bash
    source ./deve/source.bash
    ```
    
9. check if MAVROS and MAVLink are well installed
    
    ```bash
    rospack find mavros
    
    rospack find mavlink
    ```
    

which gives

<figure>
    <img src="2_ROS_PX4/Installed_mavros.png"
         height="80">
    <figcaption>Mavros and Mavlink are installed</figcaption>
</figure>