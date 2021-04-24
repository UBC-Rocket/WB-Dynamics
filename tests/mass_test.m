%%  Unit tests for the `mass` function to compute vehicle mass.
%   
%   The idea is to see if the mass changes linearly from ignition
%   to burn out and stay constant for times after burn out by taking
%   various time stamp samples from each time step segments.

function tests = mass_test
    tests = functiontests(localfunctions);
end

% Note that in the set up we don't need all the fields in the vehicle
% struct as the mass function only uses `load_mass`, `burn_time` and
% `prop_flow_rate` so the `create_rocket` function is not going to be used
% to create the vehicle struct.
function setup(testCase)
    vehicle.load_mass = 400;
    vehicle.burn_time = 20;
    vehicle.prop_flow_rate = 10;
    testCase.TestData.vehicle = vehicle;
end

% For before burn_time the mass should decrease linearly
function test_timestamp_power_on_start(testCase)
    time = 0;
    m = mass(time, testCase.TestData.vehicle);
    verifyEqual(testCase, m, 400);
end

function test_timestamp_power_on_mid(testCase)
    time = 10;
    m = mass(time, testCase.TestData.vehicle);
    verifyEqual(testCase, m, 300);
end

function test_timestamp_power_on_end(testCase)
    time = 20;
    m = mass(time, testCase.TestData.vehicle);
    verifyEqual(testCase, m, 200);
end

% For past burn_time, the mass should be constant
function test_timestamp_power_off_one(testCase)
    time = 30;
    m = mass(time, testCase.TestData.vehicle);
    verifyEqual(testCase, m, 200);
end

function test_timestamp_power_off_two(testCase)
    time = 60;
    m = mass(time, testCase.TestData.vehicle);
    verifyEqual(testCase, m, 200);
end

function test_timestamp_power_off_three(testCase)
    time = 90;
    m = mass(time, testCase.TestData.vehicle);
    verifyEqual(testCase, m, 200);
end

