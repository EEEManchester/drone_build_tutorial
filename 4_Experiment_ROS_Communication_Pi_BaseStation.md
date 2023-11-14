

## Step 6. WIFI communication between Raspberry Pi and base station

### Step 6.1 static IP address for base station and drone

### Step 6.2 ssh setup

### Step 6.3 time synchrionasation
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
## Step 6. ROS communication between Rapsberry Pi and base stationdf