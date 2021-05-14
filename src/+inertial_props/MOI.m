%% Computes the moment of inertia matrix of the rocket.
% Assumes rocket is a solid cylinder with axis of rotation
% along midway points. Note that the actual center of mass
% is not at the axis of rotation but it is a decent approximation.
% Fix this to account for non-centered CG along cylinder.
function moment_of_inertia = MOI(mass, vehicle)
%MOMENT_OF_INERTIA Computes moment of inertia matrix of vehicle
%   Assumes rocket is a solid cylinder with axis of rotation
%   along midway points. Note that the actual center of mass
%   is not at the axis of rotation but it is a decent approximation.
%   Fix this to account for non-centered CG along cylinder.
%
%   Input:
%       mass: mass of vehicle in kg
%       vehicle: struct holding vehicle properties. See `rocket_nominal`
%           function to see all fields that this struct contains
%   Output:
%       moment_of_inertia: 3x3 moment of inertia matrix where diagonal
%       entries represents the MOI with respect to the rotation axes of x, 
%       y, z respectively
%
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