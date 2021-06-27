function [apogee_altitude, apogee_time] = find_apogee(time, altitude)
%FIND_APOGEE Finds the apogee of an altitude vs time data set via gradient
%ascent.
%   This algorithm should always work as the altitude argument should be of
%   points where the function has only one local maximum and the local
%   maximum is also the global maximum.
%
%   Input:
%       time: Vector of time points
%       altitude: Vector of altitudes corresponding to a time
%   Ouput:
%       apogee_altitude: Altitude of apgoee in meters
%       apogee_time: time taken since ignition to reach apogee in seconds
%
    pp = spline(time, altitude); % Cubic piecewise polynomial from interpolation
    
    %% Compute derivative of `pp`
    coefs = zeros(size(pp.coefs, 1), 4); % Initialize matrix to store values
    coefs(:,1) = zeros(size(pp.coefs, 1), 1); % derivative of cubic has no x^3 term
    coefs(:,2) = 3*pp.coefs(:,1); % quadratic term is 3*x^2
    coefs(:,3) = 2*pp.coefs(:,2); % linear term is 2*x
    coefs(:,4) = pp.coefs(:,3); % constant term is x
    pp_dot = mkpp(pp.breaks, coefs); % Derivative of pp
    
    %% Perform gradient decent (or in this case ascent) to find maximum
    % "Pro machine learners" probably have better algorithms in choosing 
    % step size or `LEARN_RATE` to prevent over shooting but for this
    % purpose, the current setup of a static step size is decently 
    % adequate.
    MAX_ITER = 1500;
    curr_iter = 0;
    LEARN_RATE = 0.01; % How much to scale by each time step.
    EPSILON = 0.001; % How close our slope has to be to zero to be considered zero.
    predict_time = 5; % Our inital guess (Doesn't have to be super accurate).
    nabla_pp = ppval(pp_dot, predict_time);
    % Stop if slope is close enough to zero or if we reached max
    % iterations.
    while curr_iter < MAX_ITER || abs(nabla_pp) >= EPSILON
        predict_time = predict_time + LEARN_RATE * nabla_pp;
        nabla_pp = ppval(pp_dot, predict_time);
        curr_iter = curr_iter + 1;
    end
    
    %% Predicted values
    apogee_altitude = ppval(pp, predict_time);
    apogee_time = predict_time;
end

