function tests = mat_to_quat_test
    tests = functiontests(localfunctions);
end

function verify(testCase, expected, actual)
    tolerance = 1e-5;
    verifyEqual(testCase, expected(1), actual(1), 'RelTol', tolerance);
    verifyEqual(testCase, expected(2), actual(2), 'RelTol', tolerance);
    verifyEqual(testCase, expected(3), actual(3), 'RelTol', tolerance);
    verifyEqual(testCase, expected(4), actual(4), 'RelTol', tolerance);
end

function test_rotate_x_y_z(testCase)
end

function test_rotate_x_y_neg_z(testCase)
end

function test_rotate_x_neg_y_z(testCase)
end

function test_rotate_x_neg_y_neg_z(testCase)
end

function test_rotate_neg_x_y_z(testCase)
end

function test_rotate_neg_x_y_neg_z(testCase)
end

function test_rotate_neg_x_neg_y_z(testCase)
end

function test_rotate_neg_x_neg_y_neg_z(testCase)
end

