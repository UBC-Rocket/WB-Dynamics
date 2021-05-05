function t_damp = t_thrust_damp(time, CG, omega, vehicle)
%T_THRUST_DAMP Computes thrust damping moment acting on vehicle
%   Source:
%   https://www.researchgate.net/figure/Code-block-diagram-for-the-core-rocket-simulation-routine_fig2_245307313
%   It seems that the paper wasn't super accurate about CD for supersonic
%   ranges compared to sources such as RASAero so I'm not sure about the
%   paper's reliability..
%
%   Input:
%       time: time in seconds since ignition
%       CG: center of gravity of vehicle in body coordinates relative to
%           base of vehicle
%       omega: angular velocity vector of vehicle in radians/s
%       vehicle: struct holding vehicle properties. See `rocket_nominal`
%           function to see all fields that this struct contains
%   Ouput:
%       t_damp: torque caused by thrust damping in N m
%

    if time < vehicle.burn_time
        t_damp = -vehicle.prop_flow_rate*cross(-CG, cross(omega, -CG));
    else
        t_damp = zeros(3,1);
    end
end

