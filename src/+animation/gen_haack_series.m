function [X, Y, Z] = gen_haack_series(radius, length, C, origin_x, origin_y, origin_z)
%GEN_HAACK_SERIES Summary of this function goes here
%   Detailed explanation goes here
    x = linspace(0, length);

    theta = acos(1-(2*x)/(length));
    y = radius*sqrt((theta-sin(2*theta)/2+C*(sin(theta)).^3))/(sqrt(pi));
    
    [X, Y, Z] = cylinder(y);
    
    X=X + origin_x;
    Y=Y + origin_y;
    Z=-Z*length + length + origin_z;
end
