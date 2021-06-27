function tests = normalize_vec_test
    tests = functiontests(localfunctions);
end

function setup(testCase)
    testCase.TestData.tolerance = 1e-6;
    testCase.TestData.tolerance_type = 'AbsTol';
end

function test_zero_vector(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    expected = [0;0;0];
    actual = lin_alg.normalize_vec([0;0;0]);
    verifyEqual(testCase, actual, expected, tolerance_type, tolerance);
end

function test_vector_mag_greater_than_one(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    test_vec = [3;4;0];
    actual = lin_alg.normalize_vec(test_vec);
    verifyEqual(testCase, norm(actual), 1, tolerance_type, tolerance);
    % Cross product of two parallel vectors is zero.
    verifyEqual(testCase, cross(actual, test_vec), [0;0;0], tolerance_type, tolerance);
end

function test_vector_mag_equal_one(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    test_vec = [1;0;0];
    actual = lin_alg.normalize_vec(test_vec);
    verifyEqual(testCase, actual, test_vec, tolerance_type, tolerance);
end

function test_vector_mag_less_than_one(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    test_vec = [0.02;0.1;0];
    actual = lin_alg.normalize_vec(test_vec);
    verifyEqual(testCase, norm(actual), 1, tolerance_type, tolerance);
    verifyEqual(testCase, cross(actual, test_vec), [0;0;0], tolerance_type, tolerance);
end

