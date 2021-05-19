function q = euler_to_quat(r1, r2, r3, sequence)
%EULER_TO_QUAT Converts Euler angles given as XYZ to quaternion.
%   All angles are given in degrees.
%
%   Input:
%       r1 : First rotation in RADIANS
%       r2 : Second rotation in RADIANS
%       r3 : Third rotation in RADIANS
%       sequence : Sequence to apply the three rotations. Valid options
%                  are 'XYZ' and 'ZYX' 
%   Output:
%       q : quaternion in the form of [x,y,z,w] representing the same
%           rotation
%
%   Link to reference:
%
%   https://math.stackexchange.com/questions/2975109/how-to-convert-euler-
%   angles-to-quaternions-and-get-the-same-euler-angles-back-fr
%
    if strcmp(sequence, 'XYZ')
        q_x = sin(r1/2) * cos(r2/2) * cos(r3/2) + cos(r1/2) * sin(r2/2) * sin(r3/2);
        q_y = cos(r1/2) * sin(r2/2) * cos(r3/2) - sin(r1/2) * cos(r2/2) * sin(r3/2);
        q_z = cos(r1/2) * cos(r2/2) * sin(r3/2) + sin(r1/2) * sin(r2/2) * cos(r3/2);
        q_w = cos(r1/2) * cos(r2/2) * cos(r3/2) - sin(r1/2) * sin(r2/2) * sin(r3/2);
    elseif strcmp(sequence, 'ZYX')
        q_x = sin(r3/2) * cos(r2/2) * cos(r1/2) - cos(r3/2) * sin(r2/2) * sin(r1/2);
        q_y = cos(r3/2) * sin(r2/2) * cos(r1/2) + sin(r3/2) * cos(r2/2) * sin(r1/2);
        q_z = cos(r3/2) * cos(r2/2) * sin(r1/2) - sin(r3/2) * sin(r2/2) * cos(r1/2);
        q_w = cos(r3/2) * cos(r2/2) * cos(r1/2) + sin(r3/2) * sin(r2/2) * sin(r1/2);
    else
        ME = MException(...
            'euler_to_quat:bad_sequence',...
            'given sequence is not a supported rotation sequence');
        throw(ME);
    end
    q = [q_x; q_y; q_z; q_w];
end

