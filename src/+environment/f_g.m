function f_gravity = f_g(m, p)
%F_G Compute gravitational force of Earth on a mass
%   The earth is assumed to be a perfect sphere.
%
%   Input:
%       m         : mass in kg
%       p         : distance from surface of the Earth in meters
%   Ouput:
%       f_gravity : force of gravity exerted on mass
%
% Gravitational constant obtained from:
% Atmospheric and Space Flight Dynamics Modeling and Simulation with MATLAB® 
% by Ashish Tewari
%
% Mass of Earth and radius of Earth obtained from:
% https://nssdc.gsfc.nasa.gov/planetary/factsheet/earthfact.html
%
    G = 6.67259e-11;    % Gravitational constant
    M_e = 5.972e24;     % Mass of Earth in kg
    r = 6371000;        % Volumetric mean radius of Earth in meters
    
    R = r + p;
    f_gravity = [0; 0; -G*M_e*m/(R^2)];
end

