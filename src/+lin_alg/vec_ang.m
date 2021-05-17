function theta_in_degrees = vec_ang(u, v)
%VEC_ANG Summary of this function goes here
%   Detailed explanation goes here
    cos_theta = max(min(dot(u,v)/(norm(u)*norm(v)),1),-1);
    theta_in_degrees = real(acosd(cos_theta));
end

