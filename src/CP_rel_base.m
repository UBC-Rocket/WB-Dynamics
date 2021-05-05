function CP_pos = CP_rel_base(vehicle)
%CP_REL_BASE Computes CP of vehicle relative to base
%   At the moment CP is a static value until better model is obtained
%
%   Input:
%       vehicle: struct holding vehicle properties. See `rocket_nominal`
%           function to see all fields that this struct contains
%   Ouput:
%       CP_pos: position of center of pressure in body coordinates relative
%       to base of vehicle
%
    CP_pos_nominal = 0.625;
    CP_pos_final = sampling.apply_uncertainty(...
        CP_pos_nominal,...
        vehicle.CP_uncertainty);
    CP_pos = [CP_pos_final; 0; 0];
end