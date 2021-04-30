function state_dot = rocket_ode(time, state, vehicle, env)
%ROCKET_ODE Computes velocity, quaternion derivative, accleration, angular
%acceleration
    pos = state(1:3);
    q = state(4:7);
    v = state(8:10); % ground speed
    omega = state(11:13);
    roll_axis = coordinate.to_inertial_frame(q, vehicle.roll_axis_body);
    thrust_dir = coordinate.to_inertial_frame(q, vehicle.thrust_dir_body);
    
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
    f_thrust = f_t(thrust_dir, time, vehicle, env);
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
    if (pos(3) < vehicle.rail_length*sind(vehicle.launch_angle) + vehicle.launch_alt) && (v(3) >= 0)
        f_gravity_mag = dot(f_gravity, roll_axis);
        f_thrust_mag = dot(f_thrust, roll_axis);
        f_aero_mag = dot(f_aero, roll_axis);
        f_net_mag = f_gravity_mag + f_thrust_mag + f_aero_mag;
        v_dot = f_net_mag/m*roll_axis;
        q_dot = zeros(4,1);
        omega_dot = zeros(3,1);
        state_dot = [
            v;
            q_dot;
            v_dot;
            omega_dot];
    else
        f_net = f_gravity + f_thrust + f_aero + f_ballute + f_chute;
        v_dot = f_net/m;

        % Compute torque.
        t_aero = cross(CP - CG, coordinate.to_body_frame(q, f_aero));
        t_thrust = cross(-CG, norm(f_thrust)*vehicle.thrust_dir_body);
        t_ballute = cross(...
            vehicle.chute_attachment_rel_base - CG,...
            coordinate.to_body_frame(q, f_ballute));
        t_chute = cross(...
            vehicle.chute_attachment_rel_base - CG,...
            coordinate.to_body_frame(q, f_chute));
        t_damp = t_thrust_damp(time, CG, omega, vehicle);
        t_net = t_aero + t_thrust + t_ballute + t_chute + t_damp;
        omega_dot = moi\(t_net - cross(omega,moi*omega));
        % Derivative
        q_dot = lin_alg.quat_dot(omega, q);
        state_dot = [
            v;
            q_dot;
            v_dot;
            omega_dot];
    end
end

