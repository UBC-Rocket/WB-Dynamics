function force_chute = f_chute(...
    altitude,...
    v_ground,...
    v_apparent,...
    vehicle,...
    env)
%F_CHUTE Computes force from chutes.
%   Relatively simply model.
%   Advanced model here:
%   https://www.researchgate.net/publication/238563816_Six-Degree-of-Freedom_Model_of_a_Controlled_Circular_Parachute
%
%   Input:
%       altitude   : altitude above sea level in meters
%       v_ground   : ground relative velocity of chute
%       v_apparent : atmosphere relative velocity of chute
%       vehicle    : struct holding vehicle properties. See `rocket_nominal`
%                    function to see all fields that this struct contains
%       env        : struct that holds all properties of the environment. 
%                    See `environment.create_environment` function to see 
%                    all fields that this structure should have.
%   Output:
%       force_chute: Force from chute(s) in inertial coordinates.
    if (v_ground(3) < 0) && (altitude <= vehicle.main_chute_alt)
        total_area = vehicle.num_of_chutes*pi*(vehicle.main_chute_dia/2)^2;
        force_chute = ...
            -0.5*vehicle.main_chute_drag_coeff*env.density*total_area...
            *norm(v_apparent)*v_apparent;
    else
        force_chute = [0;0;0];
    end
end
