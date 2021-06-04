function [nose, body, fin1, fin2, fin3, fin4] = gen_rocket(vehicle)
    rot_quat = lin_alg.euler_to_quat(0, pi/2, 0, 'XYZ');
    body_length = vehicle.fuselage_length - vehicle.nose_length;
    body = visualization.gen_body(...
        vehicle.fuselage_diameter/2,...
        body_length,...
        0,...
        0,...
        0);
    body = lin_alg.rotate_3d_obj(body, rot_quat);
    
    nose = visualization.gen_haack_series(...
        vehicle.fuselage_diameter/2,...
        vehicle.nose_length,...
        0,...
        0,...
        0,...
        vehicle.body_length);
    
    nose = lin_alg.rotate_3d_obj(nose, rot_quat);
    
    fin1 = visualization.gen_fin(vehicle, vehicle.fuselage_diameter/2, 0);
    fin2 = visualization.gen_fin(vehicle, vehicle.fuselage_diameter/2, 90);
    fin3 = visualization.gen_fin(vehicle, vehicle.fuselage_diameter/2, 180);
    fin4 = visualization.gen_fin(vehicle, vehicle.fuselage_diameter/2, 270);
    
    fin1 = lin_alg.rotate_3d_plane(fin1, rot_quat);
    fin2 = lin_alg.rotate_3d_plane(fin2, rot_quat);
    fin3 = lin_alg.rotate_3d_plane(fin3, rot_quat);
    fin4 = lin_alg.rotate_3d_plane(fin4, rot_quat);
end