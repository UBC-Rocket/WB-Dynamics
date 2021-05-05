function force_ballute = f_ballute(...
    altitude,...
    v_ground,...
    v_apparent,...
    vehicle,... 
    env)
%F_BALLUTE Computes force from ballutes.
%   Relatively simply model.
%   Advanced model here:
%   https://www.researchgate.net/publication/238563816_Six-Degree-of-Freedom_Model_of_a_Controlled_Circular_Parachute
%
%   Input:
%       altitude      : altitude above sea level in meters
%       v_ground      : ground relative velocity of ballute
%       v_apparent    : atmosphere relative velocity of ballute
%       vehicle       : struct holding vehicle properties. See `rocket_nominal`
%                       function to see all fields that this struct contains
%       env           : struct that holds all properties of the environment. 
%                       See `environment.create_environment` function to 
%                       see all fields that this structure should have.
%   Output:
%       force_ballute : Force from ballute(s) in inertial coordinates.
    if (v_ground(3) < 0) && (altitude <= vehicle.ballute_alt)
        total_area = vehicle.num_of_ballutes*pi*(vehicle.ballute_dia/2)^2;
        force_ballute = ...
            -0.5*vehicle.ballute_drag_coeff*env.density*total_area...
            *norm(v_apparent)*v_apparent;
    else
        force_ballute = [0;0;0];
    end
end
