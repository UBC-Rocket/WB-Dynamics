function [nose, body, fin1, fin2, fin3, fin4] = gen_rocket(vehicle)
    body_length = vehicle.fuselage_length - vehicle.nose_length;
    [x_b,y_b,z_b] = animation.gen_body(...
        vehicle.fuselage_diameter/2,...
        body_length,...
        0,...
        0,...
        0);
    body(:,:,1) = x_b;
    body(:,:,2) = y_b;
    body(:,:,3) = z_b;
    
    [x_n, y_n, z_n] = animation.gen_haack_series(...
        vehicle.fuselage_diameter/2,...
        body_length,...
        0,...
        0,...
        0,...
        vehicle.body_length);
    
    nose(:,:,1) = x_n;
    nose(:,:,2) = y_n;
    nose(:,:,3) = z_n;
    
    [x_f1, y_f1, z_f1] = animation.gen_fin(vehicle, vehicle.fuselage_diameter/2, 0);
    [x_f2, y_f2, z_f2] = animation.gen_fin(vehicle, vehicle.fuselage_diameter/2, 90);
    [x_f3, y_f3, z_f3] = animation.gen_fin(vehicle, vehicle.fuselage_diameter/2, 180);
    [x_f4, y_f4, z_f4] = animation.gen_fin(vehicle, vehicle.fuselage_diameter/2, 270);
    
    fin1 = [
        x_f1;
        y_f1;
        z_f1];
    fin2 = [
        x_f2;
        y_f2;
        z_f2];
    fin3 = [
        x_f3;
        y_f3;
        z_f3];
    fin4 = [
        x_f4;
        y_f4;
        z_f4];
end