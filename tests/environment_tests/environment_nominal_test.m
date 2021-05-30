%% Test for the `create_environment` function
%
% `create_environment` function just sets values so this test just aims to
% check that the initialized values are correct.
function tests = environment_nominal_test
    tests = functiontests(localfunctions);
end

function test_initialize_values(testCase)
    expected_wind_vel = [
        0.101051193825983;
        -2.07360362062626;
        0
    ];
    expected_uncertainty = sampling.create_uncertainty(0,0);
    env = environment.environment_nominal();
    verifyEqual(testCase, round(env.density, 5, 'significant'), 1.2250);
    verifyEqual(testCase, round(env.sound_speed, 6, 'significant'), 340.294);
    verifyEqual(testCase, round(env.temperature, 6, 'significant'), 288.150);
    verifyEqual(testCase, round(env.pressure, 6, 'significant'), 101325);
    verifyEqual(testCase, env.sp_heat_ratio, 1.4);
    verifyEqual(testCase, round(env.grav_accel_SL, 5, 'significant'), 9.8175);
    verifyEqual(testCase, env.wind_vel, expected_wind_vel, 'AbsTol', 1e-6);
    verifyEqual(testCase, env.wind_meridional_uncertainty, expected_uncertainty);
    verifyEqual(testCase, env.wind_zonal_uncertainty, expected_uncertainty);
end
