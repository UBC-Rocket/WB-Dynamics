function C = euler_to_mat(phi, theta, psi)
%EULER_TO_MAT Converts euler rotations to a 3x3 rotation matrix
%   The rotation matrix corresponds to a right handed coordinate system
%   where the positve x and y axes point out and right respectively forming
%   a plane and the postive z axis points up. If you want a diagram to help
%   check out this link: 
%   https://phas.ubc.ca/~berciu/TEACHING/PHYS206/LECTURES/FILES/euler.pdf
%   
%   The rotation is done in the order of XYZ, where phi is a rotation
%   around the x axis, theta is a rotation around the y axis and psi is a 
%   rotation around the z axis. The
%   input angles are all in degrees.
%
%   Input:
%       phi   : rotation in radians around original x axis
%       theta : rotation in radians around new y axis after rotation around
%               x axis
%       psi   : rotation in radians around new z axis after rotation around
%               x axis then rotation around new y axis
%   Ouput:
%       C     : 3x3 rotation matrix representing the same rotation
%

    %% Rotate around x axis
    C1 = [
        1  0          0;
        0  cosd(phi) -sind(phi);
        0  sind(phi)  cosd(phi)];
    
    %% Rotate around y axis
    C2 = [
         cosd(theta) 0  sind(theta);
         0           1  0;
        -sind(theta) 0  cosd(theta)];
    
    %% Rotate around z axis
    C3 = [
        cosd(psi) -sind(psi) 0;
        sind(psi)  cosd(psi) 0;
        0          0         1];
    
    %% Overall transformation
    C = C3*C2*C1;
end

