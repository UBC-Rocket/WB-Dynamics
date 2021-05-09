%% Unit tests for the `trajectory` function
%
%   The tests are relatively basic in nature in that it only just checks
%   the apogee to see if it is within reasonable bounds of what it is
%   somewhat expected to be. Essentially it is just an automated way to
%   check if new changes gives an completely unreasonable trajectory
%   instead of checking if the computed trajectory is super accurate.
%
%   Only real problem here is that once the model slightly changes (another
%   factor is added) these tests will need to be tweaked a bit as the new
%   model may affect apogee.
%
function tests = trajectory_test
    tests = functiontests(localfunctions);
end

function test_8km_target(testCase)
    TARGET_ALT = 8000;
    ACCEPTABLE_ERR = 200;
    
    time_step = 1;
    end_time = 90;
    
    vehicle = rocket_nominal('./8km_input.csv');

    [time, state] = trajectory(vehicle, end_time, time_step);
    [apogee, ~] = find_apogee(time, state(:,3));
    verifyEqual(testCase, apogee, TARGET_ALT, 'AbsTol', ACCEPTABLE_ERR);
end

function test_20km_target(testCase)
    TARGET_ALT = 20000;
    ACCEPTABLE_ERR = 1000; % a bit high and maybe can be tone down a bit.

    time_step = 1;
    end_time = 70;
    
    vehicle = rocket_nominal('./20km_input.csv');

    [time, state] = trajectory(vehicle, end_time, time_step);
    [apogee, ~] = find_apogee(time, state(:,3));
    verifyEqual(testCase, apogee, TARGET_ALT, 'AbsTol', ACCEPTABLE_ERR);
end

