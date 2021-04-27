function tests = to_body_frame_test
    tests = functiontests(localfunctions);
end

% Setup acceptable tolerance level
function setup(testCase)
    testCase.TestData.tolerance = 1e-5;
end

% Start with some trival test cases
function test_rotate_x_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    q = coordinate.euler_to_quat([90, 0, 0]);
    
    v = [1;0;0];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [1;0;0];
    verifyEqual(testCase, v_prime, expected, 'RelTol', tolerance);
    
    v = [0;1;0];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [0;0;-1];
    verifyEqual(testCase, v_prime, expected, 'RelTol', tolerance);
    
    v = [0;0;1];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [0;1;0];
    verifyEqual(testCase, v_prime, expected, 'RelTol', tolerance);
end

function test_rotate_y_quat(testCase)
end

function test_rotate_z_quat(testCase)
end

