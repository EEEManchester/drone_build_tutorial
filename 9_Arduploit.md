# Kiss Ardupilot
Arduploit is a great choice for people tired of PX4. Of course, be a nice guy, I should cite someone telling the differences

<figure>
    <img src="8_Arduploit/Arduploit_PX4.png"
         height="250">
</figure>

## 1 Install Ardupilpot on Computer
### Resources
1. Installing Ardupilot and MAVProxy Ubuntu 20.04, https://github.com/Intelligent-Quads/iq_tutorials/blob/master/docs/Installing_Ardupilot_20_04.md
2. Video Tutorial at https://youtu.be/1FpJvUVPxL0

### Steps
1. choose a proper and stable version for the drone according to the hardware that we are going to use.
    - find the hardware at [https://firmware.ardupilot.org/Copter/stable/](https://firmware.ardupilot.org/Copter/stable/)
    - Given Pixhawk5x, check Pixhawk5x/firmware-version.txt
    ```txt
            4.3.3-FIRMWARE_VERSION_TYPE_OFFICIAL
    ```
2. clone a forked Arduploit rep from my github and do not foret adding a star
    ```git
        git clone https://github.com/ZhongmouLi/ardupilot
    ```

3. install dependencies and configure base station by choosing one of the two methods
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
4. "source" Ardupilot (a better explanation is needed here). One of the two ways listed here should be chosen.
    - run this command everytime before using Ardupilot
        ```shell
            cd arduploit
            . ~/.profile
        ```   
    - modify .bashrc
        ```shell
            export PATH=$PATH:$HOME/{where_to_ardupilot}/ardupilot/Tools/autotest 
            export PATH=/usr/lib/ccache:$PATH
        ```
5. there are two ways to get the version for 4.3.3 in the forked Ardupilot.

    It happens that the forked rep does not have all tags/branches up to date and ```git checkout Copter-4.3.3``` can fail.

    - The first way is to find tags for 4.3.3 in master branch.
    
        Solution is upating forked rep with all needed tags from original Ardupilot:
        - add upsteam using Ardupilot
            ```shell
                cd ardupilot
                git remote add upstream git@github.com:ArduPilot/ardupilot.git
            ```
        - get all tags from original Ardupilot
                ```shell
                cd ardupilot
                git fetch upstream
                git fetch upstream --tags
                ```    
        - push all tags to forked rep
                ```shell
                cd ardupilot
                git push --tags origin 
                ```       
    - The sceond way is to get branch 4.3 and switch to tag 4.3.3
        - add upsteam
            ```shell
                cd ardupilot
                git remote add upstream git@github.com:ArduPilot/ardupilot.git
            ```
        - update 
            ```shell
                cd ardupilot
                git fetch upstream
            ```        
        - build a new branch for Copter -4.3 and checkout branch names before at the origianl Ardupilot rep
            ```shell
                cd ardupilot
                git checkout Copter-4.3
            ```   
        - if you use your own forked rep instead of using mine, it is recommended to get this new branch to your rep
            ```shell
                cd ardupilot
                git push origin Copter-4.3
            ```             
    - find the correct version by switching to tag Copter-4.3.3.     
    ```shell
        cd ardupilot
        git checkout Copter-4.3.3
    ```
    then update submodue in arduploit

    ```shell
        cd arduploit
        git submodule update --init --recursive
    ```        

    NOTE: 
    
    
    

6. test if Ardupilot is well installed by runging a STIL

    ```shell
            cd arduploit/ArduCopter
            # for the first time add -w
            sim_vehicle.py -w
    ```
    It is perfectly installed if we can see 
    <figure>
        <img src="8_Arduploit/arduploit_simu_test.png"
            height="300">
    </figure>

    Launching Qgroundcontrol and we can see the version that we choose
    <figure>
        <img src="8_Arduploit/Ardu_sim_Q.png">
    </figure>

## 2. Install Ardupilot firmware on drone
## 2.1 build firmware from installed Ardupilot on computer
1. use Waf to build an ardupliot firmware for the chosen board. Tutorials to use Waf https://github.com/ArduPilot/ardupilot/blob/master/BUILD.md.
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
    
## 2.2 Download Arduploit firemware directly from online sources
1. we can build an Arduploit firmware at https://firmware.ardupilot.org/ choosing
    + drone type
    + board of autoploit
    + **features that are needed**
<figure>
    <img src="8_Arduploit/Custmer_build_Arduploit.png"
         height="200">
</figure>

2. we can find version 4.3. and its corresponding files for Pixhwask5
<figure>
    <img src="8_Arduploit/choose_download_ardupilot_version.png"
         height="200">
</figure>

## 2.3 Upload Ardupilot firmware into autopilot.

## 3 ROS-Gazebo simulation with Ardupilot



### 3.1 Gazebo Garden

### 3.2 Gazebo 11

Video tutorials provided by Intelligent Quads can be found on Youtube [Drone Dev Enviorment Ubuntu 20 04 Update](https://youtu.be/1FpJvUVPxL0)


We follow the steps specified by [Using SITL with legacy versions of Gazebo](https://ardupilot.org/dev/docs/sitl-with-gazebo-legacy.html#sitl-with-gazebo-legacy). 

Given that our development environments are
- Ubunt 20.04
- ROS noetic
- Gazebo 11.12.0

0. install gazebo 11
```shell
    sudo apt-get install gazebo11 libgazebo11-dev
```
1. get source code of arduploit plugins for gazebo 11.X
```shell
    cd where_you_want
    git clone https://github.com/khancyr/ardupilot_gazebo
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