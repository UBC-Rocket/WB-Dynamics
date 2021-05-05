function [time, state] = trajectory(vehicle)
%TRAJECTORY Computes the trajectory of the vehicle
%
%   Input:
%       vehicle : struct containing all properties of the vehicle. See the
%                 function `rocket_nominal` to see what fields this struct
%                 should have.
%   Output:
%       time    : vector of all time steps that the state was computed for
%       state   : matrix of size (length(time), 13) representing the states
%                 of the vehicle at each time step.
%                 Columns:
%                   - 1   : x component of position in meters
%                   - 2   : y component of position in meters
%                   - 3   : z component of position in meters (altitude 
%                           above sea level)
%                   - 4-7 : quaternion in the form of [x,y,z,w]
%                           representing the orientation of the rocket 
%                           relative to the inertial frame
%                   - 8   : x component of linear velocity in m/s
%                   - 9   : y component of linear velocity in m/s
%                   - 10  : z component of linear velocity in m/s
%                   - 11  : x component of angular velocity in radians/s
%                   - 12  : y component of angular velocity in radians/s
%                   - 12  : z component of angular velocity in radians/s
%
    START_TIME = 0;
    END_TIME = 700;
    TIME_STEP = 0.1;
    
    env = environment.create_environment([0;0;0]);

    init_pos = [0;0;vehicle.launch_alt];
    init_quat = lin_alg.euler_to_quat([0;-vehicle.launch_angle;0]);
    init_lin_vel = [0;0;0];
    init_ang_vel = [0;0;0];

    state_init = [
        init_pos;
        init_quat;
        init_lin_vel;
        init_ang_vel]; 
    func = @(time, state) rocket_ode(time, state, vehicle, env);
    [time, state] = ode45(func, (START_TIME:TIME_STEP:END_TIME), state_init);
end