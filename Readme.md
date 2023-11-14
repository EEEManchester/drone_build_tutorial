# Drone tutorial
This tutorial aims to provide guides begining at building a drone from kits and ending at controlling a drone autonomouly with Vicon.

## Main contents
1. [Assembly](1_Assembly.md)
    It introduces the drone kit used in this tutorial and introduce key steps to build it.

2. [Simulation with PX4 and Ardupilot in ROS](2_0_Simulation_ROS.md)
    It explains how to install and configure PX4, ROS and ROS packages for simulation.

    
3. [Setup Simulation for PX4 in Gazebo ](3_Simulation_Gazebo_Control.md)
    It shows how to setup PX4-Gazebo simulation environment and provide some developed packages.

4. Onboard computer setup
    
    It demonstrates steps to add an onboard computer to a drone. It includes how to power it within the power system of Pixhawk and how to enable ROS communication among it, Pixhawk and base station.

    1. Onboard computer
        - [Setup Raspberry Pi as onboard computer](4_Experiment_OnboardComputer_Pi.md)
    2. Onboad computer communicate with autopilot
        - [Setup communication between Pi and Pixhawk](4_Experiment_Communication_Pi_Pixhawk.md)
    3. Onboard computer communicate with base station in ROS through WIFI
        - [Setup ROS communcation between onboard computer and base station through WIFI](4_Experiment_ROS_Communication_Pi_BaseStation.md)

5. [Add more devices to drone in experiment](5_Experiment_Hardware_Setup.md)
    It suggests what to do if more addional devices are to be added to a drone to extend its functions.


6. [Setup and use Vicon system](6_Vicon_Setup_Use.md)
    It gives an idea of how to use a motion capture system for drone experiments.

7. [Use mavros_controller](7_Mavros_Controller.md)
    It explains how the drone control package mavros_controller is designed and what to do to implement it in experiment.

8. [ROS2 and PX4](8_ROS2_PX4.md)
    It aims to move every drone techniques in ROS to ROS2.