function [x_f, y_f, z_f] = rotate_fin(fin, quat)
%ROTATE_FIN Summary of this function goes here
%   Detailed explanation goes here
    [h, w] = size(fin);
    
    new_mat = zeros(h, w);
    
    for i = 1:w
        point = fin(:,i);
        new_mat(:,i) = coordinate.to_inertial_frame(quat, point);
    end
    x_f = new_mat(1,:);
    y_f = new_mat(2,:);
    z_f = new_mat(3,:);
end

