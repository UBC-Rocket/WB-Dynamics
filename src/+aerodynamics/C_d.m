function Cd = C_d(mach_num, time, vehicle, env, uncertainties)
%C_D Computes CD of vehicle
%   Sums the CD of each component together to get total CD.
    Cd_nominal = aerodynamics.C_d_nose(mach_num, vehicle)...
        + aerodynamics.C_d_body(mach_num, vehicle, env)...
        + aerodynamics.C_d_base(time, mach_num, vehicle)...
        + aerodynamics.C_d_fin(mach_num, vehicle, env);
    % Final Cd
    Cd = sampling.apply_uncertainty(Cd_nominal, 'CD_vehicle', uncertainties);  
end
