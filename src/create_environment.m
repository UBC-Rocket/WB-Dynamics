function env = create_environment()
% Creates a structure with fields that represent
% atmosphere conditions. The initial values of
% atmosphere conditions are "garbage" values 
% and are meant to be updated.
    env.density = 0;
    env.sound_speed = 0;
    env.temperature = 0;
    env.pressure = 0;
    env.sp_heat_ratio = 1.4;
    env.grav_accel_SL = 9.81;
end

