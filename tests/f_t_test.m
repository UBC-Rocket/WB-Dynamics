%% Unit tests for the `f_t` function to compute thrust force
%
% The main things these tests aim for is check that the thrust is non
% zero while the time is less than or equal to the burn time and that the
% thrust is zero for times past burn time. It also aims to check that the
% thrust changes as the atmosphere pressure changes and that the thrust is
% in the direction that is specified by the `dir` vector.
%
% The altitude of 25km is taken for lower atmosphere.
% The altitude of 50km is taken for middle atmosphere.
% The altitude of 75km is taken for upper atmosphere.
% 
% Again since we are comparing floating point values, we do not check for
% strict equality but rather that they are equal up to 5 significant
% figures.

function tests = f_t_test
    tests = functiontests(localfunctions);
end

function setup(testCase)
    env.sp_heat_ratio = 1.4;
    env.grav_accel_SL = 9.81;
    
    vehicle.burn_time = 20;
    vehicle.nozzle_eff = 0.5;
    vehicle.c_star = 1000;
    vehicle.exit_pressure = 30000;
    vehicle.chamber_pressure = 150000;
    vehicle.exp_area_ratio = 2;
    vehicle.prop_flow_rate = 10;
    
    testCase.TestData.env = env;
    testCase.TestData.vehicle = vehicle;
end

function check_values(testCase, t, vehicle, env, expected_thrust)
    dir1 = [1;0;0];
    f_thrust = f_t(dir1, t, vehicle, env);
    verifyEqual(testCase, f_thrust(1), expected_thrust, 'RelTol', 1e-5);
    verifyEqual(testCase, f_thrust(2), 0);
    verifyEqual(testCase, f_thrust(3), 0);
    
    dir2 = [0;1;0];
    f_thrust = f_t(dir2, t, vehicle, env);
    verifyEqual(testCase, f_thrust(1), 0);
    verifyEqual(testCase, f_thrust(2), expected_thrust, 'RelTol', 1e-5);
    verifyEqual(testCase, f_thrust(3), 0);
    
    angle = pi/2;
    dir3 = [cos(angle);sin(angle);0];
    f_thrust = f_t(dir3, t, vehicle, env);
    verifyEqual(...
        testCase,...
        f_thrust(1),...
        expected_thrust*cos(angle),...
        'RelTol',...
        1e-5);
    verifyEqual(...
        testCase,...
        f_thrust(2),...
        expected_thrust*sin(angle),...
        'RelTol',...
        1e-5);
    verifyEqual(testCase, f_thrust(3), 0);
end

%% Engine on test cases
function test_ignition_power_on_sea_level(testCase)
    testCase.TestData.env.pressure = 101325;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    t = 0;
    expected_thrust = 744.53;
    
    check_values(testCase, t, vehicle, env, expected_thrust);
end

function test_ignition_power_on_lower_atm(testCase)
    testCase.TestData.env.pressure = 2511.02;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    t = 0;
    expected_thrust = 7332.1;
    
    check_values(testCase, t, vehicle, env, expected_thrust);
end

function test_ignition_power_on_middle_atm(testCase)
    testCase.TestData.env.pressure = 75.9448;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    t = 0;
    expected_thrust = 7494.5;
    
    check_values(testCase, t, vehicle, env, expected_thrust);
end

function test_ignition_power_on_upper_atm(testCase)
    testCase.TestData.env.pressure = 2.06792;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    t = 0;
    expected_thrust = 7499.4;
    
    check_values(testCase, t, vehicle, env, expected_thrust);
end

function test_mid_burn_power_on_sea_level(testCase)
    testCase.TestData.env.pressure = 101325;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    t = vehicle.burn_time/2;
    expected_thrust = 744.53;
    
    check_values(testCase, t, vehicle, env, expected_thrust);
end

function test_mid_burn_power_on_lower_atm(testCase)
    testCase.TestData.env.pressure = 2511.02;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    t = vehicle.burn_time/2;
    expected_thrust = 7332.1;
    
    check_values(testCase, t, vehicle, env, expected_thrust);
end

function test_mid_burn_power_on_middle_atm(testCase)
    testCase.TestData.env.pressure = 75.9448;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    t = vehicle.burn_time/2;
    expected_thrust = 7494.5;
    
    check_values(testCase, t, vehicle, env, expected_thrust);
end

function test_mid_burn_power_on_upper_atm(testCase)
    testCase.TestData.env.pressure = 2.06792;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    t = vehicle.burn_time/2;
    expected_thrust = 7499.4;
    
    check_values(testCase, t, vehicle, env, expected_thrust);
end

function test_end_burn_power_on_sea_level(testCase)
    testCase.TestData.env.pressure = 101325;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    t = vehicle.burn_time;
    expected_thrust = 744.53;
    
    check_values(testCase, t, vehicle, env, expected_thrust);
end

function test_end_burn_power_on_lower_atm(testCase)
    testCase.TestData.env.pressure = 2511.02;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    t = vehicle.burn_time;
    expected_thrust = 7332.1;
    
    check_values(testCase, t, vehicle, env, expected_thrust);
end

function test_end_burn_power_on_middle_atm(testCase)
    testCase.TestData.env.pressure = 75.9448;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    t = vehicle.burn_time;
    expected_thrust = 7494.5;
    
    check_values(testCase, t, vehicle, env, expected_thrust);
end

function test_end_burn_power_on_upper_atm(testCase)
    testCase.TestData.env.pressure = 2.06792;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    t = vehicle.burn_time;
    expected_thrust = 7499.4;
    
    check_values(testCase, t, vehicle, env, expected_thrust);
end

%% Engine off test cases
% We are also going to test different altitudes just to make sure that in
% this time interval, the thrust is independent from pressure
function test_power_off_one_sec_sea_level(testCase)
    testCase.TestData.env.pressure = 101325;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    t = vehicle.burn_time + 1;
    expected_thrust = 0;
    
    check_values(testCase, t, vehicle, env, expected_thrust);
end

function test_power_off_one_min_sea_level(testCase)
    testCase.TestData.env.pressure = 101325;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    t = vehicle.burn_time + 60;
    expected_thrust = 0;
    
    check_values(testCase, t, vehicle, env, expected_thrust);
end

function test_power_off_one_sec_lower_atm(testCase)
    testCase.TestData.env.pressure = 2511.02;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    t = vehicle.burn_time + 1;
    expected_thrust = 0;
    
    check_values(testCase, t, vehicle, env, expected_thrust);
end

function test_power_off_one_min_lower_atm(testCase)
    testCase.TestData.env.pressure = 2511.02;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    t = vehicle.burn_time + 60;
    expected_thrust = 0;
    
    check_values(testCase, t, vehicle, env, expected_thrust);
end

function test_power_off_one_sec_middle_atm(testCase)
    testCase.TestData.env.pressure = 75.9448;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    t = vehicle.burn_time + 1;
    expected_thrust = 0;
    
    check_values(testCase, t, vehicle, env, expected_thrust);
end

function test_power_off_one_min_middle_atm(testCase)
    testCase.TestData.env.pressure = 75.9448;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    t = vehicle.burn_time + 60;
    expected_thrust = 0;
    
    check_values(testCase, t, vehicle, env, expected_thrust);
end

function test_power_off_one_sec_upper_atm(testCase)
    testCase.TestData.env.pressure = 2.06792;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    t = vehicle.burn_time + 1;
    expected_thrust = 0;
    
    check_values(testCase, t, vehicle, env, expected_thrust);
end

function test_power_off_one_min_upper_atm(testCase)
    testCase.TestData.env.pressure = 2.06792;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    t = vehicle.burn_time + 60;
    expected_thrust = 0;
    
    check_values(testCase, t, vehicle, env, expected_thrust);
end