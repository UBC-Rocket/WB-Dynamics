function q = mat_to_quat(C)
%MAT_TO_QUAT Converts a rotation matrix to a quaternion.
%   The quaternion is defined as q1,q2,q3 as the imaginary component and q4
%   as the real component. This essentially uses the component with the
%   biggest value as it will minimize the error.
%
%   Input:
%       C : 3x3 rotation matrix
%   Output:
%       q : quaternion in the form of [x,y,z,w] representing the rotation
%           matrix
%
%   Source:
%   http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion
%
    tr = C(1,1) + C(2,2) + C(3,3);

    if tr > 0 
        S = sqrt(tr + 1) * 2; 
        q_w = 0.25 * S;
        q_x = (C(3,2) - C(2,3)) / S;
        q_y = (C(1,3) - C(3,1)) / S; 
        q_z = (C(2,1) - C(1,2)) / S; 
    elseif (C(1,1) > C(2,2)) && (C(1,1) > C(3,3)) 
        S = sqrt(1 + C(1,1) - C(2,2) - C(3,3)) * 2;
        q_w = (C(3,2) - C(2,3)) / S;
        q_x = 0.25 * S;
        q_y = (C(1,2) + C(2,1)) / S; 
        q_z = (C(1,3) + C(3,1)) / S; 
    elseif C(2,2) > C(3,3)
        S = sqrt(1 + C(2,2) - C(1,1) - C(3,3)) * 2;
        q_w = (C(1,3) - C(3,1)) / S;
        q_x = (C(1,2) + C(2,1)) / S; 
        q_y = 0.25 * S;
        q_z = (C(2,3) + C(3,2)) / S; 
    else 
        S = sqrt(1 + C(3,3) - C(1,1) - C(2,2)) * 2;
        q_w = (C(2,1) - C(1,2)) / S;
        q_x = (C(1,3) + C(3,1)) / S;
        q_y = (C(2,3) + C(3,2)) / S;
        q_z = 0.25 * S; 
    end
    q = [q_x; q_y; q_z; q_w];
end

