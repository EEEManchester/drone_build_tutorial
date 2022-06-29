# Note to set up vicon system for drone autonoumous flight
## Environment
1. Vicon system
    - version: 3.6.1
    - location: REEG, UoM
2. base station
    - OS Ubuntu 20.04 
    - ROS noetic
    - ROS package: vicon_bridge
3. drone onborad computer
    - Rapsberry PI 4B+
    - OS: Raspberry OS (debian)
## Start Vicon system
1. Satart Vicon tracker
2. Calibrate system
    - green lights mean OK
    - put bar on the ground
3. Set origin
    - Set volume origin
    - Put the bar and click Start and Set
    - **Donot touch cage or gate to impact cameras**. Once the light is blinking, redo calibration.
    - Layout should be checked visually
## Build rigid body in Vicon
1. See markers in cicon
2. Choose Objects tag and select all markers
3. Name object and create
4. Select object in Object Tag
5. Go to Recording Tag and name Trial Name.
6. Go Online->Click Start in Show parameters.
7. Genearate record data
    - Go Offline-> Playback and load trial
    - Export CSV
        - angle between qua or helical
        - Output is capture shared folder
        - RX, RY, RZ are Euler angles and TX, TY and TZ are translation
8. Online measurement:
    - check vicon_bridge        
## Get pose information from Vicon    
1. download and build ros package *vicon_bridge*
2. connnect pc to hub throught a internet port
3. configure Enthernet mannually 192.168.10.XX
4. go live and choose object
5. 
