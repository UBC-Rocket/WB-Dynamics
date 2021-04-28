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
