function v_apparent = vel_apparent_rocket(CP, CG, roll_axis, v, omega, env)
%VELOCITY_APPARENT_ROCKET Velocity of the vehicle relative to the atmosphere.
%   Not 100% sure about the derivations of the formulas but found it from a
%   paper, link:
%   https://www.researchgate.net/figure/Code-block-diagram-for-the-core-rocket-simulation-routine_fig2_245307313
%   It seems that the paper wasn't super accurate about CD for supersonic
%   ranges compared to sources such as RASAero so I'm not sure about the
%   paper's reliability...
%   Input:
%       CP: Center of pressure of vehicle relative to base in body
%           coordinates.
%       CG: Center of gravity of vehicle relative to base in body
%           coordinates.
%       roll_axis: Vector representing the axis in which the vehicle rolls.
%       v:  Velocity of vehicle relative to ground in inertial coordinates.
%       omega: Angular velocity.
%       env: struct that holds all properties of the environment. See
%           `environment.create_environment` function to see all fields that
%           this structure should have.
%   Output:
%       v_apparent: velocity of vehicle relative to atmosphere vector in
%           m/s
%
    v_cm = v - env.wind_vel;
    v_omega = norm(CP-CG)...
        *sin(acos(dot(roll_axis,lin_alg.normalize_vec(omega))))...
        *cross(roll_axis, omega);
    
    v_apparent = v_cm + v_omega;
end

