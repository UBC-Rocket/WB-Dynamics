function CP_pos = CP_rel_base(uncertainties)
    CP_pos_mag = 0.625;
    CP_pos_final = sampling.apply_uncertainty(CP_pos_mag, 'CP', uncertainties);
    CP_pos = [CP_pos_final; 0; 0];
end