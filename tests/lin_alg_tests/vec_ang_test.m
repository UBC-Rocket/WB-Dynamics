function tests = vec_ang_test
    tests = functiontests(localfunctions);
end

function verify_within_tolerance(testCase, expected, actual)
    tolerance = 1e-6;
    tolerance_type = 'AbsTol';

    testCase.verifyEqual(actual, expected, tolerance_type, tolerance);
end

function test_parallel_vectors_same_direction(testCase)
    expected_angle = 0;

    v1 = [1; 0; 0];
    v2 = [1; 0; 0];
    result = lin_alg.vec_ang(v1, v2);
    verify_within_tolerance(testCase, expected_angle, result);

    v3 = [-124; 12345; 0];
    v4 = [-248; 24690; 0];
    result = lin_alg.vec_ang(v3, v4);
    verify_within_tolerance(testCase, expected_angle, result);

    v5 = [0.1; 0.0001; 0.02];
    v6 = [0.01; 0.00001; 0.002];
    result = lin_alg.vec_ang(v5, v6);
    verify_within_tolerance(testCase, expected_angle, result);
end

function test_parallel_vectors_different_direction(testCase)
    expected_angle = pi;

    v1 = -[0; 1; 0];
    v2 = [0; 1; 0];
    result = lin_alg.vec_ang(v1, v2);
    verify_within_tolerance(testCase, expected_angle, result);

    v3 = [-124; 12345; 2];
    v4 = [248; -24690; -4];
    result = lin_alg.vec_ang(v3, v4);
    verify_within_tolerance(testCase, expected_angle, result);

    v5 = -[0.1; 0.0001; 0.02];
    v6 = [0.01; 0.00001; 0.002];
    result = lin_alg.vec_ang(v5, v6);
    verify_within_tolerance(testCase, expected_angle, result);
end

function test_orthogonal_vectors(testCase)
    expected_angle = pi/2;

    v1 = [1; 0; 0];
    v2 = [0; 1; 0];
    result = lin_alg.vec_ang(v1, v2);
    verify_within_tolerance(testCase, expected_angle, result);

    v3 = [-23; 36; 89];
    v4 = [3933; -135; 1071];
    result = lin_alg.vec_ang(v3, v4);
    verify_within_tolerance(testCase, expected_angle, result);

    v5 = [0.1; 0.0001; 0.2];
    v6 = [0.0023; -2.1; -0.0001];
    result = lin_alg.vec_ang(v5, v6);
    verify_within_tolerance(testCase, expected_angle, result);
end

function test_assorted_angles(testCase)
    expected_angle_1 = pi/4;
    v1 = [100; 0; 0];
    v2 = 200*[cosd(30); cosd(45); sind(30)];
    result = lin_alg.vec_ang(v1, v2);
    verify_within_tolerance(testCase, expected_angle_1, result);

    expected_angle_2 = pi/6;
    v3 = [0; 100; 0];
    v4 = 50*[sind(30)*cosd(10); cosd(30); sind(30)*sind(10)];
    result = lin_alg.vec_ang(v3, v4);
    verify_within_tolerance(testCase, expected_angle_2, result);

    expected_angle_3 = 5/6*pi;
    v5 = [0; 0; -20];
    v6 = 0.01*[cosd(60)*sind(45); cosd(60)*cosd(45); sind(60)];
    result = lin_alg.vec_ang(v5, v6);
    verify_within_tolerance(testCase, expected_angle_3, result);
end