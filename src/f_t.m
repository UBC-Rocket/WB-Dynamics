function f_thrust = f_t(dir, time, vehicle, env)
%F_T Computes thrust force produced by engine at a given time and
%atmosphere condition.
%   `dir` must be a unit vector that points in the direction of the thrust
%   force.
    if time <= vehicle.burn_time
        sp_impulse =...
            vehicle.nozzle_eff*(vehicle.c_star*env.sp_heat_ratio/env.grav_accel_SL...
            *sqrt((2/(env.sp_heat_ratio - 1))*((2/(env.sp_heat_ratio + 1))...
            ^((env.sp_heat_ratio + 1)/(env.sp_heat_ratio - 1)))...
            *(1 - ((vehicle.exit_pressure/vehicle.chamber_pressure)...
            ^((env.sp_heat_ratio - 1)/env.sp_heat_ratio)))) + vehicle.c_star...
            *vehicle.exp_area_ratio/(env.grav_accel_SL*vehicle.chamber_pressure)...
            *(vehicle.exit_pressure - env.pressure));
        f_thrust = sp_impulse*vehicle.prop_flow_rate*env.grav_accel_SL*dir;
    else
        f_thrust = [0;0;0];
    end
end

