## 1 DDS for Ardupilot and PX4


## 2 Install libs and pkgs for Ardupilot
Main reference is [ROS 2](https://ardupilot.org/dev/docs/ros2.html).


https://ardupilot.org/dev/docs/ros2.html


### 2.2 mavros for ros2
[Executing commands on Pixhawk with ArduPilot via MAVROS2](https://github.com/mavlink/mavros/issues/1863)
[How to use mavros2](https://github.com/mavlink/mavros/issues/1718)
[How to install mavros inside the container with ros2 humble preinstalled](https://github.com/mavlink/mavros/issues/1864)
[MAVROS2: RC-Override in ROS2 Foxy - Equivalent of rosrun mavros mavparam set SYSID_MYGCS 1](https://github.com/mavlink/mavros/issues/1866)
[basic ros2 topic run](https://github.com/mavlink/mavros/issues/1902)


read those

https://github.com/mavlink/mavros/issues/815

https://github.com/mavlink/mavros/issues/1469

https://github.com/mavlink/mavros/issues/1423

https://github.com/mavlink/mavros/issues/1423

https://github.com/mavlink/mavros/issues/1564

https://github.com/mavlink/mavros/issues/1793

https://github.com/mavlink/mavros/issues/1582

user docker
https://github.com/mavlink/mavros/issues/1864

https://hub.docker.com/r/rockstarartist/mavros2

MAvlink
https://zhuanlan.zhihu.com/p/415266156


## 3. Set ROS2 for PX4
Main reference is [ROS 2 User Guide](https://docs.px4.io/main/en/ros/ros2_comm.html#foxy).

```shell
make px4_sitl gz_x500
```

```shell
MicroXRCEAgent udp4 -p 8888
```

```shell
# use ament_garge for ros2 pkgs
ament_target_dependencies(frame_transforms geometry_msgs sensor_msgs)
# use targe_link for pkg Eigen3
target_link_libraries(frame_transforms Eigen3::Eigen)
```