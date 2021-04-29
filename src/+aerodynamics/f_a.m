function f_aero = f_a(v_apparent, time, vehicle, env)
%F_AERO Computes the drag force on the vehicle
%   PARAMS:
%       v_apparent:  Velocity of vehicle relative to atmosphere.
%       time: Time since ignition.
%       vehicle: Struct containing static vehicle properties.
%       env:    Struct containing environment properties.
    S = pi*(vehicle.fuselage_diameter/2)^2;
    mach_num = norm(v_apparent)/env.sound_speed;

    % If the rocket has velocity zero, there is no drag.
    if mach_num <= 0
        f_aero = [0; 0; 0];
    else
        CD = aerodynamics.C_d(mach_num, time, vehicle, env);
        f_aero = -0.5*env.density*norm(v_apparent)*S*CD*v_apparent;
    end
end

