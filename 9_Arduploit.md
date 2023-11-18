# Kiss Ardupilot
Arduploit is a great choice for people tired of PX4. Of course, be a nice guy, I should cite someone telling the differences

<figure>
    <img src="8_Arduploit/Arduploit_PX4.png"
         height="250">
</figure>

## 1 Install Ardupilpot on Computer
### Resources
1. Installing Ardupilot and MAVProxy Ubuntu 20.04, https://github.com/Intelligent-Quads/iq_tutorials/blob/master/docs/Installing_Ardupilot_20_04.md
2. Video Tutorial at https://youtu.be/1FpJvUVPxL0

### Steps
1. choose a proper and stable version for the drone according to the hardware that we are going to use.
    - find the hardware at [https://firmware.ardupilot.org/Copter/stable/](https://firmware.ardupilot.org/Copter/stable/)
    - Given Pixhawk5x, check Pixhawk5x/firmware-version.txt
    ```txt
            4.3.3-FIRMWARE_VERSION_TYPE_OFFICIAL
    ```
2. clone a forked Arduploit rep from my github and do not foret adding a star
    ```git
        git clone https://github.com/ZhongmouLi/ardupilot
    ```

3. install dependencies and configure base station by choosing one of the two methods
    - manullay install dependcies
        - packages

            ```shell
            ## install packages
            sudo apt install python-matplotlib python-serial python-wxgtk3.0 python-wxtools python-lxml python-scipy python-opencv ccache gawk python-pip python-pexpect
            ```

            ```shell
            ## install MAVproxy
            sudo pip install future pymavlink MAVProxy
            ```
        - update .bashrc adding
            ```shell
                export PATH=$PATH:$HOME/ardupilot/Tools/autotest
                export PATH=/usr/lib/ccache:$PATH
            ```
    - auto setup dependencies
        - use install-prereqs-ubuntu.sh for ubuntu base station
        ```shell                   
            cd arduploit
            Tools/environment_install/install-prereqs-ubuntu.sh -y
        ```
4. "source" Ardupilot (a better explanation is needed here). One of the two ways listed here should be chosen.
    - run this command everytime before using Ardupilot
        ```shell
            cd arduploit
            . ~/.profile
        ```   
    - modify .bashrc
        ```shell
            export PATH=$PATH:$HOME/{where_to_ardupilot}/ardupilot/Tools/autotest 
            export PATH=/usr/lib/ccache:$PATH
        ```
5. there are two ways to get the version for 4.3.3 in the forked Ardupilot.

    It happens that the forked rep does not have all tags/branches up to date and ```git checkout Copter-4.3.3``` can fail.

    - The first way is to find tags for 4.3.3 in master branch.
    
        Solution is upating forked rep with all needed tags from original Ardupilot:
        - add upsteam using Ardupilot
            ```shell
                cd ardupilot
                git remote add upstream git@github.com:ArduPilot/ardupilot.git
            ```
        - get all tags from original Ardupilot
                ```shell
                cd ardupilot
                git fetch upstream
                git fetch upstream --tags
                ```    
        - push all tags to forked rep
                ```shell
                cd ardupilot
                git push --tags origin 
                ```       
    - The sceond way is to get branch 4.3 and switch to tag 4.3.3
        - add upsteam
            ```shell
                cd ardupilot
                git remote add upstream git@github.com:ArduPilot/ardupilot.git
            ```
        - update 
            ```shell
                cd ardupilot
                git fetch upstream
            ```        
        - build a new branch for Copter -4.3 and checkout branch names before at the origianl Ardupilot rep
            ```shell
                cd ardupilot
                git checkout Copter-4.3
            ```   
        - if you use your own forked rep instead of using mine, it is recommended to get this new branch to your rep
            ```shell
                cd ardupilot
                git push origin Copter-4.3
            ```             
    - find the correct version by switching to tag Copter-4.3.3.     
    ```shell
        cd ardupilot
        git checkout Copter-4.3.3
    ```
    then update submodue in arduploit

    ```shell
        cd arduploit
        git submodule update --init --recursive
    ```        

    NOTE: 
    
    
    

6. test if Ardupilot is well installed by runging a STIL

    ```shell
            cd arduploit/ArduCopter
            # for the first time add -w
            sim_vehicle.py -w
    ```
    It is perfectly installed if we can see 
    <figure>
        <img src="8_Arduploit/arduploit_simu_test.png"
            height="300">
    </figure>

    Launching Qgroundcontrol and we can see the version that we choose
    <figure>
        <img src="8_Arduploit/Ardu_sim_Q.png">
    </figure>








# Source
1. how to install ardupliot
https://github.com/Intelligent-Quads/iq_tutorials/blob/master/docs/Installing_Ardupilot.md
2. https://ardupilot.org/dev/docs/building-setup-linux.html
3. https://discuss.ardupilot.org/t/arducopter-version-check-api/46694
4. build firmware online https://ardupilot.org/copter/docs/common-loading-firmware-onto-chibios-only-boards.html#common-loading-firmware-onto-chibios-only-boards
5. GSoC 2021 - Custom Firmware Builder, https://discuss.ardupilot.org/t/gsoc-2021-custom-firmware-builder/74946