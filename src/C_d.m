function Cd = C_d(mach_num, time, vehicle, env)
%C_D Summary of this function goes here
%   Detailed explanation goes here
    Cd = C_d_nose(mach_num, vehicle)...
        + C_d_body(mach_num, vehicle, env)...
        + C_d_base(time, mach_num, vehicle);
end

function Cd_nose = C_d_nose(mach_num, vehicle)
    AR_N = vehicle.nose_length/vehicle.fuselage_diameter;
    if mach_num < 1
        Cd_nose = 0;
    else
        Cd_nose = 3.6/(AR_N*(mach_num-1)+3);
    end
end

function Cd_body = C_d_body(mach_num, vehicle, env)
    body_length = vehicle.fuselage_length - vehicle.nose_length;
    AR_B = body_length/vehicle.fuselage_diameter;
    Cd_body = 0.053*(AR_B)...
        *(mach_num/(dynamic_pressure(mach_num, env)...
        *vehicle.fuselage_length))^(0.2);
end

function Cd_base = C_d_base(time, mach_num, vehicle)
    A_e = vehicle.nozzle_exit_area;
    S_r = pi*(vehicle.fuselage_diameter/2)^2;
    if time <= vehicle.burn_time
        red_fac = (1-A_e/S_r);
        
        if mach_num < 1
            Cd_base = (0.12+0.13*mach_num^2)*red_fac;
        else
            Cd_base = 0.25/mach_num*red_fac;
        end
    else
        if mach_num < 1
            Cd_base = 0.12 + 0.13*mach_num^2;
        else
            Cd_base = 0.25/mach_num;
        end
    end
end

function q = dynamic_pressure(mach_num, env)
    q = 0.5*env.density*(mach_num*env.sound_speed)^2;
end


