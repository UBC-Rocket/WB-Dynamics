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
%   input angles are all in RADIANS.
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
        0  cos(phi) -sin(phi);
        0  sin(phi)  cos(phi)];
    
    %% Rotate around y axis
    C2 = [
         cos(theta) 0  sin(theta);
         0          1  0;
        -sin(theta) 0  cos(theta)];
    
    %% Rotate around z axis
    C3 = [
        cos(psi) -sin(psi) 0;
        sin(psi)  cos(psi) 0;
        0         0        1];
    
    %% Overall transformation
    C = C3*C2*C1;
end

