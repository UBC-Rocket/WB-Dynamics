function f_gravity = f_g(m, p)
%F_G Summary of this function goes here
%   Detailed explanation goes here
    G = 6.6743e-11;
    M_e = 5.972e24;
    r = 6371000;
    R = r + p;
    f_gravity = [0; -G*M_e*m/(R^2); 0];
end

