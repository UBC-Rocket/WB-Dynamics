%% Computes the moment of inertia matrix of the rocket.
% Assumes rocket is a solid cylinder with axis of rotation
% along midway points. Note that the actual center of mass
% is not at the axis of rotation but it is a decent approximation.
% Fix this to account for non-centered CG along cylinder.
function moment_of_inertia = MOI(mass, vehicle)
    % First row of MOI matrix
    m11 = (1/2)*mass*(vehicle.fuselage_diameter/2)^2;
    m12 = 0;
    m13 = 0;

    % Second row of MOI matrix
    m21 = 0;
    m22 = (1/12)*mass*((3*vehicle.fuselage_diameter/2)^2 + vehicle.fuselage_length^2);
    m23 = 0;

    % Third row of MOI matrix
    m31 = 0;
    m32 = 0;
    m33 = (1/12)*mass*(3*(vehicle.fuselage_diameter/2)^2 + vehicle.fuselage_length^2);

    moment_of_inertia = [
        m11 m12 m13;
        m21 m22 m23;
        m31 m32 m33];
end