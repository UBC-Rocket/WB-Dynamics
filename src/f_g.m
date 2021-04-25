function f_gravity = f_g(m, p)
%Compute gravitational force of Earth on a mass `m` at a distance of `p`
%from the surface.
    % G obtained from:
    % Atmospheric and Space Flight Dynamics Modeling and Simulation with MATLAB® 
    % by Ashish Tewari
    G = 6.67259e-11;
    % Mass of Earth and radius of Earth obtained from:
    % https://nssdc.gsfc.nasa.gov/planetary/factsheet/earthfact.html
    M_e = 5.972e24;
    % Volumetric mean radius since this model the Earth is assumed to be a
    % perfect sphere.
    r = 6371000;
    R = r + p;
    f_gravity = [0; -G*M_e*m/(R^2); 0];
end

