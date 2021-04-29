function [time, state] = trajectory(vehicle, uncertainties)
%   Computes the trajectory of the vehicle
    START_TIME = 0;
    END_TIME = 650;
    TIME_STEP = 0.1;
    
    env = environment.create_environment([0;0;0]);
    
    launch_angle = sampling.apply_uncertainty(...
        vehicle.launch_angle,...
        'launch_angle',...
        uncertainties);

    init_pos = [0;0;vehicle.launch_alt];
    init_quat = lin_alg.euler_to_quat([0;-launch_angle;0]);
    init_lin_vel = [0;0;0];
    init_ang_vel = [0;0;0];

    state_init = [
        init_pos;
        init_quat;
        init_lin_vel;
        init_ang_vel]; 
    func = @(time, state) rocket_ode(time, state, vehicle, env, uncertainties);
    [time, state] = ode45(func, (START_TIME:TIME_STEP:END_TIME), state_init);
end