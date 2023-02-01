# Understand and apply mavros_controller
This turtorial is to show how to implement mavros_controller in real-world experiments.

## 1. Nodes and control in mavros_controller
There are two nodes to be run:
1. **trajectory_publisher** is a node publishing setpoints as states from motion primitives / trajectories for the controller to follow.
2. **geometric_controller** is a node computing and sending commands to drones in order to follow reference trajectory published by **trajectory_publisher**.

### 1.1 geometric_controller
Here is a schematic for **geometric_controller**.
<figure>
    <img src="7_Mavros_Controller/v1_0.png"
         alt="drawing" style="width:700px;"/>
</figure>

This node 
- computes control commands **body rate** and send to <u> mavros/setpoint_raw/attitude</u>
- receives reference trajectory in **ref position** and **ref velocity** from <u>reference/setpoint</u>


#### Step 1. receivce reference position and velocity

**Reference position** and **velocity** are gained at the topic <u>reference/setpoint</u> that is published by **trajectory_publisher**. Then Reference acce are computed with the derivative of velocity.


Code between line 122-137 in <u>geometric_control.cpp</u> shows that
+ reference position is ```targetPos_```
+ reference velocity is ```targetVel_``` 
+ reference acc is ```targetAcc_``` 

```C++
// Line 122-137
void geometricCtrl::targetCallback(const geometry_msgs::TwistStamped &msg) {
  reference_request_last_ = reference_request_now_;
  targetPos_prev_ = targetPos_;
  targetVel_prev_ = targetVel_;

  reference_request_now_ = ros::Time::now();
  reference_request_dt_ = (reference_request_now_ - reference_request_last_).toSec();

  targetPos_ = toEigen(msg.twist.angular);
  targetVel_ = toEigen(msg.twist.linear);

  if (reference_request_dt_ > 0)
    targetAcc_ = (targetVel_ - targetVel_prev_) / reference_request_dt_;
  else
    targetAcc_ = Eigen::Vector3d::Zero();
}

```
#### Step 2. Control application

Callback function ```cmdloopCallback``` is defined in the constrcuctor as
```c++
   // Line 69
   cmdloop_timer_ = nh_.createTimer(ros::Duration(0.01), &geometricCtrl::cmdloopCallback, this); 
```

Core code is in ```cmdloopCallback``` with main functions:
+ ```controlPosition``` calculates desired acc from reference position, vel and acc. 
+ ```computeBodyRateCmd```
+ ```pubReferencePose```
+ ```pubRateCommands```
+ ```appendPoseHistory```
+ ```pubPoseHistory```

```C++
// Line 225 - 263
void geometricCtrl::cmdloopCallback(const ros::TimerEvent &event) {
    /*--------------*/

    case MISSION_EXECUTION: {
      Eigen::Vector3d desired_acc;
      if (feedthrough_enable_) {
        desired_acc = targetAcc_;
      } else {
        // 1. calculates desired acc from reference position, vel and acc. 
        desired_acc = controlPosition(targetPos_, targetVel_, targetAcc_);
      }
      // 2. 
      computeBodyRateCmd(cmdBodyRate_, desired_acc);
      // 3.
      pubReferencePose(targetPos_, q_des);
      // 4.
      pubRateCommands(cmdBodyRate_, q_des);
      // 5. 
      appendPoseHistory();
      // 6. 
      pubPoseHistory();
      break;
    }

    /*--------------*/

}
```


##### 1. ```controlPosition```
```C++ 
  desired_acc = controlPosition(targetPos_, targetVel_, targetAcc_);
```
```controlPosition``` is programmed including three funcationalities:
+ ```acc2quaternion``` compute **reference attitude** in quaterion, see [acc2quaternion](#acc2quaternion) in [Appendix](#6-appendix)
+ ```quat2RotMatrix``` transfer **reference attitude** in rotation matrix from quaterion
+ ```poscontroller``` use a PD contro (position and vel) to compute feedback reference acc, see [poscontroller](#poscontroller) in [Appendix](#6-appendix).
+  final desired acc, $\mathbf{a}_{des}$, is calculated
$$\mathbf{a}_{des} = \mathbf{a}_{fd} + \mathbf{a}_{ref} - \mathbf{a}_{rd} - \mathbf{g}$$

```C++
// Line  365
Eigen::Vector3d geometricCtrl::controlPosition(const Eigen::Vector3d &target_pos, const Eigen::Vector3d &target_vel,
                                               const Eigen::Vector3d &target_acc) {
  /// Compute BodyRate commands using differential flatness
  /// Controller based on Faessler 2017
  const Eigen::Vector3d a_ref = target_acc;
  if (velocity_yaw_) {
    mavYaw_ = getVelocityYaw(mavVel_);
  }

  const Eigen::Vector4d q_ref = acc2quaternion(a_ref - g_, mavYaw_);
  const Eigen::Matrix3d R_ref = quat2RotMatrix(q_ref);

  const Eigen::Vector3d pos_error = mavPos_ - target_pos;
  const Eigen::Vector3d vel_error = mavVel_ - target_vel;

  // Position Controller
  const Eigen::Vector3d a_fb = poscontroller(pos_error, vel_error);

  // Rotor Drag compensation
  const Eigen::Vector3d a_rd = R_ref * D_.asDiagonal() * R_ref.transpose() * target_vel;  // Rotor drag

  // Reference acceleration
  const Eigen::Vector3d a_des = a_fb + a_ref - a_rd - g_;

  return a_des;
  }
```

##### 2. ```computeBodyRateCmd```
 ```C++
 // Line 392-408
 void geometricCtrl::computeBodyRateCmd(Eigen::Vector4d &bodyrate_cmd, const Eigen::Vector3d &a_des) {
  // Reference attitude
  q_des = acc2quaternion(a_des, mavYaw_);

  // Choose which kind of attitude controller you are running
  bool jerk_enabled = false;
  if (!jerk_enabled) {
    if (ctrl_mode_ == ERROR_GEOMETRIC) {
      // 2.2.a
      bodyrate_cmd = geometric_attcontroller(q_des, a_des, mavAtt_);  // Calculate BodyRate

    } else {
      // 2.2.b
      bodyrate_cmd = attcontroller(q_des, a_des, mavAtt_);  // Calculate BodyRate
    }
  } else {
    // 2.2.c
    bodyrate_cmd = jerkcontroller(targetJerk_, a_des, q_des, mavAtt_);
  }
}
 ``` 

2.1 compute reference attitude using the output from **controlPosition** with

  ```c++
    q_des = acc2quaternion(a_des, mavYaw_);
  ```

2.2 calculate control input **body rate** by one of three methods
+ ```bodyrate_cmd = geometric_attcontroller(q_des, a_des, mavAtt_);```
  which is 
    ```c++
    // Line 494 - 517
    Eigen::Vector4d geometricCtrl::geometric_attcontroller(const Eigen::Vector4d &ref_att, const Eigen::Vector3d &ref_acc,
                                                          Eigen::Vector4d &curr_att) {
      // Geometric attitude controller
      // Attitude error is defined as in Lee, Taeyoung, Melvin Leok, and N. Harris McClamroch. "Geometric tracking control
      // of a quadrotor UAV on SE (3)." 49th IEEE conference on decision and control (CDC). IEEE, 2010.
      // The original paper inputs moment commands, but for offboard control, angular rate commands are sent

      Eigen::Vector4d ratecmd;
      Eigen::Matrix3d rotmat;    // Rotation matrix of current attitude
      Eigen::Matrix3d rotmat_d;  // Rotation matrix of desired attitude
      Eigen::Vector3d error_att;

      rotmat = quat2RotMatrix(curr_att);
      rotmat_d = quat2RotMatrix(ref_att);

      error_att = 0.5 * matrix_hat_inv(rotmat_d.transpose() * rotmat - rotmat.transpose() * rotmat_d);
      ratecmd.head(3) = (2.0 / attctrl_tau_) * error_att;
      rotmat = quat2RotMatrix(mavAtt_);
      const Eigen::Vector3d zb = rotmat.col(2);
      ratecmd(3) =
          std::max(0.0, std::min(1.0, norm_thrust_const_ * ref_acc.dot(zb) + norm_thrust_offset_));  // Calculate thrust

      return ratecmd;
    }
    ```
+ ```bodyrate_cmd = attcontroller(q_des, a_des, mavAtt_)```
  ```c++
  // Line 436-456
  Eigen::Vector4d geometricCtrl::attcontroller(const Eigen::Vector4d &ref_att, const Eigen::Vector3d &ref_acc,
                                              Eigen::Vector4d &curr_att) {
    // Geometric attitude controller
    // Attitude error is defined as in Brescianini, Dario, Markus Hehn, and Raffaello D'Andrea. Nonlinear quadrocopter
    // attitude control: Technical report. ETH Zurich, 2013.

    Eigen::Vector4d ratecmd;

    const Eigen::Vector4d inverse(1.0, -1.0, -1.0, -1.0);
    const Eigen::Vector4d q_inv = inverse.asDiagonal() * curr_att;
    const Eigen::Vector4d qe = quatMultiplication(q_inv, ref_att);
    ratecmd(0) = (2.0 / attctrl_tau_) * std::copysign(1.0, qe(0)) * qe(1);
    ratecmd(1) = (2.0 / attctrl_tau_) * std::copysign(1.0, qe(0)) * qe(2);
    ratecmd(2) = (2.0 / attctrl_tau_) * std::copysign(1.0, qe(0)) * qe(3);
    const Eigen::Matrix3d rotmat = quat2RotMatrix(mavAtt_);
    const Eigen::Vector3d zb = rotmat.col(2);
    ratecmd(3) =
        std::max(0.0, std::min(1.0, norm_thrust_const_ * ref_acc.dot(zb) + norm_thrust_offset_));  // Calculate thrust

    return ratecmd;
  }
  ```
+ ```bodyrate_cmd = jerkcontroller(targetJerk_, a_des, q_des, mavAtt_)```
  ```c++
  // Line 458-492
  Eigen::Vector4d geometricCtrl::jerkcontroller(const Eigen::Vector3d &ref_jerk, const Eigen::Vector3d &ref_acc,
                                                Eigen::Vector4d &ref_att, Eigen::Vector4d &curr_att) {
    // Jerk feedforward control
    // Based on: Lopez, Brett Thomas. Low-latency trajectory planning for high-speed navigation in unknown environments.
    // Diss. Massachusetts Institute of Technology, 2016.
    // Feedforward control from Lopez(2016)

    double dt_ = 0.01;
    // Numerical differentiation to calculate jerk_fb
    const Eigen::Vector3d jerk_fb = (ref_acc - last_ref_acc_) / dt_;
    const Eigen::Vector3d jerk_des = ref_jerk + jerk_fb;
    const Eigen::Matrix3d R = quat2RotMatrix(curr_att);
    const Eigen::Vector3d zb = R.col(2);

    const Eigen::Vector3d jerk_vector =
        jerk_des / ref_acc.norm() - ref_acc * ref_acc.dot(jerk_des) / std::pow(ref_acc.norm(), 3);
    const Eigen::Vector4d jerk_vector4d(0.0, jerk_vector(0), jerk_vector(1), jerk_vector(2));

    Eigen::Vector4d inverse(1.0, -1.0, -1.0, -1.0);
    const Eigen::Vector4d q_inv = inverse.asDiagonal() * curr_att;
    const Eigen::Vector4d qd = quatMultiplication(q_inv, ref_att);

    const Eigen::Vector4d qd_star(qd(0), -qd(1), -qd(2), -qd(3));

    const Eigen::Vector4d ratecmd_pre = quatMultiplication(quatMultiplication(qd_star, jerk_vector4d), qd);

    Eigen::Vector4d ratecmd;
    ratecmd(0) = ratecmd_pre(2);  // TODO: Are the coordinate systems consistent?
    ratecmd(1) = (-1.0) * ratecmd_pre(1);
    ratecmd(2) = 0.0;
    ratecmd(3) =
        std::max(0.0, std::min(1.0, norm_thrust_const_ * ref_acc.dot(zb) + norm_thrust_offset_));  // Calculate thrust
    last_ref_acc_ = ref_acc;
    return ratecmd;
  }
  ```
2.3 how to choose attiude control methods
+ Paramers for choosing attitude control mode are defined in <u>geometric_controller.h</u>
  ```c++
    // Line 75-76
    #define ERROR_GEOMETRIC 2
    #define ERROR_QUATERNION 1
  ```
+ Variable to choose the mode is read from ros param **ctrl_mode**
  ```c++
    //Line 84
    nh_private_.param<int>("ctrl_mode", ctrl_mode_, ERROR_QUATERNION);
  ```
  which is specified in launch file, e.g. <u> sitl_trajectory_track_circle.launch </u> using **command_input**. 

  ```shell
    # Line 7
    <arg name="command_input" default="2" />
    # Line 17
    <param name="ctrl_mode" value="$(arg command_input)" />
  ```
**Remarks**:
1. Usually, only ```attcontroller``` and ```geometric_attcontroller``` are available
2. Set ```command_input = 2``` leads to ```geometric_attcontroller```, while ```command_input = 1``` leads to ```attcontroller```.

##### 3. ```pubReferencePose```
This function is to publish reference position and attitude to the topic <u>reference/pose</u> as
```c++
  pubReferencePose(targetPos_, q_des);
```

  ```c++ 
    // Line 290-303
    void geometricCtrl::pubReferencePose(const Eigen::Vector3d &target_position, const Eigen::Vector4d &target_attitude) {
      geometry_msgs::PoseStamped msg;

      msg.header.stamp = ros::Time::now();
      msg.header.frame_id = "map";
      msg.pose.position.x = target_position(0);
      msg.pose.position.y = target_position(1);
      msg.pose.position.z = target_position(2);
      msg.pose.orientation.w = target_attitude(0);
      msg.pose.orientation.x = target_attitude(1);
      msg.pose.orientation.y = target_attitude(2);
      msg.pose.orientation.z = target_attitude(3);
      referencePosePub_.publish(msg);
    }
  ```


##### 4. ```pubRateCommands```
This function is to publish the control input (body rate and thrust) to the topic <u>command/bodyrate_command</u> as
  ```c++ 
    pubRateCommands(cmdBodyRate_, q_des);
  ```
where is maped to <u>/mavros/setpoint_raw/attitude</u>
  ```shell
    <remap from="command/bodyrate_command" to="/mavros/setpoint_raw/attitude"/>
  ```

  ```c++
  // Line 305-321
  void geometricCtrl::pubRateCommands(const Eigen::Vector4d &cmd, const Eigen::Vector4d &target_attitude) {
  mavros_msgs::AttitudeTarget msg;

  msg.header.stamp = ros::Time::now();
  msg.header.frame_id = "map";
  msg.body_rate.x = cmd(0);
  msg.body_rate.y = cmd(1);
  msg.body_rate.z = cmd(2);
  msg.type_mask = 128;  // Ignore orientation messages
  msg.orientation.w = target_attitude(0);
  msg.orientation.x = target_attitude(1);
  msg.orientation.y = target_attitude(2);
  msg.orientation.z = target_attitude(3);
  msg.thrust = cmd(3);

  angularVelPub_.publish(msg);
}
  ```

##### 5. ```pubReferencePose``` and ```pubPoseHistory()```
Here we do two things
+ with ```appendPoseHistory()```, we record the drone's position and attitude and save them into a vector ```posehistory_vector_``` with a size of```posehistory_window_``` (default = 200).
  ```c++
      // Line 243-244
      appendPoseHistory();
      pubPoseHistory();
  ```
  ```c++
    // Line 343-348
    void geometricCtrl::appendPoseHistory() {
      posehistory_vector_.insert(posehistory_vector_.begin(), vector3d2PoseStampedMsg(mavPos_, mavAtt_));
      if (posehistory_vector_.size() > posehistory_window_) {
        posehistory_vector_.pop_back();
      }
    }
  ```
  + with ```pubPoseHistory()```, ```posehistory_vector_``` is published to the topic <u>geometric_controller/path</u>

  ```c++
    // Line 323-331
    void geometricCtrl::pubPoseHistory() {
      nav_msgs::Path msg;

      msg.header.stamp = ros::Time::now();
      msg.header.frame_id = "map";
      msg.poses = posehistory_vector_;

      posehistoryPub_.publish(msg);
    }
  ```
## 1.2 trajectory_publisher
It is implemented in ```trajectoryPublisher.cpp```.


### Step 0
In the constructor,
  ```c++
  trajectoryPublisher::trajectoryPublisher(const ros::NodeHandle& nh, const ros::NodeHandle& nh_private)//
  : nh_(nh), nh_private_(nh_private), motion_selector_(0)//
  ```    
1. read ```num_primitives_``` from ros parameter ```number_of_primitives```
  ```c++
    nh_private_.param<int>("number_of_primitives", num_primitives_, 7);
  ```
2. change the size of ```inputs_``` to be ```num_primitives_```
  ```c++
  inputs_.resize(num_primitives_);
  ```

4. ```initializePrimitives``` is called at the end of constructor.

  ```c++
   initializePrimitives(trajectory_type_);
  ```
  ```c++
  void trajectoryPublisher::initializePrimitives(int type) {
    if (type == 0) {
      for (int i = 0; i < motionPrimitives_.size(); i++)
        motionPrimitives_.at(i)->generatePrimitives(p_mav_, v_mav_, inputs_.at(i));
    } else {
      for (int i = 0; i < motionPrimitives_.size(); i++)
        motionPrimitives_.at(i)->initPrimitives(shape_origin_, shape_axis_, shape_omega_);
      // TODO: Pass in parameters for primitive trajectories
    }
  }
  ```

### step 1 Choose trajectory planning
Trajectory can be planned with two different methods:
+ polynomial trajectory by setting ```trajectory_type_ =0```
+ shape trajectory by setting ```trajectory_type_ =1```
  ```c++
  if (trajectory_type_ == 0) {  // Polynomial Trajectory

    if (num_primitives_ == 7) {
      inputs_.at(0) << 0.0, 0.0, 0.0;  // Constant jerk inputs for minimim time trajectories
      inputs_.at(1) << 1.0, 0.0, 0.0;
      inputs_.at(2) << -1.0, 0.0, 0.0;
      inputs_.at(3) << 0.0, 1.0, 0.0;
      inputs_.at(4) << 0.0, -1.0, 0.0;
      inputs_.at(5) << 0.0, 0.0, 1.0;
      inputs_.at(6) << 0.0, 0.0, -1.0;
    }

    for (int i = 0; i < num_primitives_; i++) {
      /*Poly trajectory initilisation*/
      motionPrimitives_.emplace_back(std::make_shared<polynomialtrajectory>());
      primitivePub_.push_back(
          nh_.advertise<nav_msgs::Path>("trajectory_publisher/primitiveset" + std::to_string(i), 1));
      inputs_.at(i) = inputs_.at(i) * max_jerk_;
    }
  } else {  // Shape trajectories

    num_primitives_ = 1;

    /*Shape trajectory initilisation*/
    motionPrimitives_.emplace_back(std::make_shared<shapetrajectory>(trajectory_type_));
    primitivePub_.push_back(nh_.advertise<nav_msgs::Path>("trajectory_publisher/primitiveset", 1));
  }
  ```

```motion_selector_```

### step 1 Publish reference trajectory and setpoints
Core functions are ```loopCallback``` and ```refCallback```: ```loopCallback``` is called with a frequency of 10HZ, while ```refCallback```is called with a frequency of 100HZ.

```c++
  // Line 58-59
  trajloop_timer_ = nh_.createTimer(ros::Duration(0.1), &trajectoryPublisher::loopCallback, this);
  refloop_timer_ = nh_.createTimer(ros::Duration(0.01), &trajectoryPublisher::refCallback, this);
```


#### ```loopCallback``` publish reference trajectory
Whole/Segment reference trajecotry is publised to <u>trajectory_publisher/trajectory</u>.
```c++
  void trajectoryPublisher::loopCallback(const ros::TimerEvent& event) {
    // Slow Loop publishing trajectory information
    pubrefTrajectory(motion_selector_);
    pubprimitiveTrajectory();
  }
```

1. ```pubrefTrajectory(motion_selector_)``` publish the whole reference trajectory to <u>trajectory_publisher/trajectory</u>. 
```c++
  void trajectoryPublisher::pubrefTrajectory(int selector) {
    // Publish current trajectory the publisher is publishing
    refTrajectory_ = motionPrimitives_.at(selector)->getSegment();
    refTrajectory_.header.stamp = ros::Time::now();
    refTrajectory_.header.frame_id = "map";
    trajectoryPub_.publish(refTrajectory_);
  }
```
where the publisher is defined as
```c++
 trajectoryPub_ = nh_.advertise<nav_msgs::Path>("trajectory_publisher/trajectory", 1);
```

2. ```pubprimitiveTrajectory()``` publishes segments of reference trajectory to <u>trajectory_publisher/primitiveset</u>.
```c++
  void trajectoryPublisher::pubprimitiveTrajectory() {
    for (int i = 0; i < motionPrimitives_.size(); i++) {
      primTrajectory_ = motionPrimitives_.at(i)->getSegment();
      primTrajectory_.header.stamp = ros::Time::now();
      primTrajectory_.header.frame_id = "map";
      primitivePub_.at(i).publish(primTrajectory_);
    }
  }
```
```c++
  primitivePub_.push_back(nh_.advertise<nav_msgs::Path>("trajectory_publisher/primitiveset", 1));
```

### step 3 send setpoint of reference trajectory to drone
Inside ```refCallback```, we have three options to compute setpoints for drone.

```c++
void trajectoryPublisher::refCallback(const ros::TimerEvent& event) {
      // Fast Loop publishing reference states
      updateReference();
      switch (pubreference_type_) {
        case REF_TWIST: // REF_TWIST = 8
          pubrefState();
          break;
        case REF_SETPOINTRAW: // REF_TWIST = 16
          pubrefSetpointRaw();
          // pubrefSetpointRawGlobal();
          break;
        default:          // pubreference_type_ by default = 2
          pubflatrefState();
          break;
      }
    }
```

| ```pubreference_type_```      | Function | Commamds | Topic |
| ----------- | ----------- |----------- |----------- |
| 2 (default)    |```pubflatrefState``` | p_targ, v_targ, a_targ       |```reference/flatsetpoint``` |
| 8   | ```pubrefState```        |p_targ, v_targ| ```reference/setpoint```|
| 16   | ```pubrefSetpointRaw```        |p_targ, v_targ, a_targ | ```mavros/setpoint_raw/local```|

sd

```c++
  void trajectoryPublisher::updateReference() {
  curr_time_ = ros::Time::now();
  trigger_time_ = (curr_time_ - start_time_).toSec();

  p_targ = motionPrimitives_.at(motion_selector_)->getPosition(trigger_time_);
  v_targ = motionPrimitives_.at(motion_selector_)->getVelocity(trigger_time_);
  if (pubreference_type_ != 0) a_targ = motionPrimitives_.at(motion_selector_)->getAcceleration(trigger_time_);
}
```


# 6 Appendix 
## 6.1 algorithm in geometirc_controller
### acc2quaternion
```acc2quaternion``` is to compute a reference rotation from reference acceleration, which is called in ```controlPosition```and ```computeBodyRateCmd```
```c++
    // Line 374
    // Or Line 394
    const Eigen::Vector4d q_ref = acc2quaternion(a_ref - g_, mavYaw_);
```
where the function ```acc2quaternion``` is defined as below
```C++
// line 420 - 434
Eigen::Vector4d geometricCtrl::acc2quaternion(const Eigen::Vector3d &vector_acc, const double &yaw) {
  Eigen::Vector4d quat;
  Eigen::Vector3d zb_des, yb_des, xb_des, proj_xb_des;
  Eigen::Matrix3d rotmat;

  proj_xb_des << std::cos(yaw), std::sin(yaw), 0.0;

  zb_des = vector_acc / vector_acc.norm();
  yb_des = zb_des.cross(proj_xb_des) / (zb_des.cross(proj_xb_des)).norm();
  xb_des = yb_des.cross(zb_des) / (yb_des.cross(zb_des)).norm();

  rotmat << xb_des(0), yb_des(0), zb_des(0), xb_des(1), yb_des(1), zb_des(1), xb_des(2), yb_des(2), zb_des(2);
  quat = rot2Quaternion(rotmat);
  return quat;
}
```
and more explanation can be found in slides. TO DO.


### ```poscontroller```
```poscontroller``` uses PD control to computes a reference acc from position and vel error, which is called in ```cmdloopCallback``` at line 238.

In fact, it can be represented using the following equation

$$\mathbf{a}_{fb} = K_{pos} \cdot \mathbf{e}_p + K_{vel} \cdot \mathbf{e}_v \,.$$

```c++
    // Line 410
    Eigen::Vector3d geometricCtrl::poscontroller(const Eigen::Vector3d &pos_error, const Eigen::Vector3d &vel_error) {
      Eigen::Vector3d a_fb =
          Kpos_.asDiagonal() * pos_error + Kvel_.asDiagonal() * vel_error;  // feedforward term for trajectory error

      if (a_fb.norm() > max_fb_acc_)
        a_fb = (max_fb_acc_ / a_fb.norm()) * a_fb;  // Clip acceleration if reference is too large

      return a_fb;
    }
```


## ROS techniques in mavros_controller
Subscriper 
  ```C++
  referenceSub_ = nh_.subscribe("reference/setpoint", 1, &geometricCtrl::targetCallback, this, ros::TransportHints().tcpNoDelay());
  ```
Usually, subscriber is ROS C++ is defined like 
```C++
ros::Subscriber sub = nh.subscribe("my_topic", 1, callback);
```
with three arguments:
- topic to subscribed,
- queue sise, 
- callback function.

Well, the full version of subscriber is defined with four arguments
```C++
Subscriber ros::NodeHandle::subscribe(
    const std::string &  	topic,
		uint32_t  	queue_size,
		const boost::function< void(C)>&  	callback,
		const VoidConstPtr&  	tracked_object = VoidConstPtr(),
		const TransportHints&  	transport_hints = TransportHints() 
	) 	
```
1.  ```tracked_object```

Parameter *tracked_object* defines a shared pointer to an object to track for these callbacks.  If set, the a weak_ptr will be created to this object, and if the reference count goes to 0 the subscriber callbacks will not get called.

Note that setting this will cause a new reference to be added to the object before the callback, and for it to go out of scope (and potentially be deleted) in the code path (and therefore
 thread) that the callback is invoked fro

2. ```transport_hints```
```transport_hints``` allows us to choose prefered connection ways by specify hints to roscpp's transport layer.

We can choose one among ```unreliable, reliable, maxDatagramSize, tcpNoDelay```
```C++
ros::TransportHints()
           .unreliable()
           .reliable()
           .maxDatagramSize(1000)
           .tcpNoDelay();
           ```

just likes
```C++
ros::Subscriber sub = nh.subscribe("my_topic", 1, callback, ros::TransportHints().unreliable());
```

More details can be found [roscpp Overview Publishers and Subscribers](http://wiki.ros.org/roscpp/Overview/Publishers%20and%20Subscribers).

[ROS API](https://docs.ros.org/en/api/roscpp/html/classros_1_1NodeHandle.html#a6b655c04f32c4c967d49799ff9312ac6)

advertiseService 
  ```C++
    ctrltriggerServ_ = nh_.advertiseService("trigger_rlcontroller", &geometricCtrl::ctrltriggerCallback, this);
  ```

```advertiseService``` allows us to creat a ```ros::ServiceServer`` that works similar to how the ```subscribe()``` method works.

