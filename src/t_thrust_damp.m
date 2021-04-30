function t_damp = t_thrust_damp(time, CG, omega, vehicle)
%T_THRUST_DAMP Summary of this function goes here
%   Detailed explanation goes here
    if time < vehicle.burn_time
        t_damp = -vehicle.prop_flow_rate*cross(-CG, cross(omega, -CG));
    else
        t_damp = zeros(3,1);
    end
end

