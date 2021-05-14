function m = mass(time, vehicle)
%MASS Mass of vehicle at a given time.
%   Assumes propellant flow rate is constant
%
%   Input:
%       time: current time in seconds
%       vehicle: struct holding vehicle properties. See `rocket_nominal`
%           function to see all fields that this struct contains
%   Ouput:
%       m: mass of vehicle in kg
%
    if time <= vehicle.burn_time
        m = vehicle.load_mass - vehicle.prop_flow_rate*time;
    else
        m = vehicle.load_mass - vehicle.prop_flow_rate*vehicle.burn_time;
    end
end

