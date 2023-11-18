# Drone tutorial
This tutorial aims to provide guides begining at building a drone from kits and ending at controlling drones in experiments.

## Main contents

### 1 Simulation

#### 1.1 Simulation for a **single** quadrotor with PX4 and Ardupilot in ROS
It explains how to install and configurate PX4 or Ardupilot, ROS and ROS packages for ROS-Gazebo simulation.

- Single drone with PX4
    - [Set up PX4, ROS and mavros](2_1_Simulation_ROS_PX4.md) shows how to simulate a **single** quadrotor with the **PX4** firmware in Gazebo.
    - [Run ROS-Gazebo simulation for PX4](2_3_Simulation_PX4_Gazebo.md) shows how to simulate a **single** quadrotor with the **PX4** firmware in Gazebo.

- Single drone with Ardupilot
    - [Set up Ardupilot, ROS and mavros](2_2_Simulation_ROS_Ardupilot.md) explains the steps to simulate  a **single** quadrotor with the **Ardupilot** firmware in Gazebo.
    - Run ROS-Gazebo simulation for Ardupilot ##TODO


#### 1.2 Simulation for **multiple** quadrotors with PX4 and Ardupilot in ROS  ## TODO

- Multiple drones with PX4
- Multiple drones with Ardupilot
    

### 2 Experiment preparation

#### 2.1 Assembly drones
1. [Assembly Holybro X500](1_Assembly_X500.md)
    It introduces the drone kit used in this tutorial and introduce key steps to build it.

#### 2.2 Configurate and tune autpilot for manual flight
1. PX4
2. Ardupilot
3. Betaflight

#### 2.3 Onboard computer setup
    
It demonstrates steps to add an onboard computer to a drone. It includes how to power it within the power system of Pixhawk and how to enable ROS communication among it, Pixhawk and base station.

1. Set up onboard computer
    - [Set up Raspberry Pi as onboard computer](4_Experiment_OnboardComputer_Pi.md)
2. Enable communication between onboad computer and autopilot
    - [Set up communication between Pi and Pixhawk with PX4](4_Experiment_Communication_Pi_Pixhawk.md)
3. Enable communication between onboad computer communicate and base station in ROS through WIFI
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
    It suggests what to do if more addional devices are to be added to a drone to extend its functions.

### 5 ROS2 for drones
1. [ROS2 and PX4](8_ROS2_PX4.md)
    It aims to move every drone techniques in ROS to ROS2.