# Drone tutorial
This tutorial aims to provide guides on building a drone from kits and ending at controlling drones in experiments.

## Main contents

### 1 Simulation

#### 1.1 Simulation for a **single** quadrotor with PX4 and Ardupilot in ROS
It explains how to install and configure PX4 or Ardupilot, ROS and ROS packages for ROS-Gazebo simulation.

- Single drone with PX4
    - [Set up PX4, ROS and mavros](2_1_Simulation_ROS_PX4.md) shows how to simulate a **single** quadrotor with the **PX4** firmware in Gazebo.
    - [Run controller in ROS-Gazebo simulation for PX4](2_3_Simulation_PX4_Gazebo.md) demonstrates how to use a **controller** in ROS to controller a **single** quadrotor with the **PX4** firmware in Gazebo.

- Single drone with Ardupilot
    - [Set up Ardupilot, ROS and mavros](2_2_Simulation_ROS_Ardupilot.md) explains the steps to simulate  a **single** quadrotor with the **Ardupilot** firmware in Gazebo.
    - [Run controller in ROS-Gazebo simulation for Ardupilot] ##TODO


#### 1.2 Simulation for **multiple** quadrotors with PX4 and Ardupilot in ROS  ##TODO

- Multiple drones with PX4
- Multiple drones with Ardupilot
    

### 2 Experiment preparation

#### 2.1 Assembly drones
1. [Build Holybro X500 kit](2_1_X500_Pixhawk5.md)
2. [Build TransTEC Lightning X Lite with Kakute ](2_2_LightningXLite_Kakute.md)
    - Ardupilot
    - Chassis TransTEC Lightning X Lite
    - Motor FPV 致盈EX2306 PLUS [site in Taobao](https://item.taobao.com/item.htm?spm=a1z10.5-c-s.w4002-22611654657.27.52b858176s1EdF&id=634695941707)
    - ESC:
        - [Tekko32 F4 Metal 4in1 65A ESC (65A)](https://holybro.com/collections/fpv-esc/products/tekko32-f4-metal-4in1-65a-esc-65a)
        - [HAKRC 3260A ESC BLHeli-32 ](https://item.taobao.com/item.htm?spm=a1z10.5-c-s.w4002-22611654657.32.193244beujIlvo&id=624599427940)
    - Autopilot: - Kakute H7 v1.3 [site in Taobo](https://item.taobao.com/item.htm?spm=a1z0d.6639537/tb.1997196601.28.56917484ySIhA5&id=684452325988)     
3. [Build TransTEC Lightning X Lite with Aocoda](2_3_LightningXLite_Aocoda.md)
    - BetaFlight
    - Chassis TransTEC Lightning X Lite
    - Motor FPV 致盈EX2306 PLUS [site in Taobao](https://item.taobao.com/item.htm?spm=a1z10.5-c-s.w4002-22611654657.27.52b858176s1EdF&id=634695941707)
    - ESC: Aocoda 60A 4 in 1 [site in Taobao](https://item.taobao.com/item.htm?spm=a1z0d.6639537/tb.1997196601.4.55627484xw5sv5&id=682898024012)
    - Autopilot: - Aocoda RC H743 [site in Taobo](https://item.taobao.com/item.htm?spm=a1z0d.6639537/tb.1997196601.4.55627484xUOMZu&id=679995875558)     

#### 2.2 Configure and tune autopilot for manual flight
1. PX4
2. [Ardupilot](2_4_Config_Ardupilot.md)
3. [Betaflight](2_5_Config_BetaFlight.md)

#### 2.3 Onboard computer setup
    
It demonstrates steps to add an onboard computer to a drone. It includes how to power it within the power system of Pixhawk and how to enable ROS communication among it, Pixhawk and base station.

1. Set up onboard computer
    - [Set up Raspberry Pi as onboard computer](4_Experiment_OnboardComputer_Pi.md)
2. Enable communication between onboad computer and autopilot
    - [Set up communication between Pi and Pixhawk with PX4](4_Experiment_Communication_Pi_Pixhawk.md)
3. Enable communication between onboad computer and base station in ROS through WIFI
    - [Set up ROS communcation between onboard computer and base station through WIFI](4_Experiment_ROS_Communication_Pi_BaseStation.md)

### 3 Drone controllers
1. [Use mavros_controller](7_Mavros_Controller.md)
    It explains how the drone control package mavros_controller is designed and what to do to implement it in experiment.

### 4 Experiment in cases
#### 4.1 Indoor flights with VIcon 
1. [Set up and use Vicon system](6_Vicon_Setup_Use.md)
    It gives an idea of how to use a motion capture system for drone experiments.



#### 4.2 Add functional payloads and sensors
1. [Add more devices to drone in experiment](5_Experiment_Hardware_Setup.md)
    It suggests what to do if more additional devices are to be added to a drone to extend its functions.

### 5 ROS2 for drones
1. [ROS2 and PX4](8_ROS2_PX4.md)
    It aims to move every drone techniques in ROS to ROS2.