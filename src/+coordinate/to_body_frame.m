function v_prime = to_body_frame(q, v)
%TO_BODY_FRAME Rotates a R^3 vector to the vehicle's frame.
%   Given a quaternion `q` in the form of [x,y,z,w] that represents the
%   orientation of the body frame relative to the inertial frame, the
%   vector `v` in the inertial frame is transformed to the body frame.
%   reference link:
%   https://www.mathworks.com/help/fusion/ref/quaternion.rotmat.html#d123e13248
%   
%   Input:
%       q       : quaternion in the form of [x,y,z,w] that represents the
%                 orientation of the body frame relative to the inertial 
%                 frame
%       v       : vector in R^3 in the inertial frame coordinates
%   Ouput:
%       v_prime : vector v in body frame coordinates
    x = q(1);
    y = q(2);
    z = q(3);
    w = q(4);
    
    C = 2*[
        0.5*(w^2 + x^2 - y^2 - z^2), x*y + w*z, x*z - w*y;
        x*y - w*z, 0.5*(w^2 - x^2 + y^2 - z^2), y*z + w*x;
        x*z + w*y, y*z - w*x, 0.5*(w^2 - x^2 - y^2 + z^2)];
    
    v_prime = C * v;     
end

