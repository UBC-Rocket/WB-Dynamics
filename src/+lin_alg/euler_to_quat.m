function q = euler_to_quat(r)
%EULER_TO_QUAT Converts Euler angles given as XYZ to quaternion.
%   All angles are given in degrees.
%
%   Input:
%       r : vector of length three representing a rotation in the order of 
%           x,y,z in radians
%   Ouput:
%       q : quaternion in the form of [x,y,z,w] representing the same
%           rotation
%
%   Link to reference:
%
%   https://math.stackexchange.com/questions/2975109/how-to-convert-euler-
%   angles-to-quaternions-and-get-the-same-euler-angles-back-fr
%
    yaw = r(1);
    pitch = r(2);
    roll = r(3);
    
    qx = sind(yaw/2) * cosd(pitch/2) * cosd(roll/2) + cosd(yaw/2) * sind(pitch/2) * sind(roll/2);
    qy = cosd(yaw/2) * sind(pitch/2) * cosd(roll/2) - sind(yaw/2) * cosd(pitch/2) * sind(roll/2);
    qz = cosd(yaw/2) * cosd(pitch/2) * sind(roll/2) + sind(yaw/2) * sind(pitch/2) * cosd(roll/2);
    qw = cosd(yaw/2) * cosd(pitch/2) * cosd(roll/2) - sind(yaw/2) * sind(pitch/2) * sind(roll/2);
    q = [qx; qy; qz; qw];
end

