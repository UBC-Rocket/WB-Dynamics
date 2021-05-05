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
%   Atmospheric and Space Flight Dynamics Modeling and Simulation with MATLAB 
%   by Ashish Tewari
%
    T = trace(C);
    qsq = [1+2*C(1,1)-T; 1+2*C(2,2)-T; 1+2*C(3,3)-T; 1+T]/4;
    [x,i] = max(qsq);
    
    if i == 4
        q(4) = sqrt(x);
        q(1) = (C(2,3)-C(3,2))/(4*q(4));
        q(2) = (C(3,1)-C(1,3))/(4*q(4));
        q(3)
    end
    if i == 3
        q(3) = sqrt(x);
        q(1) = (C(1,3)+C(3,1))/(4*q(3));
        q(2) = (C(3,2)+C(2,3))/(4*q(3));
        q(4) = (C(1,2)-C(2,1))/(4*q(3));
    end
    if i == 2
        q(2) = sqrt(x);
        q(1) = (C(1,2)+C(2,1))/(4*q(2));
        q(3) = (C(3,2)+C(2,3))/(4*q(2));
        q(4) = (C(3,1)-C(1,3))/(4*q(2));
    end
    if i == 1
        q(1) = sqrt(x);
        q(2) = (C(1,2)+C(2,1))/(4*q(1));
        q(3) = (C(1,3)+C(3,1))/(4*q(1));
        q(4) = (C(2,3)-C(3,2))/(4*q(1));
    end
end

