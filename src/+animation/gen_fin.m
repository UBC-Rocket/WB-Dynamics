function [x,y,z] = gen_fin(vehicle, body_radius, orientation)
%GEN_FIN Summary of this function goes here
%   Detailed explanation goes here
    fin_generation_mat = [
        cosd(orientation) sind(orientation) 0;
        -sind(orientation) cosd(orientation) 0;
        0 0 1];
    x = [0 0 vehicle.fin_span vehicle.fin_span] + body_radius;
    y = zeros(1, 4);
    
    z(1) = 0;
    z(2) = vehicle.fin_root_chord;
    z(3) = z(2) - vehicle.fin_span/tand(90 - vehicle.fin_leading_edge_sweep_angle);
    z(4) = z(3) - vehicle.fin_tip_chord;
    
    total_mat = [x;y;z];
    
    new_mat = zeros(3, length(x));
    
    for i = 1:length(x)
        point = total_mat(:, i);
        rot_point = fin_generation_mat * point;
        new_mat(:,i) = rot_point;
    end
    x = new_mat(1,:);
    y = new_mat(2,:);
    z = new_mat(3,:);
end
