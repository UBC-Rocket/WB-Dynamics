function CD_fin = C_d_fin(mach_num, vehicle, env)
    A_le = deg2rad(vehicle.fin_leading_edge_sweep_angle);
    S_le = deg2rad(vehicle.fin_leading_edge_thickness_angle);
    t_mac = vehicle.fin_thickness;
    span = vehicle.fin_span;
    S_r = pi*(vehicle.fuselage_diameter/2)^2;
    M_A = mach_num*cos(A_le);
    if M_A > 1
        eq_1 = vehicle.num_of_fins*2/(env.sp_heat_ratio*mach_num^2);
        eq_2 = (((env.sp_heat_ratio+1)*mach_num^2)/2)...
            ^(env.sp_heat_ratio/(env.sp_heat_ratio-1));
        eq_3 = ((env.sp_heat_ratio+1)...
            /(2*env.sp_heat_ratio*mach_num^2 - (env.sp_heat_ratio-1)))...
            ^(1/(env.sp_heat_ratio-1));
        eq_4 = sin(S_le)^2*cos(A_le)*t_mac*span/S_r;
        CD_fin = eq_1 * ((eq_2*eq_3) - 1) * eq_4;
    else
        CD_fin = 0;
    end
end
