function new_mat = rotate_3d_obj(obj, quat)
%ROTATE_PART Summary of this function goes here
%   Detailed explanation goes here
    [h, w, d] = size(obj);
    
    new_mat = zeros(h, w, d);
    
    for i = 1:h
        for j = 1:w
            x = obj(i,j,1);
            y = obj(i,j,2);
            z = obj(i,j,3);
            point = [x;y;z];
            new_mat(i,j,:) = coordinate.to_inertial_frame(quat, point)';
        end
    end
end

