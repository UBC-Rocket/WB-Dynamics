function tests = mat_to_quat_test
    tests = functiontests(localfunctions);
end

function verify(testCase, expected, actual)
    tolerance = 1e-6;
    verifyEqual(testCase, expected, actual, 'AbsTol', tolerance);
end

function test_rotate_x_y_z(testCase)
    rot_mat = lin_alg.euler_to_mat(pi/2, pi, pi/3);
    actual_quat = lin_alg.mat_to_quat(rot_mat);
    expected_quat = [
        -0.3535533905932739;
        0.6123724356957946;
        -0.6123724356957945;
        0.3535533905932739];
    verify(testCase, expected_quat, actual_quat);
end

function test_rotate_x_y_neg_z(testCase)
    rot_mat = lin_alg.euler_to_mat(pi/3, pi/6, -4*pi);
    actual_quat = lin_alg.mat_to_quat(rot_mat);
    expected_quat = [
        0.482962913144534;
        0.224143868042014;
        -0.129409522551260;
        0.836516303737808];
    verify(testCase, expected_quat, actual_quat);
end

function test_rotate_x_neg_y_z(testCase)
    rot_mat = lin_alg.euler_to_mat(pi/4, -pi/20, 2*pi);
    actual_quat = lin_alg.mat_to_quat(rot_mat);
    expected_quat = [
        0.381503747057247;
        -0.0724867526822998;
        0.0300249960533928;
        0.921031520241761];
    verify(testCase, expected_quat, actual_quat);
end

function test_rotate_x_neg_y_neg_z(testCase)
    rot_mat = lin_alg.euler_to_mat(pi/100, -pi/50, -pi/3);
    actual_quat = lin_alg.mat_to_quat(rot_mat);
    expected_quat = [
        -0.00210721841570071;
        -0.0350489427564604;
        -0.499264348321194;
        0.865737975219764];
    verify(testCase, expected_quat, actual_quat);
end

function test_rotate_neg_x_y_z(testCase)
    rot_mat = lin_alg.euler_to_mat(-pi/1000, pi/150, pi/65);
    actual_quat = lin_alg.mat_to_quat(rot_mat);
    expected_quat = [
        -0.00182328813941371;
        0.0104307593619764;
        0.0241788347438386;
        0.999651568712781];
    verify(testCase, expected_quat, actual_quat);
end

function test_rotate_neg_x_y_neg_z(testCase)
    rot_mat = lin_alg.euler_to_mat(-pi/23, pi/150, -pi/67);
    actual_quat = lin_alg.mat_to_quat(rot_mat);
    expected_quat = [
        -0.0679750053004292;
        0.0120441909584369;
        -0.0226722177465767;
        0.997356659706554];
    verify(testCase, expected_quat, actual_quat);
end

function test_rotate_neg_x_neg_y_z(testCase)
    rot_mat = lin_alg.euler_to_mat(-pi/25, -pi/15, 6*pi);
    actual_quat = lin_alg.mat_to_quat(rot_mat);
    expected_quat = [
        -0.0624465464934513;
        -0.104322200222651;
        -0.00656339651417707;
        0.992559433584682];
    verify(testCase, expected_quat, actual_quat);
end

function test_rotate_neg_x_neg_y_neg_z(testCase)
    rot_mat = lin_alg.euler_to_mat(-10*pi, -36*pi, -15*pi);
    actual_quat = lin_alg.mat_to_quat(rot_mat);
    expected_quat = [
        -2.19547451153232e-15;
        5.85459869741951e-16;
        1;
        -2.69484193876076e-15];
    verify(testCase, expected_quat, actual_quat);
end

