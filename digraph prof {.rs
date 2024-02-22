digraph prof {
	fontname="Helvetica,Arial,sans-serif"
	node [fontname="Helvetica,Arial,sans-serif"]
	edge [fontname="Helvetica,Arial,sans-serif"]
	node [style=filled];
	rankdir=LR;
    compound=true;
// Model_Stablize
	subgraph cluster_0 {
		style=filled;
		color=lightgrey;
		node [style=filled,color=white];
		Model_Stablize_run0[label="run()"]
		Model_Stablize_update_simple_mode0[label="update_simple_mode()"]
        Model_Stablize_run0 -> Model_Stablize_update_simple_mode0
		label = "Model_Stablize";
	}
	
// 	Copter
	subgraph cluster_1 {
		style=filled;
		color=lightgrey;
		node [style=filled,color=white];
		Copter_update_simple_mode0[label="update_simple_mode()"]
		Copter_fast_loop[label="fast_loop()"]
		Copter_update_flight_mode[label="update_flight_mode()"]
		label = "Copter";
	}
	
	Model_Stablize_run0 -> Copter_update_simple_mode0 
	Copter_fast_loop -> Copter_update_flight_mode
	Copter_update_flight_mode -> Model_Stablize_run0
	Copter_fast_loop -> AC_AttitudeControl_Wulti_rate_controller_run
	
// Mode	
	subgraph cluster_2 {
		style=filled;
		color=lightgrey;
		node [style=filled,color=white];
		Mode_get_pilot_desired_lean_angles[label="get_pilot_desired_lean_angles()"]
		Mode_get_pilot_desired_yaw_rate[label="get_pilot_desired_yaw_rate()"]
		label = "Mode";
	}
// 	
	Model_Stablize_run0 -> Mode_get_pilot_desired_lean_angles
	Model_Stablize_run0 -> Mode_get_pilot_desired_yaw_rate
	
	
// AC_AttitudeControl
	subgraph cluster_3 {
		style=filled;
		color=lightgrey;
		node [style=filled,color=white];
        AC_AttitudeControl_input_euler_angle_roll_pitch_euler_rate_yaw[label="input_euler_angle_roll_pitch_euler_rate_yaw()"]
        AC_AttitudeControl_attitude_controller_run_quat[label="attitude_controller_run_quat()"]
		label = "AC_AttitudeControl";
		AC_AttitudeControl_input_euler_angle_roll_pitch_euler_rate_yaw->AC_AttitudeControl_attitude_controller_run_quat
	}	
// 	
	Model_Stablize_run0 -> AC_AttitudeControl_input_euler_angle_roll_pitch_euler_rate_yaw
	
// AC_AttitudeControl_Wulti
	subgraph cluster_4 {
		style=filled;
		color=lightgrey;
		node [style=filled,color=white];
        AC_AttitudeControl_Wulti_set_throttle_out[label="set_throttle_out()"]
        AC_AttitudeControl_Wulti_rate_controller_run[label="rate_controller_run()"]
        
		label = "AC_AttitudeControl_Wulti";
	}		
		Model_Stablize_run0 -> AC_AttitudeControl_Wulti_set_throttle_out
		
		
}