function f_aero = f_a(v, time, vehicle, env)
    S = pi*(vehicle.fuselage_diameter/2)^2;
    mach_num = norm(v)/env.sound_speed;

    % If the rocket has velocity zero, there is no drag.
    if norm(v) <= 1e-6
        f_aero = [0; 0; 0];
    else
        CD = aerodynamics.C_d(mach_num, time, vehicle, env);
        f_aero = -0.5*env.density*norm(v)*S*CD*v;
    end
end

