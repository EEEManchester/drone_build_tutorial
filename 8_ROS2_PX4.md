# ROS2 and PX4
This page is to step into the ROS2's world.

Development envrionmen
- Ubuntu 20.04
- ROS2 foxy

## Install ROS2
1. Choose ROS2 version at http://docs.ros.org/
    <figure>
     <img src="8_ROS2/ROS2_Index.png"/>
    </figure>
    Version can be chosen according to OS. For example foxy is recommended for Ubuntu 22.04.

    The steps below are just following guidances given at http://docs.ros.org/en/foxy/Installation/Ubuntu-Install-Debians.html.

2. Get locale supports of UTF-8. 
   
   2.1 Check supoort by typing 
   ```bash
   local
   ```
   2.2 It is supported.
   It means they are already supported if we see 
    <figure>
     <img src="8_ROS2/check_local_support.png"/>
    </figure>
    
    which shows that LANG=en.UTF-8 and UTF-8 support is set alreay.

   2.3 It is not supported and needs to be installed
    Run the follwoing commands in the terminal. 
    
    ```bash
    sudo apt update && sudo apt install locales
    sudo locale-gen en_US en_US.UTF-8
    sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
    export LANG=en_US.UTF-8
    ```

3. Setup Sources for ROS2

    We should set universal apt available for the system. This can be checked by
    
    ```bash
        apt-cache policy | grep universal
    ```
    which results into
        <figure>
        <img src="8_ROS2/universal.png"/>
        </figure>    

    Then, add the ROS2 GPG key with apt.

    ```bash
        sudo apt update && sudo apt install curl -y
        sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
    ```
    and add the rep

    ```bash
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
    ```
4. Install ROS2 packages
   - update and upgrade 
    ```bash
        sudo apt update && sudo apt upgrade
    ```
   - install desktop (Recommended): ROS, RViz, demos, tutorials
    ```bash
        sudo apt install ros-foxy-desktop python3-argcomplete
    ```
    - install development tools like compilers
    ```bash
        sudo apt install ros-dev-tools
    ```
5. Make ROS2 compatible with ROS

    .bashrc needs to be modified in order to source ROS and ROS2.

    - find .bashrc in ~
    - find and comments source commands for ROS, like ROS noetic
        ```bash
        # ROS noetic
        #source /opt/ros/noetic/setup.bash
        #source ~/catkin_ws/devel/setup.bash  
        ```       
    - add source commands for ROS2 such that
        ```bash
        # ROS noetic
        #source /opt/ros/noetic/setup.bash
        #source ~/catkin_ws/devel/setup.bash

        # ROS2 foxy
        source /opt/ros/foxy/setup.bash    
        ```
    - NOTE switching between ROS and ROS2 is done through modifying .bashrc
      - use ROS by commenting source commands for ROS2
        ```bash
        # ROS noetic
        source /opt/ros/noetic/setup.bash
        source ~/catkin_ws/devel/setup.bash

        # ROS2 foxy
        #source /opt/ros/foxy/setup.bash    
        ```
      - use ROS2 by commenting source commands for ROS
        ```bash
        # ROS noetic
        #source /opt/ros/noetic/setup.bash
        #source ~/catkin_ws/devel/setup.bash

        # ROS2 foxy
        source /opt/ros/foxy/setup.bash    
        ```
6. Check ROS2 installation
   
   In a terminal
   ```bash
        ros2 run demo_nodes_cpp talker
   ```
   and in another
   ```bash
        ros2 run demo_nodes_cpp listener
   ```   

   Installation is completed if we can see 
        <figure>
        <img src="8_ROS2/talker_listener.png"/>
        </figure>   

    We can find the rqt_grap by typing rqt_gragh in termainl and 
         <figure>
        <img src="8_ROS2/grapsh_talker_listener.png"/>
        </figure>      
## Structure of ROS2 Foxy
### Why move to ROS2 from ROS
| | ROS2   |      ROS      |
|:----: |:----: |:----: |
|Design target | For Industry |   For Academia |
|Design origin | For multi robots |   For single robot |
|Platform | Multi-platform |   Linux |
|Real-time | Yes |   No |
|Sensor   | Small processors |     Complex robots and sensors   | 
|Network environment | Unreliable network is OK|  Perfect network is perfered(ideally on the same computer)| 
| Others| Deterministic behavior| Lot of computational power| 
| | Error recovery| | 

### Differences in structues of ROS and ROS2

<img src="8_ROS2/structures_ROS_ROS2.png" width="600"/>

Key difference is ROS 2 has no ros master.

ROS 2 allows to completely create a distributed system.

**API differences**

<img src="8_ROS2/API_structure.png" width="600"/>

- c++ and python in ROS 2 are united by using a common client library.
  - roscpp and rospy are independent, some functions exsit only for one or the other. It is possible to come across that the needed features only are available in rospy, while your project uses roscpp.
  - rclcpp and rclpy are much more simular. Both of them depend on rcl and providing the binding: all functions are implemented in rcl. 
- ROS 2 enables developers using other language to expereince a simular API. It is possible to use libraries in other languages like java as long as a binding between rcl ane them are developed.
- A new feature once is realsed, it will be available for all languages in ROS2. Only a binding is needed. By contrast, in ROS, 

Supports for Python and C++
- ROS 2 is only for Python 3.
- ROS 2 supports C++ 11 and 14 by default, C++ 17 is also on the roadmap.

**Workspace overlays**
<img src="8_ROS2/ROS2_overlays.png" width="600"/>
We can overlay workspace and pkgs.


### Key concepts of ROS2
#### Node
A node can send and receive data from other nodes via topics, services, actions, or parameters. Usually, a node should be responible for for a single and modular purpose like controlling the wheel motors and publishing the sensor data from a laser range-finder.

<img src="8_ROS2/Nodes-TopicandService.gif" width="600"/>

**Difference in concept from ROS**

One executable in ROS2 can contain several nodes:
- ROS 1: the node is the entire executable
- ROS 2: several nodes in the same executable (classes)

Because of this key difference, ROS2 is very suitable for a multi-robot system. ROS2 allows one executable, or package, to be programmed for one type of task wiht each node is in charge of one individual fucntion or module. 

In contrast, one robot may need multiple executables/nodes. 

A node in ROS2 is a class that can be:
- Compiled, run or stopped independently
- Written in different languages (C++ / Python3)

### ROS bridge 


## Workspace Configuration for ROS2
In ROS2, ament is the new building system, and on top of that we get the colcon command line tool.

However, in ROS, catkin is the building system that combines CMake macros and Python scripts on top of CMake's normal workflow. That is why we use CMakeLists.txt.

To better understand, we use ROS as a refernce
- colcon like catkin tools, provide commands to create, build and test pkgs,
- ament is iterated on catkin from ROS.

### Configuration for colcon
Three tools are essential for ROS2:
- ROS2, itself;
- colcon as build tools.

We need colcon to build and manage pkgs developed in ROS2. Workspace is where these pkgs are located. In this case, we create the workspace as the folder *ros2_ws* by

```bash
    cd ~
    mkdir ros2_ws
    cd ros2_ws && mkdir src
```
where
- *ros2_ws* is the workspace in which we use build pkgs
- *ros2_ws/src* is where the built pkgs

1. colcon tools to build ROS2 pkgs
    Install colcon
    ```bash
        sudo apt install python3-colcon-common-extensions
    ```
2. Enable auto completation of colcon    
   -   check if ```colcon-argcomplete.bash``` exisits in 
    ```bash
    cd /usr/share/colcon_argcomplete/
    ``` 
    -  modify ~/.bashrc to source ```colcon-argcomplete.bash``` whenever a new terminal is called by adding the following command
    ```bash
    source /usr/share/colcon_argcomplete/colcon-argcomplete.bash
    ```  
3. Enable the searching availablity of pkgs in *ros2_ws* by adding the following command to ~/.bashrc
    ```bash
    source ~/ros2_ws/install/setup.bash
    ```  
Finally, we have added three lines into ~/.bashrc
```bash
    # ROS2 foxy
    source /opt/ros/foxy/setup.bash
    # ros2 workspace
    source ~/ros2_ws/install/setup.bash
    # auto completation of colcon
    source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash
```  
### colcon commands for ROS2

| | ROS2   |      ROS      |
|:----: |:--------: |:--------: |
|Build pkgs | colcon build | catkin build |
|Create pkg | ros2 pkg create <pkg_name> --build-type ament_cmake | catkin create pkg  <pkg_name>|
|| ros2 pkg create <pkg_name> --build-type ament_python| |
|Build certain pkg| colcon build --packages-select  <pkg_name> | catkin build <pkg_name> |
|Run pkg | ros2 run <pkg_name> <exe_name>  | ros run <pkg_name> <exe_name> |
|Find exe | ros2 pkg prefix <pkg_name> | ros pkg find <pkg_name> |


## Pkg
A package is a basic organizational unit for your ROS2. 

### Simple example to create pkg
Steps in details to follow "how to create a hello world" C++ pkg in ROS 2 https://docs.ros.org/en/foxy/Tutorials/Beginner-Client-Libraries/Creating-Your-First-ROS2-Package.html.

Step 1: create a hello world c++ pkg

```shell
    cd ros2_ws/src
    ros2 pkg create --build-type ament_cmake --node-name hello_node hello_package
```
we should see

<img src="8_ROS2/colcon_create_pkg.png" width="600"/>

Step 2: build hello world pkg
```shell
    cd ros2_ws/
    colcon build --packages-select hello_package
```
as

<img src="8_ROS2/colcon_build_pkg.png" width="600"/>

Step 3: source for new pkg

```shell
    cd ros2_ws/
    source install/local_setup.bash
```
<img src="8_ROS2/colcon_source.png" width="600"/>

Sourcing the local_setup of the overlay will only add the packages available in the overlay to your environment. setup sources the overlay as well as the underlay it was created in, allowing you to utilize both workspaces.

So, sourcing your main ROS 2 installation’s setup and then the ros2_ws overlay’s local_setup, like you just did, is the same as just sourcing ros2_ws’s setup, because that includes the environment of its underlay.

Step 4: run pkg
```shell
    ros2 run hello_package hello_node
```
<img src="8_ROS2/colcon_pkg_run.png" width="600"/>


Refereces:
1. ROS2 Basics #3 - Understanding ROS2 Packages and Workspace https://youtu.be/lN4_-l7FCWk.
2. ROS2 Tutorials #4: How to create a ROS2 Package for C++ [NEW], https://youtu.be/C2bKwFJ5HEY.
3. what is the use of --symlink-install in ROS2 colcon build?, https://answers.ros.org/question/371822/what-is-the-use-of-symlink-install-in-ros2-colcon-build/


```html
    my_package/
        CMakeLists.txt
        include/my_package/
        package.xml
        src/
        launch/
```
where
- CMakeLists.txt file that describes how to build the code within the package
- include/<package_name> directory containing the public headers for the package
- package.xml file containing meta information about the package
- src directory containing the source code for the package

### CMakeLists for ament

```make
    cmake_minimum_required(VERSION 3.5)
    project(my_project)

    ament_package()
```


## Publisher and Subscriber

### Create a simple node in pkg in ROS2

**Step 1. Write C++ scipts to creat a node**
```c++
// 1. get h file for using c++ in ROS2
#include "rclcpp/rclcpp.hpp"

int main(int argc, char **argv)
{
    // 2. initiate ROS2 communications with rclcpp::init()
    rclcpp::init(argc, argv);
    // 3. create a node 
    auto node = std::make_shared<rclcpp::Node>("my_node_name");
    // 3. make node spin
    rclcpp::spin(node);
    // 4. will stop ROS2 communications
    rclcpp::shutdown();
    return 0;
}
```
Two ways to create a node
1. ```auto node = std::make_shared<rclcpp::Node>("my_node_name");```
   - It uses a shared pointer to create an instance of class ```rclcpp::Node```. The name of node is *my_node_name*. 
   - It is a good choice for complex node classes as it can pass additional arguments to the constructor of the ```rclcpp::Node``` class.
2. ```auto node = rclcpp::Node::make_shared("my_node_name");```
   - It calles a method of namespace ```rclcpp::Node``` to create a shared pointer to an instance.
   - It is an efficient way to creat a simple node.

**Step 2. Edit CMakeLists to build node**
Since we use the binding, rclcpp, to interact with rcl, linking rclcpp to our node is necessary. 


```cmake
cmake_minimum_required(VERSION 3.5)
project(hello_package)

find_package(ament_cmake REQUIRED)

#------------TO ADD------------#
find_package(rclcpp REQUIRED) #like binding for rcl

add_executable(hello_node src/hello_node.cpp)

# link rclcpp for node
ament_target_dependencies(hello_node rclcpp) 
# or target_link_libraries(hello_node rclcpp) 
# choose ament_target_dependencies if use overlay workspaces 

#------------TO ADD------------#

install(TARGETS hello_node
  DESTINATION lib/${PROJECT_NAME})

```
More detials about understanding cmake commands can be found in cmake tutorial of the author. Here we only explain key ideas of commands used here. Two main commands are 
- ```find_package(rclcpp REQUIRED)``` to locate lib rclcpp
- ```ament_target_dependencies(hello_node rclcpp) ``` to link rclcpp with our node (exe).

Referces
1. ament_cmake user documentation https://docs.ros.org/en/foxy/How-To-Guides/Ament-CMake-Documentation.html



**Step 3. Edit package.xml to add dependence**
<depend>rclcpp</depend>




**Step 4. Develop Launch file**
Three methods are available to create launch fiels: Python scripts, XML, YAML.

XML files are used in ROS and no addiontal efforts are needed.

Recall the strucre of a pkg
```
    my_package/
        CMakeLists.txt
        include/my_package/
        package.xml
        src/
        launch/
```
A launch file with extention *name.launch.xml* must be created in folder launch.
```shell
   cd my_package/launch
   touch name.launch.xml
```
Edit name.launch.xml to launch an exe from a pkg as

```xml
<launch>
    <!-- call exe hello_node from pkg hello_package-->
    <node pkg="hello_package" exec="hello_node"/>
</launch>
```

Remember everything everying built will be installed, so we need to install the folder launch as well such that ros2 launch can find these files.

In CMakeLists.txt, we add install commands as 

```cmake
# install launch folder so ros2 launch can find launch files 
install(DIRECTORY
        launch
        DESTINATION share/${PROJECT_NAME}/
      )
```

It is also suggested to add ```<exec_depend>ros2launch</exec_depend>``` in package.xml.

Here is how to call hello_node from hello_package with launch file say_hello.launch.xml.

```shell
    # go to ros2_ws
    cd ros2_ws
    # build pkg
    colcon build packages-select hello_package
    # source 
    source install/local_setup.bash
    # call launch command
    ros2 launch hello_package say_hello.launch.xml
```

1. Creating a launch file, https://docs.ros.org/en/foxy/Tutorials/Intermediate/Launch/Creating-Launch-Files.html

2. ROS2 - Create a Launch File with XML, https://youtu.be/Le1vx1_KUDQ
### Write a publisher in C++



## Reference
1. Install ROS2 Along With ROS1 | Foxy | Noetic | Simple ROS2 Tutorial | 2022 https://www.youtube.com/watch?v=CtW7Cqzeb8o&ab_channel=HarshMittal
2. Olivier Kermorgant, http://pagesperso.ls2n.fr/~kermorgant-o/teaching.html#C++_programming
3. Using colcon to build packages https://docs.ros.org/en/foxy/Tutorials/Beginner-Client-Libraries/Colcon-Tutorial.html?highlight=colcon