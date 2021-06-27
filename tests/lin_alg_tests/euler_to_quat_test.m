function tests = euler_to_quat_test
    tests = functiontests(localfunctions);
end

% Check if two the two quaternions `expected` and `actual` are equal to the
% specified tolerance level;
function verify(testCase, expected, actual)
    tolerance = 1e-6;
    verifyEqual(testCase, actual, expected, 'AbsTol', tolerance);
end

function test_rotate_x_y_z(testCase)
    q = lin_alg.euler_to_quat(pi/2, pi/3, pi/6, 'XYZ');
    expected = [
        0.683012701892219;
        0.183012701892219;
        0.500000000000000;
        0.500000000000000];
    verify(testCase, expected, q);
end

function test_rotate_x_y_neg_z(testCase)
    q = lin_alg.euler_to_quat(pi/6, pi/6, -pi/4, 'XYZ');
    expected = [
        0.135299025036549;
        0.326640741219094;
        -0.295160309540330;
        0.887626268016025];
    verify(testCase, expected, q);
end

function test_rotate_x_neg_y_z(testCase)
    q = lin_alg.euler_to_quat(deg2rad(20), -pi/3, deg2rad(70), 'XYZ');
    expected = [
        -0.159244118269248;
        -0.489610207818600;
        0.418063163371769;
        0.748429252921121];
    verify(testCase, expected, q);
end

function test_rotate_x_neg_y_neg_z(testCase)
    q = lin_alg.euler_to_quat(deg2rad(50), -pi/3, -pi/6, 'XYZ');
    expected = [
        0.470811924208330;
        -0.342985757141044;
        -0.407252279861359;
        0.703450412587383];
    verify(testCase, expected, q);
end

function test_rotate_neg_x_y_z(testCase)
    q = lin_alg.euler_to_quat(deg2rad(-40), deg2rad(80), deg2rad(10), 'XYZ');
    expected = [
        -0.208361577654914;
        0.624559318381697;
        -0.156270988962034;
        0.736267946326996];
    verify(testCase, expected, q);
end

function test_rotate_neg_x_y_neg_z(testCase)
    q = lin_alg.euler_to_quat(deg2rad(-70), deg2rad(25), -pi/2, 'XYZ');
    expected = [
        -0.521333804473597;
        -0.270598050073098;
        -0.653281482438188;
        0.477714417108261];
    verify(testCase, expected, q);
end

function test_rotate_neg_x_neg_y_z(testCase)
    q = lin_alg.euler_to_quat(deg2rad(-17), deg2rad(-89), deg2rad(36), 'XYZ');
    expected = [
        -0.314479044258746;
        -0.626704093717776;
        0.316515927272437;
        0.638876026645512];
    verify(testCase, expected, q);
end

function test_rotate_neg_x_neg_y_neg_z(testCase)
    q = lin_alg.euler_to_quat(deg2rad(-5), deg2rad(-64), deg2rad(-21), 'XYZ');
    expected = [
        0.060106287204435;
        -0.527290933095440;
        -0.131669703362746;
        0.837266143666520];
    verify(testCase, expected, q);
end

function test_rotate_z_y_x(testCase)
    q = lin_alg.euler_to_quat(pi/2, pi/3, pi/6, 'ZYX');
    expected = [
        -0.1830127;
        0.5;
        0.5; 
        0.6830127];
    verify(testCase, expected, q);
end

function test_rotate_z_y_neg_x(testCase)
    q = lin_alg.euler_to_quat(pi/6, pi/6, -pi/4, 'ZYX');
    expected = [
        -0.4189367;
        0.135299; 
        0.3266407;
        0.8363564];
    verify(testCase, expected, q);
end

function test_rotate_z_neg_y_x(testCase)
    q = lin_alg.euler_to_quat(deg2rad(20), -pi/3, deg2rad(70), 'ZYX');
    expected = [
        0.5603074;
        -0.3170971;
        0.4056184;
        0.6488287];
    verify(testCase, expected, q);
end

function test_rotate_z_neg_y_neg_x(testCase)
    q = lin_alg.euler_to_quat(deg2rad(50), -pi/3, -pi/6, 'ZYX');
    expected = [
        0.000965613815375382;
        -0.532440340924549;
        0.236242208198525;
        0.812832067533998];
    verify(testCase, expected, q);
end

function test_rotate_neg_z_y_x(testCase)
    q = lin_alg.euler_to_quat(deg2rad(-40), deg2rad(80), deg2rad(10), 'ZYX');
    expected = [
        0.2817485;
        0.5788893;
        -0.3136497;
        0.6979462];
    verify(testCase, expected, q);
end

function test_rotate_neg_z_y_neg_x(testCase)
    q = lin_alg.euler_to_quat(deg2rad(-70), deg2rad(25), -pi/2, 'ZYX');
    expected = [
        -0.4777144;
        0.5213338;
        -0.2705981;
        0.6532815];
    verify(testCase, expected, q);
end

function test_rotate_neg_z_neg_y_x(testCase)
    q = lin_alg.euler_to_quat(deg2rad(-17), deg2rad(-89), deg2rad(36), 'ZYX');
    expected = [ 
        0.1194551;
        -0.6918604;
        0.1139485;
        0.702905];
    verify(testCase, expected, q);
end

function test_rotate_neg_z_neg_y_neg_x(testCase)
    q = lin_alg.euler_to_quat(deg2rad(-5), deg2rad(-64), deg2rad(-21), 'ZYX');
    expected = [
        -0.1771251;
        -0.5138087;
        -0.1328501;
        0.8288415];
    verify(testCase, expected, q);
end

function test_bad_sequence(testCase)
    testCase.verifyError(...
        @()lin_alg.euler_to_quat(deg2rad(25), deg2rad(20), pi/6, 'ZYZ'),...
        'euler_to_quat:bad_sequence');
    
    testCase.verifyError(...
        @()lin_alg.euler_to_quat(deg2rad(10), deg2rad(20), -pi/6, 'ABC'),...
        'euler_to_quat:bad_sequence');
    
    % Jay Z is a rotation sequence????? NANI????
    testCase.verifyError(...
        @()lin_alg.euler_to_quat(-2*pi, deg2rad(32), pi/6, 'JAYZ'),...
        'euler_to_quat:bad_sequence');
end
