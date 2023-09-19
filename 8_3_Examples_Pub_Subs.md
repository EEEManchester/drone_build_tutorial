## 1 Create a simple node in pkg in ROS2

###  1.1 Write C++ scipts to creat a node
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

### 1.2 Edit CMakeLists to build node**
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



### 1.3 Edit package.xml to add dependence
<depend>rclcpp</depend>




### 1.4 Develop Launch file
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
**Note**
Remember everything everying built will be installed, so we need to install the folder launch as well such that ros2 launch can find these files.

In fact, when we can ros2 launch, ros2 run launch files in folder install, not in folder src. It means, everytime we modify launch files, we must rebuild the pkg.

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

### Reference

1. Create a ROS2 Cpp Package, https://roboticsbackend.com/create-a-ros2-cpp-package/
2. Creating a launch file, https://docs.ros.org/en/foxy/Tutorials/Intermediate/Launch/Creating-Launch-Files.html

3. ROS2 - Create a Launch File with XML, https://youtu.be/Le1vx1_KUDQ

4. Write a Minimal ROS2 Cpp Node, https://roboticsbackend.com/write-minimal-ros2-cpp-node/

## 2 Write a publisher in C++
s


