function tests = f_ballute_test
    tests = functiontests(localfunctions);
end

function setup(testCase)
    testCase.TestData.tolerance = 1e-6;
    testCase.TestData.tolerance_type = 'AbsTol';
    
    vehicle.ballute_alt = 50000;
    vehicle.num_of_ballutes = 2;
    vehicle.ballute_dia = 2;
    vehicle.ballute_drag_coeff = 1.5;
    testCase.TestData.vehicle = vehicle;
    
    env.density = 10; % If air had a density of 10kg/m^3 irl.....
    testCase.TestData.env = env;
end

function test_vel_positive_below_opening_alt(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    
    altitude = 20000;
    v_ground = [100;500;10];
    v_apparent = [100;100;10];
    expected = zeros(3,1);
    actual = recovery.f_ballute(...
        altitude,...
        v_ground,...
        v_apparent,... 
        vehicle,... 
        env);
    verifyEqual(testCase, actual, expected, tolerance_type, tolerance);
end

function test_vel_positive_at_opening_alt(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    
    altitude = 50000;
    v_ground = [100;500;30];
    v_apparent = [100;100;20];
    expected = zeros(3,1);
    actual = recovery.f_ballute(...
        altitude,...
        v_ground,...
        v_apparent,... 
        vehicle,... 
        env);
    verifyEqual(testCase, actual, expected, tolerance_type, tolerance);
end

function test_vel_positive_above_opening_alt(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    
    altitude = 1000000;
    v_ground = [0;10;1];
    v_apparent = [0;0;5];
    expected = zeros(3,1);
    actual = recovery.f_ballute(...
        altitude,...
        v_ground,...
        v_apparent,... 
        vehicle,... 
        env);
    verifyEqual(testCase, actual, expected, tolerance_type, tolerance);
end

function test_vel_negative_above_opening_alt(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    
    altitude = 1000000;
    v_ground = [0;10;-10];
    v_apparent = [0;0;-10];
    expected = zeros(3,1);
    actual = recovery.f_ballute(...
        altitude,...
        v_ground,...
        v_apparent,... 
        vehicle,... 
        env);
    verifyEqual(testCase, actual, expected, tolerance_type, tolerance);
end

function test_vel_negative_at_opening_alt(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    
    altitude = 50000;
    v_ground = [0;10;-10];
    v_apparent = [0;0;-10];
    expected = [0;0;4712.38898038469];
    actual = recovery.f_ballute(...
        altitude,...
        v_ground,...
        v_apparent,... 
        vehicle,... 
        env);
    verifyEqual(testCase, actual, expected, tolerance_type, tolerance);
end

function test_vel_negative_below_opening_alt(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    
    altitude = 20000;
    v_ground = [0;10;-20];
    v_apparent = [0;10;-30];
    expected = [0;-14901.8823986942;44705.6471960825];
    actual = recovery.f_ballute(...
        altitude,...
        v_ground,...
        v_apparent,... 
        vehicle,... 
        env);
    verifyEqual(testCase, actual, expected, tolerance_type, tolerance);
end