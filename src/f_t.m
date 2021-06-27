function f_thrust = f_t(dir, time, vehicle, env)
%F_T Computes thrust force produced by engine
%   The thrust force is computed based on time since ignition and
%   atmosphere pressure
%
%   Input:
%       dir: unit vector pointing in direction of thrust force
%       time: time in seconds since ignition
%       vehicle: struct holding vehicle properties. See `rocket_nominal`
%           function to see all fields that this struct contains
%       env: struct that holds all properties of the environment. See
%           `environment.create_environment` function to see all fields that
%           this structure should have.
%   Output:
%       f_thrust: Thrust force vector in Newtons
%
    if time <= vehicle.burn_time
        sp_impulse =...
            vehicle.nozzle_eff*(vehicle.c_star*env.sp_heat_ratio/env.grav_accel_SL...
            *sqrt((2/(env.sp_heat_ratio - 1))*((2/(env.sp_heat_ratio + 1))...
            ^((env.sp_heat_ratio + 1)/(env.sp_heat_ratio - 1)))...
            *(1 - ((vehicle.exit_pressure/vehicle.chamber_pressure)...
            ^((env.sp_heat_ratio - 1)/env.sp_heat_ratio)))) + vehicle.c_star...
            *vehicle.exp_area_ratio/(env.grav_accel_SL*vehicle.chamber_pressure)...
            *(vehicle.exit_pressure - env.pressure));
        thrust_nominal = sp_impulse*vehicle.prop_flow_rate*env.grav_accel_SL;
        f_thrust_final = sampling.apply_uncertainty(...
            thrust_nominal,...
            vehicle.thrust_uncertainty);
        % Apply thrust misalignment. Since I do not know how to simulate an
        % induced roll, I am just going to assume that the horizontal
        % component of the thrust misalignment is just going to cancel out
        % and that the effective thrust would just be the vertical
        % component.
        f_thrust_eff = f_thrust_final * cosd(vehicle.thrust_misalign_angle);
        % Final vector value
        f_thrust = f_thrust_eff*dir;
    else
        f_thrust = [0;0;0];
    end
end

