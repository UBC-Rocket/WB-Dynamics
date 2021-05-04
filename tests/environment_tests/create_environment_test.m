%% Test for the `create_environment` function
%
% `create_environment` function just sets values so this test just aims to
% check that the initialized values are correct.
function tests = create_environment_test
    tests = functiontests(localfunctions);
end

function test_initialize_values(testCase)
    wind_vel = [10;30;1];
    env = environment.create_environment(wind_vel);
    verifyEqual(testCase, round(env.density, 5, 'significant'), 1.2250);
    verifyEqual(testCase, round(env.sound_speed, 6, 'significant'), 340.294);
    verifyEqual(testCase, round(env.temperature, 6, 'significant'), 288.150);
    verifyEqual(testCase, round(env.pressure, 6, 'significant'), 101325);
    verifyEqual(testCase, env.sp_heat_ratio, 1.4);
    verifyEqual(testCase, round(env.grav_accel_SL, 5, 'significant'), 9.8175);
    verifyEqual(testCase, env.wind_vel, wind_vel, 'AbsTol', 1e-6);
end
