function [x, y, z] = rotate_part(part, quat)
%ROTATE_PART Summary of this function goes here
%   Detailed explanation goes here
    [h, w, d] = size(part);
    
    new_mat = zeros(h, w, d);
    
    for i = 1:h
        for j = 1:w
            x = part(i,j,1);
            y = part(i,j,2);
            z = part(i,j,3);
            point = [x;y;z];
            new_mat(i,j,:) = coordinate.to_inertial_frame(quat, point)';
        end
    end
    x = new_mat(:,:,1);
    y = new_mat(:,:,2);
    z = new_mat(:,:,3);
end

