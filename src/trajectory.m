function [time, state] = trajectory(vehicle, env, end_time, step_size)
%TRAJECTORY Computes the trajectory of the vehicle
%
%   Input:
%       vehicle : struct containing all properties of the vehicle. See the
%                 function `rocket_nominal` to see what fields this struct
%                 should have.
%       end_time : end time of simulation in seconds
%       step_size : integration step size in seconds. I use integration step
%                   size as a loose term here as it only really affects the
%                   number of entries that are returned. ODE45 does not
%                   actually strictly follow this step size as it is an
%                   adaptive integrator meaning it will decrease / increase
%                   step size based on the error term. 
%   Output:
%       time    : vector of all time steps that the state was computed for.
%                 The size is from zero to `end_time` with each entry being
%                 `step_size` larger than the last.
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
    function [value, isterminal, direction] = detect_landing(t,y)
        value = real(y(3))-vehicle.launch_alt;
        isterminal = 1;
        direction = -1;
    end
    START_TIME = 0;

    init_pos = [0;0;vehicle.launch_alt];
    init_quat = lin_alg.euler_to_quat([0;-vehicle.launch_angle;0]);
    init_lin_vel = zeros(3,1);
    init_ang_vel = zeros(3,1);

    state_init = [
        init_pos;
        init_quat;
        init_lin_vel;
        init_ang_vel;
    ]; 
    %options = odeset('RelTol',1e-8,'AbsTol',1e-10, 'InitialStep', 1e-8);
    options = odeset('Events',@detect_landing);
    func = @(time, state) rocket_ode(time, state, vehicle, env);
    [time, state] = ode45(func, (START_TIME:step_size:end_time), state_init, options);
end

