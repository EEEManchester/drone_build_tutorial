# Kiss Ardupilot
Arduploit is a great choice for people tired of PX4. Of course, be a nice guy, I should cite someone telling the differences

<figure>
    <img src="8_Arduploit/Arduploit_PX4.png"
         height="250">
</figure>

## 1 Build or Download Ardupliot framework
### 1.1 Build Arduploit from source code
1. clone a arduploit rep from my github and do not foret adding a star
```git
    git clone https://github.com/ZhongmouLi/ardupilot
```
2. choose a proper and stable version for the drone according to the hardware that we are going to use.
    - find the hardware at [https://firmware.ardupilot.org/Copter/stable/](https://firmware.ardupilot.org/Copter/stable/)
    - Given Pixhawk5x, check Pixhawk5x/firmware-version.txt
    ```txt
            4.3.3-FIRMWARE_VERSION_TYPE_OFFICIAL
    ```
    - switch to this version, like 4.3.3
    ```shell
        cd ardupilot
        git checkout Copter-4.3.3
    ```
3. update submodue in arduploit
    ```shell
        cd arduploit
        git submodule update --init --recursive
    ```        
4. install dependencies and configure base station
    - manullay install dependcies
        - packages

            ```shell
            ## install packages
            sudo apt install python-matplotlib python-serial python-wxgtk3.0 python-wxtools python-lxml python-scipy python-opencv ccache gawk python-pip python-pexpect
            ```

            ```shell
            ## install MAVproxy
            sudo pip install future pymavlink MAVProxy
            ```
        - update .bashrc adding
            ```shell
                export PATH=$PATH:$HOME/ardupilot/Tools/autotest
                export PATH=/usr/lib/ccache:$PATH
            ```
    - auto setup dependencies
        - use install-prereqs-ubuntu.sh for ubuntu base station
        ```shell                   
            cd arduploit
            Tools/environment_install/install-prereqs-ubuntu.sh -y
        ```
        - reload settings (choose one of them)
            - [ ] to check this method
                ```shell
                        cd arduploit
                        . ~/.profile
                ```   
                log out and log in
            - modify .bashrc
            ```shell
                export PATH=$PATH:$HOME/{where_to_ardupilot}/ardupilot/Tools/autotest 
                export PATH=/usr/lib/ccache:$PATH
            ```                   
    - test by runging a STIL
        ```shell
            cd arduploit/ArduCopter
            # for the first time add -w
            sim_vehicle.py -w
        ```
<figure>
    <img src="8_Arduploit/arduploit_simu_test.png"
         height="300">
</figure>

Launch Qgroundcontrol and we can see the version that we choose
<figure>
    <img src="8_Arduploit/Ardu_sim_Q.png">
</figure>

5. use Waf to build an ardupliot firmware for the chosen board. Tutorials to use Waf https://github.com/ArduPilot/ardupilot/blob/master/BUILD.md.
    - clean previous built firmware
    ```shell
         cd ardupliot
         ./waf distclean
    ``` 
    - The available list can be found by 
    ```shell
        cd ardupliot
        ./waf list_boards
    ```
    <figure>
        <img src="8_Arduploit/available_boards.png">
    </figure>

    - video tutorial for next two steps https://youtu.be/lNSvAPZOM_o.
    - choose firmware - it is Pixhawk5X for us
    ```shell
        cd ardupliot 
        ./waf configure --board Pixhawk5X
    ```
    <figure>
        <img src="8_Arduploit/build_config.png">
    </figure>
    
    - build it
    ```shell
        cd ardupliot
        ./waf copter
    ```
    <figure>
        <img src="8_Arduploit/build_result.png">
    </figure>

    - find the built ardupliot file at /ardupliot/build/board_name/bin, like
    <figure>
        <img src="8_Arduploit/build_bin.png">
    </figure>    
    


### 1.2 Download Arduploit firemware
1. we can build an Arduploit firmware at https://custom.ardupilot.org/ choosing
    + drone type
    + board of autoploit
    + **features that are needed**
<figure>
    <img src="8_Arduploit/Custmer_build_Arduploit.png"
         height="300">
</figure>

## 2 ROS-Gazebo simulation with Ardupilot
Video tutorials provided by Intelligent Quads can be found on Youtube
- Ubuntu 18.04 [04 Installing Gazebo and ArduPilot Plugin](https://www.youtube.com/watch?v=m7hPyJJmWmU&list=PLy9nLDKxDN683GqAiJ4IVLquYBod_2oA6&index=5&ab_channel=IntelligentQuads)
- Ubuntu 20.04 [Drone Dev Enviorment Ubuntu 20 04 Update](https://youtu.be/1FpJvUVPxL0)

### 2.1 Import Ardupilot models into Gazebo
Given that our development environments are
- Ubunt 20.04
- ROS noetic
- Gazebo 11.12.0

We follow the steps specified by [Using SITL with legacy versions of Gazebo](https://ardupilot.org/dev/docs/sitl-with-gazebo-legacy.html#sitl-with-gazebo-legacy). If you are using different ROS or Gazebo, please refer to [Using SITL with Gazebo](https://ardupilot.org/dev/docs/sitl-with-gazebo.html).


1. get source code of arduploit plugins for gazebo 11.X
```shell
    cd where_you_want
    git clone https://github.com/ZhongmouLi/ardupilot_gazebo.git
```

2. build ardupilot plugins for gazebo 11.X
```shell
    mkdir build
    cd build
    cmake ..
    make -j4
    sudo make install
    echo 'source /usr/share/gazebo/setup.sh' >> ~/.bashrc
```
3. add the path of models and worlds provided by ardupilot plugins into .bashrc after you change where_your_ardupilot_gazebo_is below
```shell
    echo 'export GAZEBO_MODEL_PATH=where_your_ardupilot_gazebo_is/ardupilot_gazebo/models' >> ~/.bashrc
```
4. add gazebo mode path
```shell
    echo "GAZEBO_MODEL_PATH=${GAZEBO_MODEL_PATH}:$HOME/catkin_ws/src/iq_sim/models" >> ~/.bashrc
```
5. launch a gazebo environment with iris model
```shell
    roslaunch iq_sim runway.launch
```

### 2.2 Link Ardupilot firmware to Gazebo simulator
1. run ardupilot firmware
```shell
    cd Ardupilot
    sim_vehicle.py -v ArduCopter -f gazebo-iris --console
```
we should find an interface, a council and a terminal.
<figure>
    <img src="8_Arduploit/ardupilot_interface.png"
         height="300">
</figure>

2. test connection between Ardupilot and Gazebo by tying commands in the terminal
    2.1 change mode to guided
    ```shell
        mode guided
    ```
    at the same time, we should see in the council that
    <figure>
        <img src="8_Arduploit/guided.png"
            height="100">
    </figure>
    2.2 arm drone 

    ```shell    
        arm throttle
    ```
    we should see
    <figure>
        <img src="8_Arduploit/arm_throttle.png"
            height="70">
    </figure>
    2.3 takeoff

    ```shell
        takeoff 5
    ```
    <figure>
        <img src="8_Arduploit/takeoff.png"
            height="70">
    </figure>
    2.4 with those commands to Ardupilot firmware, we can observe the drone in gazebo in takin off
    <figure>
        <img src="8_Arduploit/drone_gazebo_takeoff.png"
            height="200">
    </figure>   

### 2.3 Connect mavros to Ardupilot in Gazebo
The ROS package mavros provides support for Ardupilot. Then we can run mavros to get drone information into ROS.

In simulation, we specify '''fcu_url:=udp://127.0.0.1:14551@14555'''.
```shell
    roslaunch mavros apm.launch fcu_url:=udp://127.0.0.1:14551@14555
```    

With the help of mavros, we can get mavros topics in ROS showing drone information
<figure>
        <img src="8_Arduploit/mavros_topics.png"
            height="300">
</figure>   

Since we commande the drone to switch to guided mode and take off to a height of 5m, then we check drone state and position in ROS
```shell
    rostopic echo /mavros/state
    rostopic echo /mavros/local_position/pose
```
with the state being guided and position being 5m
<figure>
        <img src="8_Arduploit/mavors_state_local_pose.png"
            height="300">
</figure>   

# Source
1. how to install ardupliot
https://github.com/Intelligent-Quads/iq_tutorials/blob/master/docs/Installing_Ardupilot.md
2. https://ardupilot.org/dev/docs/building-setup-linux.html
3. https://discuss.ardupilot.org/t/arducopter-version-check-api/46694
4. build firmware online https://ardupilot.org/copter/docs/common-loading-firmware-onto-chibios-only-boards.html#common-loading-firmware-onto-chibios-only-boards
5. GSoC 2021 - Custom Firmware Builder, https://discuss.ardupilot.org/t/gsoc-2021-custom-firmware-builder/74946