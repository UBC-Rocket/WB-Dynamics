function state_dot = rocket_ode(time, state, vehicle, env)
%ROCKET_ODE Summary of this function goes here
%   Detailed explanation goes here
    pos = state(1:3);
    v = state(4:6);
    
    dir = [
        cosd(vehicle.launch_angle);
        0;
        sind(vehicle.launch_angle)];
    
    % Update inertial properties.
    m = mass(time, vehicle);
    
    % Update environment.
    [env.density, env.sound_speed, env.temperature, env.pressure] =...
        atmos(pos(3));
    
    % Compute forces.
    f_gravity = f_g(m, pos(3));
    f_aero = f_a(v, time, vehicle, env);
    f_thrust = f_t(dir, time, vehicle, env);
    
    f_net = f_gravity + f_thrust + f_aero;
    a = f_net/m;
    state_dot = [
        v;
        a];
end

