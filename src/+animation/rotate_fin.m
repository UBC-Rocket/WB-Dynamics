function new_mat = rotate_fin(fin, quat)
%ROTATE_FIN Summary of this function goes here
%   Detailed explanation goes here
    [h, w] = size(fin);
    
    new_mat = zeros(h, w);
    
    for i = 1:w
        point = fin(:,i);
        new_mat(:,i) = coordinate.to_inertial_frame(quat, point);
    end
end

