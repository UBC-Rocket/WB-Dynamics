function state_dot = rocket_ode(time, state, vehicle, env)
%ROCKET_ODE Computes velocity, quaternion derivative, accleration, angular
%acceleration
    pos = state(1:3);
    q = state(4:7);
    v = state(8:10); % ground speed
    omega = state(11:13);
    
    roll_axis = coordinate.to_inertial_frame(q, [1;0;0]);
    
    % Update inertial properties.
    m = mass(time, vehicle);
    moi = MOI(m, vehicle);
    
    CP = CP_rel_base(vehicle);
    CG = CG_rel_base(vehicle, time);
    
    % Update environment.
    [env.density, env.sound_speed, env.temperature, env.pressure] =...
        environment.atmos(pos(3));
    
    v_apparent_rocket = vel_apparent_rocket(...
        CP,...
        CG,...
        roll_axis,...
        v,...
        omega,...
        env);
    v_apparent_recovery = recovery.vel_apparent_chute(v, env);
    
    % Compute forces.
    f_gravity = environment.f_g(m, pos(3));
    f_aero = aerodynamics.f_a(v_apparent_rocket, time, vehicle, env);
    f_thrust = f_t(roll_axis, time, vehicle, env);
    f_ballute = recovery.f_ballute(...
        pos(3),...
        v,...
        v_apparent_recovery,...
        vehicle,...
        env);
    f_chute = recovery.f_chute(...
        pos(3),...
        v,...
        v_apparent_recovery,...
        vehicle,...
        env);
    
    f_net = f_gravity + f_thrust + f_aero + f_ballute + f_chute;
    v_dot = f_net/m;
    
    % Compute torque.
    t_aero = cross(CP - CG, coordinate.to_body_frame(q, f_aero));
    t_ballute = cross(...
        vehicle.chute_attachment_rel_base - CG,...
        coordinate.to_body_frame(q, f_ballute));
    t_chute = cross(...
        vehicle.chute_attachment_rel_base - CG,...
        coordinate.to_body_frame(q, f_chute));
    t_net = t_aero + t_ballute + t_chute;
    omega_dot = moi\(t_net - cross(omega,moi*omega));
    
    % Derivative
    q_dot = lin_alg.quat_dot(omega, q);
    state_dot = [
        v;
        q_dot;
        v_dot;
        omega_dot];
end

