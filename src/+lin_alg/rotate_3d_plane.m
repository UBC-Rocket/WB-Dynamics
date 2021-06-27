function new_mat = rotate_3d_plane(plane, quat)
%ROTATE_FIN Summary of this function goes here
%   Detailed explanation goes here
    [h, w] = size(plane);
    
    new_mat = zeros(h, w);
    
    for i = 1:w
        point = plane(:,i);
        new_mat(:,i) = coordinate.to_inertial_frame(quat, point);
    end
end

