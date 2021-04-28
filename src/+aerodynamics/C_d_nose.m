function Cd_nose = C_d_nose(mach_num, vehicle)
    AR_N = vehicle.nose_length/vehicle.fuselage_diameter;
    if mach_num < 1
        Cd_nose = 0;
    else
        Cd_nose = 3.6/(AR_N*(mach_num-1)+3);
    end
end

