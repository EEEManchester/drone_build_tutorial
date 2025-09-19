1.1 Step 1 Config PX4 to use GPS information and offboard mode
First read prearm,arm and disarm specified by PX4. How can I comment on this: it is not better than shit.

Arming and disarming decides what cases will stop drones. One of the cases is that should a drone be stopped, or disarmed, if it cannot receive RC signals for a certain amount of time.

allow arming drones without RC signal We allow drones armed in offboard modes by setting COM_RCL_EXCEPT=4 like

Explanation of COM_RCL_EXCEPT
Only setting this can we keep our drone armed when there is no RC input.
change timeout parameters Other parameters can be set to allow more time to take actions
COM_OF_LOSS_T = 10
COM_DISARM_LAND =10 
COM_DISARM_LAND = -1 means disable this