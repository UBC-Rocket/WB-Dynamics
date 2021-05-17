%% Test for the `create_environment` function
%
% `create_environment` function just sets values so this test just aims to
% check that the initialized values are correct.
function tests = environment_nominal_test
    tests = functiontests(localfunctions);
end

function test_initialize_values(testCase)
    wind_dir = [10;20;10;-40;60;90;130;240];
    expected_wind_vel = 5*[
        cosd(wind_dir(1));
        sind(wind_dir(1));
        0
    ];
    expected_uncertainty = sampling.create_uncertainty(0,0);
    env = environment.environment_nominal(wind_dir);
    verifyEqual(testCase, round(env.density, 5, 'significant'), 1.2250);
    verifyEqual(testCase, round(env.sound_speed, 6, 'significant'), 340.294);
    verifyEqual(testCase, round(env.temperature, 6, 'significant'), 288.150);
    verifyEqual(testCase, round(env.pressure, 6, 'significant'), 101325);
    verifyEqual(testCase, env.sp_heat_ratio, 1.4);
    verifyEqual(testCase, round(env.grav_accel_SL, 5, 'significant'), 9.8175);
    verifyEqual(testCase, env.wind_vel, expected_wind_vel, 'AbsTol', 1e-6);
    verifyEqual(testCase, env.wind_speed_uncertainty, expected_uncertainty);
end

function test_bad_input_wind_dir_too_short(testCase)
    wind_dir = [10,50,300];
    testCase.verifyError(...
        @()environment.environment_nominal(wind_dir),...
        'environment:bad_wind_dir');
end

function test_bad_input_wind_dir_wrong_shape(testCase)
    wind_dir = [300,230,300,100,30,60,30,10];
    testCase.verifyError(...
        @()environment.environment_nominal(wind_dir),...
        'environment:bad_wind_dir');
end