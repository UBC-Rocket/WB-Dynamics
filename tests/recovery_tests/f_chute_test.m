function tests = f_chute_test
    tests = functiontests(localfunctions);
end

function setup(testCase)
    testCase.TestData.tolerance = 1e-6;
    testCase.TestData.tolerance_type = 'AbsTol';
    
    vehicle.main_chute_alt = 2000;
    vehicle.num_of_chutes = 3;
    vehicle.main_chute_dia = 4;
    vehicle.main_chute_drag_coeff = 2;
    testCase.TestData.vehicle = vehicle;
    
    env.density = 5; % If air had a density like this.....
    testCase.TestData.env = env;
end

function test_vel_positive_below_opening_alt(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    vehicle = testCase.TestData.vehicle;
    env = testCase.TestData.env;
    
    altitude = 100;
    v_ground = [10;5;10];
    v_apparent = [10;5;10];
    expected = zeros(3,1);
    actual = recovery.f_chute(...
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
    
    altitude = 2000;
    v_ground = [1;5;3];
    v_apparent = [1;1;2];
    expected = zeros(3,1);
    actual = recovery.f_chute(...
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
    
    altitude = 5000;
    v_ground = [0;-10;1];
    v_apparent = [0;-10;5];
    expected = zeros(3,1);
    actual = recovery.f_chute(...
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
    
    altitude = 5000;
    v_ground = [0;10;-10];
    v_apparent = [0;0;-10];
    expected = zeros(3,1);
    actual = recovery.f_chute(...
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
    
    altitude = 2000;
    v_ground = [0;10;-10];
    v_apparent = [0;0;-10];
    expected = [0;0;18849.55592153876];
    actual = recovery.f_chute(...
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
    
    altitude = 100;
    v_ground = [0;10;-20];
    v_apparent = [0;30;-40];
    expected = [0;-282743.338823081;376991.118430775];
    actual = recovery.f_chute(...
        altitude,...
        v_ground,...
        v_apparent,...
        vehicle,...
        env);
    verifyEqual(testCase, actual, expected, tolerance_type, tolerance);
end
