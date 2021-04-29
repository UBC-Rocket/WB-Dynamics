function m = mass(time, vehicle)
%MASS Mass of vehicle at a given time.
%   Assumes propellant flow rate is constant
    if time <= vehicle.burn_time
        m = vehicle.load_mass - vehicle.prop_flow_rate*time;
    else
        m = vehicle.load_mass - vehicle.prop_flow_rate*vehicle.burn_time;
    end
end

