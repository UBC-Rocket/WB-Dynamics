function env = environment_nominal(wind_dir)
%CREATE_ENVIRONMENT Creates a struct that represent atmosphere conditions. 
%   The fields are initialized with sea level values.
%   
%   Input:
%       wind_dir: wind direction in degrees. Must be 8x1 matrix. Each
%                 entry represents the wind direction in inertial frame
%                 for a specific altitude category. Index 1 represents
%                 the altitude 0 to 10000 km. Index 8 represents the
%                 altitude 110000 km and up. See `environment.wind_vec`
%                 for more details about altitude categories.
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
    
    [h, w] = size(wind_dir);
    if ~((h == 8) && (w == 1))
        ME = MException(...
            'environment:bad_wind_dir',...
            'Error, given wind dir is not the correct size of 8x1');
        throw(ME);
    else
        env.wind_dir = wind_dir;
    end
    
    env.wind_speed_uncertainty = sampling.create_uncertainty(0,0);
    env.wind_vel = environment.wind(0, env.wind_dir, env.wind_speed_uncertainty);
end

