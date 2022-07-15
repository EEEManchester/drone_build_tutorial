# Run Px4-gazebo-ROS simluation 
Simulation is to test our methods to robots in a safe way and help debug before real-time experiments.

## Table of contents
- [Run Px4-gazebo-ROS simluation](#run-px4-gazebo-ros-simluation)
  - [Table of contents](#table-of-contents)
  - [Step 1 Change some parameters of PX4s](#step-1-change-some-parameters-of-px4s)
  - [Step 2 Drone controller library](#step-2-drone-controller-library)
  - [Step 3 Papare simulation](#step-3-papare-simulation)
  - [Step 4 Test algoritms in PX4-Gazebo-ROS simulation](#step-4-test-algoritms-in-px4-gazebo-ros-simulation)
  
Here, we use PX4-Gazebo to test auto flights. PX4 provides an *Offboard* mode for auto flights that allow onboard computers to take control of drones. 

## Step 1 Change some parameters of PX4s
First read prearm,arm and disarm specified by [PX4](https://docs.px4.io/master/en/advanced_config/prearm_arm_disarm.html). How can I comment on this: it is not better than shit.

Arming and disarming decides what cases will stop drones. One of the cases is that should a drone be stoped, or disarmed, if it cannot receive RC signals for a certain amount of time.

1. allow arming drones without RC signal
We allow drones armed in offboard modes by setting ```COM_RCL_EXCEPT=4``` like 
<figure>
    <img src="3_Simulation_Run/COM_RCL_EXCEPT.png"
         height="500">
    <figcaption>Explainnation of COM_RCL_EXCEPT</figcaption>
</figure>
Only setting this can we keep our drone armed when there is no RC input.


2.  change timeout parameters
Other paramerts can be set to allow more time to take actions

```bash
COM_OF_LOSS_T = 10
COM_DISARM_LAND =10
```
## Step 2 Drone controller library
There are serverial libraries developed for PX4 drones.

Here are some good reps:
-  Jaeyoung-Lim/mavros_controllers, https://github.com/Jaeyoung-Lim/mavros_controllers
-  uzh-rpg/rpg_quadrotor_control, https://github.com/uzh-rpg/rpg_quadrotor_control

## Step 3 Papare simulation
1. start simulation and visulisation in Gazebo 
```
roslaunch px4 posix_sitl.launch
```
2. call mavros to enable communication between PX4 and PC
```
roslaunch mavros px4.launch fcu_url:="udp://:14540@127.0.0.1:14557"
```
3. apply controller, for instance  geometric_controller
```
roslaunch geometric_controller sitl_trajectory_track_circle.launch
```
Note: check if controllers to be run already call mavros or not.

## Step 4 Test algoritms in PX4-Gazebo-ROS simulation
TO DO