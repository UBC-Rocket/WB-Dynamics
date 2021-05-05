function v_apparent = vel_apparent_chute(v, env)
%VEL_APPARENT_CHUTE Atmosphere relative velocity of the recovery device.
%   Honestly this is probably gonna need to be replaced with something
%   better.
%   
%   Input:
%       v          : ground relative velocity of chute
%       env        : struct that holds all properties of the environment. 
%                    See `environment.create_environment` function to see 
%                    all fields that this structure should have.
%   Output:
%       v_apparent : atmosphere relative velocity of device
    v_apparent = v - env.wind_vel;
end

