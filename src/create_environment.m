function env = create_environment()
% Creates a structure with fields that represent atmosphere conditions. The
% fields are initialized with sea level values.
    [env.density,env.sound_speed,env.temperature,env.pressure] = atmos(0);
    % Specific heat ratio of air. We are assuming this is independent from
    % altitude from surface.
    env.sp_heat_ratio = 1.4;
    % force on a 1 kg mass is equal in magnitude to the acceleration.
    env.grav_accel_SL = norm(f_g(1,0));
end

