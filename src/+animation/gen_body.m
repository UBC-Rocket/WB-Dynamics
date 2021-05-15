function body = gen_body(radius, height, origin_x, origin_y, origin_z)
%GEN_CYLINDER Summary of this function goes here
%   Detailed explanation goes here    
    [x, y, z] = cylinder(radius);
    x = x + origin_x;
    y = y + origin_y;
    z = z*height + origin_z;
    body(:,:,1) = x;
    body(:,:,2) = y;
    body(:,:,3) = z;
end

