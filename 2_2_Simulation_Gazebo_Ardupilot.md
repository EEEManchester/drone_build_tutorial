
## 1 Build Gazebo environment
### 1.1 Gazebo Garden

### 1.2 Gazebo 11

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

## 2 Link Ardupilot firmware to Gazebo simulator
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
