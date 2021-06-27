function theta_in_rad = vec_ang(u, v)
%VEC_ANG Computes angle in degrees between two vectors
%   Input:
%       u: First vector
%       v: Second vector
%   Note that vectors u and v must be the same shape.
%   Output:
%       theta_in_rad: Angle between vectors u and v in
%                     RADIANS    
%   Have to take the real part because there is a potential
%   that due to errors that cos_theta might be bigger than 1.
%   See link here: 
%   https://www.mathworks.com/matlabcentral/answers/101590-how-can-i-determine-the-angle-between-two-vectors-in-matlab
    cos_theta = max(min(dot(u,v)/(norm(u)*norm(v)),1),-1);
    theta_in_rad = real(acos(cos_theta));
end

