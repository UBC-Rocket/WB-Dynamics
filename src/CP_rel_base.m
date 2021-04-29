function CP_pos = CP_rel_base(vehicle)
    CP_pos_nominal = 0.625;
    CP_pos_final = sampling.apply_uncertainty(...
        CP_pos_nominal,...
        vehicle.CP_uncertainty);
    CP_pos = [CP_pos_final; 0; 0];
end