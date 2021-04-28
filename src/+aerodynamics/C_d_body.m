function Cd_body = C_d_body(mach_num, vehicle, env)
    body_length = vehicle.fuselage_length - vehicle.nose_length;
    AR_B = body_length/vehicle.fuselage_diameter;
    Cd_body = 0.053*(AR_B)...
        *(mach_num/(aerodynamics.dynamic_pressure(mach_num, env)...
        *vehicle.fuselage_length))^(0.2);
end
