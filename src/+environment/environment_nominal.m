function env = environment_nominal()
%CREATE_ENVIRONMENT Creates a struct that represent atmosphere conditions. 
%   The fields are initialized with sea level values.
%
%   Output:
%       env: struct holding values that represent atmosphere conditions.
%            Contains the fields:
%               - density : density of air in kg/m^3
%               - sound_speed : speed of sound in m/s
%               - temperature : atmosphere temperature in K
%               - pressure : pressure of air in Pa
%               - sp_heat_ratio : Specific heat ratio of air
%               - grav_accel_SL : gravitational acceleration at sea level 
%                   in m/s^2
%               - wind_vel : Velocity of wind in m/s
%

    % Somewhat annoying how you must namespace even though you are in the
    % namespace itself...
    [env.density,env.sound_speed,env.temperature,env.pressure] = ...
        environment.atmos(0);
    % Specific heat ratio of air. We are assuming this is independent from
    % altitude from surface.
    env.sp_heat_ratio = 1.4;
    % Force on a 1 kg mass is equal in magnitude to the acceleration.
    env.grav_accel_SL = norm(environment.f_g(1,0));
        
    env.wind_meridional_uncertainty = sampling.create_uncertainty(0,0);
    env.wind_zonal_uncertainty = sampling.create_uncertainty(0,0);
    env.wind_vel = environment.wind(0, 0, env);
end

