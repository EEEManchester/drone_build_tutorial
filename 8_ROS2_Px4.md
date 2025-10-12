# PX4 and ROS2
Platfrom and Env
- PX4 V1.15.4
- OS Ubuntu 22
- ROS2 humble

## ROS2 topics of PX4
A single PX4 with the help of xRACE will publish and subscribe to the following topics
```bash
mconros2@Robot:~/ros2_ws$ ros2 topic list
    /fmu/in/actuator_motors
    /fmu/in/actuator_servos
    /fmu/in/arming_check_reply
    /fmu/in/aux_global_position
    /fmu/in/config_control_setpoints
    /fmu/in/config_overrides_request
    /fmu/in/differential_drive_setpoint
    /fmu/in/goto_setpoint
    /fmu/in/manual_control_input
    /fmu/in/message_format_request
    /fmu/in/mode_completed
    /fmu/in/obstacle_distance
    /fmu/in/offboard_control_mode
    /fmu/in/onboard_computer_status
    /fmu/in/register_ext_component_request
    /fmu/in/sensor_optical_flow
    /fmu/in/telemetry_status
    /fmu/in/trajectory_setpoint
    /fmu/in/unregister_ext_component
    /fmu/in/vehicle_attitude_setpoint
    /fmu/in/vehicle_command
    /fmu/in/vehicle_command_mode_executor
    /fmu/in/vehicle_mocap_odometry
    /fmu/in/vehicle_rates_setpoint
    /fmu/in/vehicle_thrust_setpoint
    /fmu/in/vehicle_torque_setpoint
    /fmu/in/vehicle_trajectory_bezier
    /fmu/in/vehicle_trajectory_waypoint
    /fmu/in/vehicle_visual_odometry
    /fmu/out/battery_status
    /fmu/out/estimator_status_flags
    /fmu/out/failsafe_flags
    /fmu/out/manual_control_setpoint
    /fmu/out/position_setpoint_triplet
    /fmu/out/sensor_combined
    /fmu/out/timesync_status
    /fmu/out/vehicle_attitude
    /fmu/out/vehicle_control_mode
    /fmu/out/vehicle_global_position
    /fmu/out/vehicle_gps_position
    /fmu/out/vehicle_local_position
    /fmu/out/vehicle_odometry
    /fmu/out/vehicle_status
    /parameter_events
    /rosout
```
Any topic with ```out``` is published by PX4, and those with ```in``` are subscribed by PX4.

### Vechile status
```/fmu/out/vehicle_status``` is a message type defined by PX4 that summaries status information of the vehicle
```bash
mconros2@Robot:~/ros2_ws$ ros2 topic info /fmu/out/vehicle_status
Type: px4_msgs/msg/VehicleStatus
Publisher count: 1
Subscription count: 0
```

```yaml

mconros2@Robot:~/ros2_ws$ ros2 interface show px4_msgs/msg/VehicleStatus
# Encodes the system state of the vehicle published by commander

uint64 timestamp # time since system start (microseconds)

uint64 armed_time # Arming timestamp (microseconds)
uint64 takeoff_time # Takeoff timestamp (microseconds)

uint8 arming_state
uint8 ARMING_STATE_DISARMED = 1
uint8 ARMING_STATE_ARMED    = 2

uint8 latest_arming_reason
uint8 latest_disarming_reason
uint8 ARM_DISARM_REASON_TRANSITION_TO_STANDBY = 0
uint8 ARM_DISARM_REASON_RC_STICK = 1
uint8 ARM_DISARM_REASON_RC_SWITCH = 2
uint8 ARM_DISARM_REASON_COMMAND_INTERNAL = 3
uint8 ARM_DISARM_REASON_COMMAND_EXTERNAL = 4
uint8 ARM_DISARM_REASON_MISSION_START = 5
uint8 ARM_DISARM_REASON_SAFETY_BUTTON = 6
uint8 ARM_DISARM_REASON_AUTO_DISARM_LAND = 7
uint8 ARM_DISARM_REASON_AUTO_DISARM_PREFLIGHT = 8
uint8 ARM_DISARM_REASON_KILL_SWITCH = 9
uint8 ARM_DISARM_REASON_LOCKDOWN = 10
uint8 ARM_DISARM_REASON_FAILURE_DETECTOR = 11
uint8 ARM_DISARM_REASON_SHUTDOWN = 12
uint8 ARM_DISARM_REASON_UNIT_TEST = 13

uint64 nav_state_timestamp # time when current nav_state activated

uint8 nav_state_user_intention                  # Mode that the user selected (might be different from nav_state in a failsafe situation)

uint8 nav_state                                 # Currently active mode
uint8 NAVIGATION_STATE_MANUAL = 0               # Manual mode
uint8 NAVIGATION_STATE_ALTCTL = 1               # Altitude control mode
uint8 NAVIGATION_STATE_POSCTL = 2               # Position control mode
uint8 NAVIGATION_STATE_AUTO_MISSION = 3         # Auto mission mode
uint8 NAVIGATION_STATE_AUTO_LOITER = 4          # Auto loiter mode
uint8 NAVIGATION_STATE_AUTO_RTL = 5             # Auto return to launch mode
uint8 NAVIGATION_STATE_POSITION_SLOW = 6
uint8 NAVIGATION_STATE_FREE5 = 7
uint8 NAVIGATION_STATE_FREE4 = 8
uint8 NAVIGATION_STATE_FREE3 = 9
uint8 NAVIGATION_STATE_ACRO = 10                # Acro mode
uint8 NAVIGATION_STATE_FREE2 = 11
uint8 NAVIGATION_STATE_DESCEND = 12             # Descend mode (no position control)
uint8 NAVIGATION_STATE_TERMINATION = 13         # Termination mode
uint8 NAVIGATION_STATE_OFFBOARD = 14
uint8 NAVIGATION_STATE_STAB = 15                # Stabilized mode
uint8 NAVIGATION_STATE_FREE1 = 16
uint8 NAVIGATION_STATE_AUTO_TAKEOFF = 17        # Takeoff
uint8 NAVIGATION_STATE_AUTO_LAND = 18           # Land
uint8 NAVIGATION_STATE_AUTO_FOLLOW_TARGET = 19  # Auto Follow
uint8 NAVIGATION_STATE_AUTO_PRECLAND = 20       # Precision land with landing target
uint8 NAVIGATION_STATE_ORBIT = 21               # Orbit in a circle
uint8 NAVIGATION_STATE_AUTO_VTOL_TAKEOFF = 22   # Takeoff, transition, establish loiter
uint8 NAVIGATION_STATE_EXTERNAL1 = 23
uint8 NAVIGATION_STATE_EXTERNAL2 = 24
uint8 NAVIGATION_STATE_EXTERNAL3 = 25
uint8 NAVIGATION_STATE_EXTERNAL4 = 26
uint8 NAVIGATION_STATE_EXTERNAL5 = 27
uint8 NAVIGATION_STATE_EXTERNAL6 = 28
uint8 NAVIGATION_STATE_EXTERNAL7 = 29
uint8 NAVIGATION_STATE_EXTERNAL8 = 30
uint8 NAVIGATION_STATE_MAX = 31

uint8 executor_in_charge                        # Current mode executor in charge (0=Autopilot)

uint32 valid_nav_states_mask                    # Bitmask for all valid nav_state values
uint32 can_set_nav_states_mask                  # Bitmask for all modes that a user can select

# Bitmask of detected failures
uint16 failure_detector_status
uint16 FAILURE_NONE = 0
uint16 FAILURE_ROLL = 1              # (1 << 0)
uint16 FAILURE_PITCH = 2             # (1 << 1)
uint16 FAILURE_ALT = 4               # (1 << 2)
uint16 FAILURE_EXT = 8               # (1 << 3)
uint16 FAILURE_ARM_ESC = 16          # (1 << 4)
uint16 FAILURE_BATTERY = 32          # (1 << 5)
uint16 FAILURE_IMBALANCED_PROP = 64  # (1 << 6)
uint16 FAILURE_MOTOR = 128           # (1 << 7)

uint8 hil_state
uint8 HIL_STATE_OFF = 0
uint8 HIL_STATE_ON = 1

# If it's a VTOL, then the value will be VEHICLE_TYPE_ROTARY_WING while flying as a multicopter, and VEHICLE_TYPE_FIXED_WING when flying as a fixed-wing
uint8 vehicle_type
uint8 VEHICLE_TYPE_UNKNOWN = 0
uint8 VEHICLE_TYPE_ROTARY_WING = 1
uint8 VEHICLE_TYPE_FIXED_WING = 2
uint8 VEHICLE_TYPE_ROVER = 3
uint8 VEHICLE_TYPE_AIRSHIP = 4

uint8 FAILSAFE_DEFER_STATE_DISABLED = 0
uint8 FAILSAFE_DEFER_STATE_ENABLED = 1
uint8 FAILSAFE_DEFER_STATE_WOULD_FAILSAFE = 2 # Failsafes deferred, but would trigger a failsafe

bool failsafe # true if system is in failsafe state (e.g.:RTL, Hover, Terminate, ...)
bool failsafe_and_user_took_over # true if system is in failsafe state but the user took over control
uint8 failsafe_defer_state # one of FAILSAFE_DEFER_STATE_*

# Link loss
bool gcs_connection_lost              # datalink to GCS lost
uint8 gcs_connection_lost_counter     # counts unique GCS connection lost events
bool high_latency_data_link_lost # Set to true if the high latency data link (eg. RockBlock Iridium 9603 telemetry module) is lost

# VTOL flags
bool is_vtol             # True if the system is VTOL capable
bool is_vtol_tailsitter  # True if the system performs a 90° pitch down rotation during transition from MC to FW
bool in_transition_mode  # True if VTOL is doing a transition
bool in_transition_to_fw # True if VTOL is doing a transition from MC to FW

# MAVLink identification
uint8 system_type  # system type, contains mavlink MAV_TYPE
uint8 system_id	   # system id, contains MAVLink's system ID field
uint8 component_id # subsystem / component id, contains MAVLink's component ID field

bool safety_button_available # Set to true if a safety button is connected
bool safety_off # Set to true if safety is off

bool power_input_valid                            # set if input power is valid
bool usb_connected                                # set to true (never cleared) once telemetry received from usb link

bool open_drone_id_system_present
bool open_drone_id_system_healthy

bool parachute_system_present
bool parachute_system_healthy

bool avoidance_system_required                    # Set to true if avoidance system is enabled via COM_OBS_AVOID parameter
bool avoidance_system_valid                       # Status of the obstacle avoidance system

bool rc_calibration_in_progress
bool calibration_enabled

bool pre_flight_checks_pass		# true if all checks necessary to arm pass

```

If we echo it, we will obtain 
```yaml
mconros2@Robot:~/ros2_ws$ ros2 topic echo --once /fmu/out/vehicle_status
timestamp: 1749663071364729
armed_time: 0
takeoff_time: 0
arming_state: 1
latest_arming_reason: 0
latest_disarming_reason: 0
nav_state_timestamp: 128000
nav_state_user_intention: 4
nav_state: 4
executor_in_charge: 0
valid_nav_states_mask: 2147411071
can_set_nav_states_mask: 8307839
failure_detector_status: 0
hil_state: 0
vehicle_type: 1
failsafe: false
failsafe_and_user_took_over: false
failsafe_defer_state: 0
gcs_connection_lost: true
gcs_connection_lost_counter: 0
high_latency_data_link_lost: false
is_vtol: false
is_vtol_tailsitter: false
in_transition_mode: false
in_transition_to_fw: false
system_type: 2
system_id: 1
component_id: 1
safety_button_available: true
safety_off: true
power_input_valid: true
usb_connected: false
open_drone_id_system_present: false
open_drone_id_system_healthy: false
parachute_system_present: false
parachute_system_healthy: false
avoidance_system_required: false
avoidance_system_valid: false
rc_calibration_in_progress: false
calibration_enabled: false
pre_flight_checks_pass: true
---
```


### Vechile flight mode
The topic ```/fmu/out/vehicle_control_mode``` shows the current flight mode, like manual, offboard (controlled by an obboard computer), of the vehicle.
```yaml
mconros2@Robot:~/ros2_ws$ ros2 interface show px4_msgs/msg/VehicleControlMode
uint64 timestamp		# time since system start (microseconds)
bool flag_armed			# synonym for actuator_armed.armed

bool flag_multicopter_position_control_enabled

bool flag_control_manual_enabled		# true if manual input is mixed in
bool flag_control_auto_enabled			# true if onboard autopilot should act
bool flag_control_offboard_enabled		# true if offboard control should be used
bool flag_control_position_enabled		# true if position is controlled
bool flag_control_velocity_enabled		# true if horizontal velocity (implies direction) is controlled
bool flag_control_altitude_enabled		# true if altitude is controlled
bool flag_control_climb_rate_enabled		# true if climb rate is controlled
bool flag_control_acceleration_enabled		# true if acceleration is controlled
bool flag_control_attitude_enabled		# true if attitude stabilization is mixed in
bool flag_control_rates_enabled			# true if rates are stabilized
bool flag_control_allocation_enabled		# true if control allocation is enabled
bool flag_control_termination_enabled		# true if flighttermination is enabled

# TODO: use dedicated topic for external requests
uint8 source_id                  # Mode ID (nav_state)

# TOPICS vehicle_control_mode config_control_setpoints

```
Echoing it can give the current mode information

```yaml
mconros2@Robot:~/ros2_ws$ ros2 topic echo --once /fmu/out/vehicle_control_mode
timestamp: 1749663166220093
flag_armed: false
flag_multicopter_position_control_enabled: true
flag_control_manual_enabled: false
flag_control_auto_enabled: true
flag_control_offboard_enabled: false
flag_control_position_enabled: true
flag_control_velocity_enabled: true
flag_control_altitude_enabled: true
flag_control_climb_rate_enabled: true
flag_control_acceleration_enabled: false
flag_control_attitude_enabled: true
flag_control_rates_enabled: true
flag_control_allocation_enabled: true
flag_control_termination_enabled: false
source_id: 0
---

```

##

```yaml
mconros2@Robot:~/ros2_ws$ ros2 interface show px4_msgs/msg/VehicleLocalPosition
# Fused local position in NED.
# The coordinate system origin is the vehicle position at the time when the EKF2-module was started.

uint64 timestamp			# time since system start (microseconds)
uint64 timestamp_sample                 # the timestamp of the raw data (microseconds)

bool xy_valid				# true if x and y are valid
bool z_valid				# true if z is valid
bool v_xy_valid				# true if vx and vy are valid
bool v_z_valid				# true if vz is valid

# Position in local NED frame
float32 x				# North position in NED earth-fixed frame, (metres)
float32 y				# East position in NED earth-fixed frame, (metres)
float32 z				# Down position (negative altitude) in NED earth-fixed frame, (metres)

# Position reset delta
float32[2] delta_xy			# Amount of lateral shift of position estimate in latest reset (in x and y) [m]
uint8 xy_reset_counter			# Index of latest lateral position estimate reset
float32 delta_z				# Amount of vertical shift of position estimate in latest reset [m]
uint8 z_reset_counter			# Index of latest vertical position estimate reset

# Velocity in NED frame
float32 vx 				# North velocity in NED earth-fixed frame, (metres/sec)
float32 vy				# East velocity in NED earth-fixed frame, (metres/sec)
float32 vz				# Down velocity in NED earth-fixed frame, (metres/sec)
float32 z_deriv				# Down position time derivative in NED earth-fixed frame, (metres/sec)

# Velocity reset delta
float32[2] delta_vxy			# Amount of lateral shift of velocity estimate in latest reset (in x and y) [m/s]
uint8 vxy_reset_counter			# Index of latest vertical velocity estimate reset
float32 delta_vz			# Amount of vertical shift of velocity estimate in latest reset [m/s]
uint8 vz_reset_counter			# Index of latest vertical velocity estimate reset

# Acceleration in NED frame
float32 ax        # North velocity derivative in NED earth-fixed frame, (metres/sec^2)
float32 ay        # East velocity derivative in NED earth-fixed frame, (metres/sec^2)
float32 az        # Down velocity derivative in NED earth-fixed frame, (metres/sec^2)

float32 heading				# Euler yaw angle transforming the tangent plane relative to NED earth-fixed frame, -PI..+PI,  (radians)
float32 heading_var
float32 unaided_heading                 # Same as heading but generated by integrating corrected gyro data only
float32 delta_heading			# Heading delta caused by latest heading reset [rad]
uint8 heading_reset_counter		# Index of latest heading reset
bool heading_good_for_control

float32 tilt_var

# Position of reference point (local NED frame origin) in global (GPS / WGS84) frame
bool xy_global				# true if position (x, y) has a valid global reference (ref_lat, ref_lon)
bool z_global				# true if z has a valid global reference (ref_alt)
uint64 ref_timestamp			# Time when reference position was set since system start, (microseconds)
float64 ref_lat				# Reference point latitude, (degrees)
float64 ref_lon				# Reference point longitude, (degrees)
float32 ref_alt				# Reference altitude AMSL, (metres)

# Distance to surface
float32 dist_bottom			# Distance from from bottom surface to ground, (metres)
bool dist_bottom_valid			# true if distance to bottom surface is valid
uint8 dist_bottom_sensor_bitfield	# bitfield indicating what type of sensor is used to estimate dist_bottom
uint8 DIST_BOTTOM_SENSOR_NONE = 0
uint8 DIST_BOTTOM_SENSOR_RANGE = 1	# (1 << 0) a range sensor is used to estimate dist_bottom field
uint8 DIST_BOTTOM_SENSOR_FLOW = 2	# (1 << 1) a flow sensor is used to estimate dist_bottom field (mostly fixed-wing use case)

float32 eph				# Standard deviation of horizontal position error, (metres)
float32 epv				# Standard deviation of vertical position error, (metres)
float32 evh				# Standard deviation of horizontal velocity error, (metres/sec)
float32 evv				# Standard deviation of vertical velocity error, (metres/sec)

bool dead_reckoning                     # True if this position is estimated through dead-reckoning

# estimator specified vehicle limits
float32 vxy_max				# maximum horizontal speed - set to 0 when limiting not required (meters/sec)
float32 vz_max				# maximum vertical speed - set to 0 when limiting not required (meters/sec)
float32 hagl_min			# minimum height above ground level - set to 0 when limiting not required (meters)
float32 hagl_max			# maximum height above ground level - set to 0 when limiting not required (meters)

# TOPICS vehicle_local_position vehicle_local_position_groundtruth external_ins_local_position
# TOPICS estimator_local_position

```


### /fmu/out/vehicle_attitude

```yaml
# This is similar to the mavlink message ATTITUDE_QUATERNION, but for onboard use
# The quaternion uses the Hamilton convention, and the order is q(w, x, y, z)

uint64 timestamp                # time since system start (microseconds)

uint64 timestamp_sample         # the timestamp of the raw data (microseconds)

float32[4] q                    # Quaternion rotation from the FRD body frame to the NED earth frame
float32[4] delta_q_reset        # Amount by which quaternion has changed during last reset
uint8 quat_reset_counter        # Quaternion reset counter

# TOPICS vehicle_attitude vehicle_attitude_groundtruth external_ins_attitude
# TOPICS estimator_attitude

```