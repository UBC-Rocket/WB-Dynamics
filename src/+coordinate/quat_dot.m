function q_dot = quat_dot(omega, q)
%QUAT_DOT Computes derivative of quaternion with respect to time.
%   Given an angular velocity omega, the derivative of q is computed.
    C = [0 omega(3) -omega(2) omega(1);
         -omega(3) 0 omega(1) omega(2);
         omega(2) -omega(1) 0 omega(3);
         -omega(1) -omega(2) -omega(3) 0];
    q_dot = 0.5*C*q;
end

