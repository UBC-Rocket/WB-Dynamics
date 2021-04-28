function state_dot = rocket_ode(time, state, vehicle, env)
%ROCKET_ODE Summary of this function goes here
%   Detailed explanation goes here
    pos = state(1:3);
    q = state(4:7);
    v = state(8:10); % ground speed
    omega = state(11:13);
    
    dir = coordinate.to_inertial_frame(q, [1;0;0]);
    
    % Update inertial properties.
    m = mass(time, vehicle);
    moi = MOI(m, vehicle);
    
    CP = CP_rel_base();
    CG = CG_rel_base(vehicle, time);
    
    % Update environment.
    [env.density, env.sound_speed, env.temperature, env.pressure] =...
        atmos(pos(3));
    
    % Not 100% sure about the derivations of the formulas but found it from a paper
    % https://www.researchgate.net/figure/Code-block-diagram-for-the-core-rocket-simulation-routine_fig2_245307313
    % It seems that the paper wasn't super accurate about CD for supersonic
    % ranges so I'm not sure about the paper's reliability...
    v_cm = v - env.wind_vel;
    roll_axis = coordinate.to_inertial_frame(q, [1;0;0]);
    v_omega = norm(CP-CG)*sin(acos(dot(roll_axis,normalize_vec(omega))))*cross(roll_axis, omega);
    
    v_apparent = v_cm + v_omega;
    
    % Compute forces.
    f_gravity = f_g(m, pos(3));
    f_aero = f_a(v_apparent, time, vehicle, env);
    f_thrust = f_t(dir, time, vehicle, env);
    
    f_net = f_gravity + f_thrust + f_aero;
    v_dot = f_net/m;
    
    % Compute torque.
    t_aero = cross(CP-CG, coordinate.to_body_frame(q, f_aero));
    t_net = t_aero;
    omega_dot = moi\(t_net - cross(omega,moi*omega));
    
    % Derivative
    q_dot = coordinate.quat_dot(omega, q);
    state_dot = [
        v;
        q_dot;
        v_dot;
        omega_dot];
end

