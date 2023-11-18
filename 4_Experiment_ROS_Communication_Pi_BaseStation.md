# ROS communiction through WIFI between onboard computer and base station

## 1 Install ROS and ROS pkgs for onboard computer
### 1.1 Install ROS 
- for team members, please skip this step
- for Ubuntu or Ubuntu Mate, please refoer to [ROS Installation](http://wiki.ros.org/ROS/Installation).

- for Rapsberry Pi OS, 
    -   ROS Melodic is still possible to be installed on Raspberry Pi with Raspbian Buster following a different approach [ROSberryPi/Installing ROS Melodic on the Raspberry Pi](http://wiki.ros.org/ROSberryPi/Installing%20ROS%20Melodic%20on%20the%20Raspberry%20Pi).

    - A tutorial to install Melodic on Rapsberry Pi OS is given [here](https://www.linkedin.com/pulse/easiest-way-install-ros-melodic-raspberrypi-4-shubham-nandi/).  
### 1.2 Install mavros
- for team members, please skip this step
- for others, please ref to Section Simulation_ROS.


## 2 Enable WIFI communication between onboard computer and base station

### 2.1 Set static IP address for onboard computer
##TODO
### 2.1 Set static IP address for base station
##TODO

### 2.3 Set ssh for remote login
Install ssh on both machines
```shell
    sudo apt install openssh-client openssh-server
```
and we ca check the installation by 
<figure>
    <img src="4_Experiment_OnboardComputer_Setup/check_ssh_installation.png">
</figure>


On base station, we can connect to Raspberry Pi with 
```shell
    ssh username@servername
```
where servername can be IP address like 192.168.31.171 and site address like example.com

Lets say our username is drone1 and its pws is 123456.

From base station to connect.
1. We start ssh request
```shell
    ssh drone1@192.168.31.171
```
and entre yes then
<figure>
    <img src="4_Experiment_OnboardComputer_Setup/ssh_request.png"
         alt="drawing" style="width:900px;"/>
</figure>

2. We entre the pwd of the user of sever, i.e. drone1, which should be 123456. 
<figure>
    <img src="4_Experiment_OnboardComputer_Setup/ssh_pwd_user.png"
         alt="drawing" style="width:900px;"/>
</figure>

3. We are now in the server as the user drone1, as you can see a new user name and a new machine name in the terminal.

4. It is not surpised that we dont want to type ip address every time. Since we know the ip address of the Raspberry Pi wont change, it is nature to think can we type something meaningful as long as my machine can understhand my input and link that to the correct ip address.

    Here, we can modify /etc/hosts to enable our machine to do that.

    We give a name for our Raspberry Pi as dronepi1, as
<figure>
    <img src="4_Experiment_OnboardComputer_Setup/ssh_host_name.png"/>
</figure>    

5. Now, we can connect to the Raspberry Pi with drone1@dronepi1
<figure>
    <img src="4_Experiment_OnboardComputer_Setup/ssh_host_connect.png"/>
</figure>    

References on ssh:
1. How to use SSH (to connect to another computer), https://www.youtube.com/watch?v=3bQRaOPns9k&ab_channel=SyntheticEverything

2. https://tuw-cpsg.github.io/tutorials/dagobert-network-setup.html

3. https://www.youtube.com/watch?v=Wlmne44M6fQ&ab_channel=KnowledgeSharingTech

4. https://wangdoc.com/ssh/client

## 3 Set ROS communication through WIFI between onboard computer and base station 

##TODO
### 3.1 time synchrionasation
We are going to use ntp service for synchronisation.
First of all, install ntp by running
```bash
sudo apt install ntp
```
Check if ntp service is on or not
```bash
service --status-all
```
<figure>
    <img src="4_Experiment_OnboardComputer_Setup/ntp_on.png"
         alt="drawing" style="width:700px;"/>
    <figcaption> Ntp service is on </figcaption>
</figure>
and check its status
```bash
sudo systemctl status ntp.service
```
<figure>
    <img src="4_Experiment_OnboardComputer_Setup/ntp_status.png"
         alt="drawing" style="width:700px;"/>
    <figcaption> Pixhawk 5x - Raspberry Pi </figcaption>
</figure>
Check all the servers
```bash
    ntpq -p
```

TODO
### 3.2 ROS communication between Rapsberry Pi and base station