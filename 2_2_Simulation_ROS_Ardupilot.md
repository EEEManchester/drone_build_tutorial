
## 1 Build Gazebo environment
It is suggested to choose one gazebo version between [Gazebo Garden](#1.1-gazebo-garden) and [Gazebo 11](#1.2-gazebo-11)


Main references are
- [Using SITL with Gazebo](https://ardupilot.org/dev/docs/sitl-with-gazebo.html) for Gazebo Garden.
- [Using SITL with legacy versions of Gazebo](https://ardupilot.org/dev/docs/sitl-with-gazebo-legacy.html#sitl-with-gazebo-legacy) for Gazebo 11. 

### 1.1 Gazebo Garden

Install Gazebo Garden following the steps at [Docs/Gazebo Garden-->Binary Installation on Ubuntu](https://gazebosim.org/docs/garden/install_ubuntu), which are
```shell
sudo apt-get update
sudo apt-get install lsb-release wget gnupg
```
and then 
```shell
sudo wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
sudo apt-get update
sudo apt-get install gz-garden
```
To test if the installation is successed, we can run 
```shell
gz sim -v4 -r shapes.sdf
```
and it is OK if we can see
<figure>
        <img src="2_Simulation_ROS_Ardupilot/gz_installed_test.png">
</figure>  

### 1.2 Gazebo 11

Video tutorials provided by Intelligent Quads can be found on Youtube [Drone Dev Enviorment Ubuntu 20 04 Update](https://youtu.be/1FpJvUVPxL0)


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
5. launch a gazebo environment with iris model with iq_sim pkg
    - get source code of iq_sim
    ```shell
    git clone https://github.com/Intelligent-Quads/iq_sim.git
    ```
    - add mode path of iq_sim to gazebo
    ```shell
    echo "GAZEBO_MODEL_PATH=${GAZEBO_MODEL_PATH}:$HOME/catkin_ws/src/iq_sim/models" >> ~/.bashrc
    ```
    - build and resource iq_sim pkg
    - roslaunch gazebo env of iris_arducopter_runway 
    ```shell
        roslaunch iq_sim runway.launch
    ```

## 2 Install and run Ardupilot firmware in simulation
### 2.1 Install Ardupilot
Check Youtube [Drone Dev Enviorment Ubuntu 20 04 Update](https://youtu.be/1FpJvUVPxL0) to install Ardupilot.

Read [Setting up the Build Environment (Linux/Ubuntu)](https://ardupilot.org/dev/docs/building-setup-linux.html#building-setup-linux).

### 2.2 Simulate a single quadrotor with Ardupilot
Run ardupilot firmware
```shell
    cd Ardupilot/ArduCopter
    sim_vehicle.py -v ArduCopter -f gazebo-iris --console
    # OR
    sim_vehicle.py -v ArduCopter --console --map
```
we should find an interface, a council and a terminal.
<figure>
    <img src="8_Arduploit/ardupilot_interface.png"
         height="300">
</figure>

### 3 Enable ROS communication with Ardupilot using mavros
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

Since we commande the drone to switch to guided mode and take off to a height of 5m with
```shell
    mode guided
    arm throttle
    takeoff 5
```
then we check drone state and position in ROS
```shell
    rostopic echo /mavros/state
    rostopic echo /mavros/local_position/pose
```
with the state being guided and position being 5m
<figure>
        <img src="8_Arduploit/mavors_state_local_pose.png"
            height="300">
</figure>   


### 3 Test simulation of Ardupilot in Gazebo and communication using mavros

#### 3.1 Gazebo Garden
1.  run 
    ```shell
        gz sim -v4 -r iris_runway.sdf
    ```

2. run Ardupilot firmware
    ```shell
        cd Ardupilot/ArduCopter
        sim_vehicle.py -v ArduCopter -f gazebo-iris --model JSON --map --console
    ```

3. run mavros to enable communication between Ardupilot and ROS
    ```shell
        roslaunch mavros apm.launch fcu_url:=udp://127.0.0.1:14551@14555
    ```

4. make drone switch to guided mode and take off
In the same terminal of running sim_vehicle.py, we use the following commands to make the drone take off
    ```shell
        mode guided
        arm throttle
        takeoff 5
    ```
We should see the drone take off and hover in Gazebo
<figure>
        <img src="2_Simulation_ROS_Ardupilot/Ardupilot_Gazebo_Garden_Mavros.png"
            height="300">
</figure>  

if we echo rostopics /mavros/state and /mavros/local_position/pose, then we should find
- the drone's mode is guided
- its height is 5m.

#### 3.2 Gazebo 11
1.  run Gazebo envrionment
    ```shell
        gazebo --verbose worlds/iris_arducopter_runway.world
    ```

2. run Ardupilot firmware
    ```shell
        cd Ardupilot/ArduCopter
        ../Tools/autotest/sim_vehicle.py -f gazebo-iris --console --map
    ```

3. -- 4. are the same with Gazebo Garden

    <figure>
        <img src="8_Arduploit/drone_gazebo_takeoff.png"
            height="200">
    </figure>   
