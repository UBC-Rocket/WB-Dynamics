function CD_fin = C_d_fin(mach_num, vehicle, env)
    M_A = mach_num*cos(vehicle.A_le);
    if M_A > 1
        eq_1 = vehicle.num_of_fins*2/(env.sp_heat_ratio*mach_num^2);
        eq_2 = (((env.sp_heat_ratio+1)*mach_num^2)/2)...
            ^(env.sp_heat_ratio/(env.sp_heat_ratio-1));
        eq_3 = ((env.sp_heat_ratio+1)...
            /(2*env.sp_heat_ratio*mach_num^2 - (env.sp_heat_ratio-1)))...
            ^(1/(env.sp_heat_ratio-1));
        eq_4 = sind(vehicle.S_le)^2*cosd(vehicle.A_le)*vehicle.fin_thickness...
            *vehicle.fin_span/vehicle.S_r;
        CD_fin = eq_1 * ((eq_2*eq_3) - 1) * eq_4;
    else
        CD_fin = 0;
    end
end
