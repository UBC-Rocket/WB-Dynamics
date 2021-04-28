function q = dynamic_pressure(mach_num, env)
    q = 0.5*env.density*(mach_num*env.sound_speed)^2;
end
