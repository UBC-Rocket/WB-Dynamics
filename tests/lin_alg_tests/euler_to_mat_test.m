%% Test cases for `euler_to_mat` function
%
% Instead of testing the actual rotation matrix, a vector is transformed
% using the rotation matrix and the result from the transformation is
% compared to the expected. Most of these tests are rather basic as they
% rotate unit vectors but that is because unit vectors are easy to compute
% and thus easy to write tests for but feel free to add non unit vector
% tests too.
function tests = euler_to_mat_test
    tests = functiontests(localfunctions);
end

function verify(testCase, expected, actual)
    tolerance = 1e-6;
    verifyEqual(testCase, expected, actual, 'AbsTol', tolerance);
end

function test_rotate_x(testCase)
    C = lin_alg.euler_to_mat(pi/2, 0, 0);
    
    expected = [1;0;0];
    actual = C*[1;0;0];
    verify(testCase, expected, actual);
    
    expected = [0;0;1];
    actual = C*[0;1;0];
    verify(testCase, expected, actual);
    
    expected = [0;-1;0];
    actual = C*[0;0;1];
    verify(testCase, expected, actual);
end

function test_rotate_y(testCase)
    C = lin_alg.euler_to_mat(0, pi/2, 0);
    
    expected = [0;0;-1];
    actual = C*[1;0;0];
    verify(testCase, expected, actual);
    
    expected = [0;1;0];
    actual = C*[0;1;0];
    verify(testCase, expected, actual);
    
    expected = [1;0;0];
    actual = C*[0;0;1];
    verify(testCase, expected, actual);
end

function test_rotate_z(testCase)
    C = lin_alg.euler_to_mat(0, 0, pi/2);
    
    expected = [0;1;0];
    actual = C*[1;0;0];
    verify(testCase, expected, actual);
    
    expected = [-1;0;0];
    actual = C*[0;1;0];
    verify(testCase, expected, actual);
    
    expected = [0;0;1];
    actual = C*[0;0;1];
    verify(testCase, expected, actual);
end

function test_rotate_x_y(testCase)
    C = lin_alg.euler_to_mat(pi/2, -pi/2, 0);
    
    expected = [0;0;1];
    actual = C*[1;0;0];
    verify(testCase, expected, actual);
    
    expected = [-1;0;0];
    actual = C*[0;1;0];
    verify(testCase, expected, actual);
    
    expected = [0;-1;0];
    actual = C*[0;0;1];
    verify(testCase, expected, actual);
end

function test_rotate_x_z(testCase)
    C = lin_alg.euler_to_mat(-pi/6, 0, pi/2);
    
    expected = [0;1;0];
    actual = C*[1;0;0];
    verify(testCase, expected, actual);
    
    expected = [-0.8660254038;0;-0.5];
    actual = C*[0;1;0];
    verify(testCase, expected, actual);
    
    expected = [-0.5;0;0.8660254038];
    actual = C*[0;0;1];
    verify(testCase, expected, actual);
end

function test_rotate_y_z(testCase)
    C = lin_alg.euler_to_mat(0, -pi/4, -pi/2);
    
    expected = [0;-0.7071067812;0.7071067812];
    actual = C*[1;0;0];
    verify(testCase, expected, actual);
    
    expected = [1;0;0];
    actual = C*[0;1;0];
    verify(testCase, expected, actual);
    
    expected = [0;0.7071067812;0.7071067812];
    actual = C*[0;0;1];
    verify(testCase, expected, actual);
end

function test_rotate_x_y_z(testCase)
    % First rotation
    C = lin_alg.euler_to_mat(pi/6, pi/3, pi/2);
    
    expected = [0;0.5;-0.8660254038];
    actual = C*[1;0;0];
    verify(testCase, expected, actual);
    
    expected = [-0.8660254038;0.4330127019;0.25];
    actual = C*[0;1;0];
    verify(testCase, expected, actual);
    
    expected = [0.5;0.75;0.4330127019];
    actual = C*[0;0;1];
    verify(testCase, expected, actual);
    
    % Second rotation
    C = lin_alg.euler_to_mat(pi/4, -pi/6, pi/3);
    
    expected = [0.4330127019;0.75;0.5];
    actual = C*[1;0;0];
    verify(testCase, expected, actual);
    
    expected = [-0.789149131;0.04736717275;0.6123724357];
    actual = C*[0;1;0];
    verify(testCase, expected, actual);
    
    expected = [0.4355957404;-0.6597396084;0.6123724357];
    actual = C*[0;0;1];
    verify(testCase, expected, actual);
end

