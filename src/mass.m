function m = mass(time, vehicle)
%MASS Summary of this function goes here
%   Detailed explanation goes here
    if time <= vehicle.burn_time
        m = vehicle.load_mass - vehicle.prop_flow_rate*time;
    else
        m = vehicle.load_mass - vehicle.prop_flow_rate*vehicle.burn_time;
    end
end

