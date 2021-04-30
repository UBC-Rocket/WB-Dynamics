function q_dot = quat_dot(omega, q)
%QUAT_DOT Computes derivative of quaternion with respect to time.
%   Given an angular velocity omega in the form of [x,y,z], the derivative
%   of q which is in the form of [x,y,z,w] is computed
%
%   Source:
%   Atmospheric and Space Flight Dynamics Modeling and Simulation with MATLAB 
%   by Ashish Tewari
%   To keep it an unit quaternion, an extra factor is added.
%   Source: https://www.mathworks.com/help/aeroblks/6dofquaternion.html
    K = 0.01;
    epsilon = 1 - (q(1)^2 + q(2)^2 + q(3)^2 + q(4)^2);
    C = [0 omega(3) -omega(2) omega(1);
         -omega(3) 0 omega(1) omega(2);
         omega(2) -omega(1) 0 omega(3);
         -omega(1) -omega(2) -omega(3) 0];
    q_dot = 0.5*C*q + K*epsilon*q;
end

