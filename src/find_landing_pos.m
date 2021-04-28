function [pos_x, pos_y, landing_time] = find_landing_pos(time, state, launch_alt)
%FIND_LANDING_POS Finding landing position of vehicle given launch altitude
%and trajectory.
%   Uses Newton's method to iteratively find the zero (landing position).
%   Link: http://www.math.niu.edu/~dattab/MATH435.2013/ROOT_FINDING.pdf
%   pages 17-18 are the most relevant.
%
    altitude = state(:,3);
    pp = spline(time, altitude); % Cubic piecewise polynomial
    % Since we want to find the time values where the altitude data points
    % intersects with the line altitude = launch_alt, the function altitude
    % vs time can be vertically shifted down by launch_alt which then
    % transforms the problem to a easier problem of finding where the
    % transformed function intersects the time axis which can be done
    % iteratively via Newton's method.
    pp.coefs(:,4) = pp.coefs(:,4) - launch_alt;
    
    %% Compute derivative of `pp`
    coefs = zeros(size(pp.coefs, 1), 4); % Initialize matrix to store values
    coefs(:,1) = zeros(size(pp.coefs, 1), 1); % derivative of cubic has no x^3 term
    coefs(:,2) = 3*pp.coefs(:,1); % quadratic term is 3*x^2
    coefs(:,3) = 2*pp.coefs(:,2); % linear term is 2*x
    coefs(:,4) = pp.coefs(:,3); % constant term is x
    pp_dot = mkpp(pp.breaks, coefs); % Derivative of pp
    
    %% Perform Newton's method
    % Since the trajectory is somewhat parabolic in nature, there will be
    % two zeros, one at ignition (time = 0) and one at landing time. The
    % latter is what we are looking for so we set the initial time guess to
    % be farther away from zero (an arbitrary choice of 3/4 of the total
    % simulation time is chosen to the the initial time guess) to make sure
    % we don't "accidently" get the ignition time.
    x = time(length(time))*0.75;
    f = ppval(pp,x);
    f_dot = ppval(pp_dot,x);
    
    MAX_ITER = 1500;
    curr_iter = 0;
    EPSILON = 0.001;
    % Stop if close enough to zero or if we rached max iterations.
    while curr_iter < MAX_ITER || abs(f) >= EPSILON
        x = x - f/f_dot;
        f = ppval(pp,x);
        f_dot = ppval(pp_dot,x);
        curr_iter = curr_iter + 1;
    end
    %% Predicted values
    landing_time = x;
    % Perform spline on x and y values and interpolate with predicted
    % landing time to get the landing position.
    pp_x = spline(time,state(:,1));
    pp_y = spline(time,state(:,2));
    pos_x = ppval(pp_x, landing_time);
    pos_y = ppval(pp_y, landing_time);
end

