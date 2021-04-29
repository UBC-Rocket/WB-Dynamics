function m = mass(time, vehicle, uncertainties)
%MASS Summary of this function goes here
%   Detailed explanation goes here
    load_mass = sampling.apply_uncertainty(...
        vehicle.load_mass,...
        'load_mass',...
        uncertainties);
    if time <= vehicle.burn_time
        m = load_mass - vehicle.prop_flow_rate*time;
    else
        m = load_mass - vehicle.prop_flow_rate*vehicle.burn_time;
    end
end

