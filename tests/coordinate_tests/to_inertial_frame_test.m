% The expected values were generated using MATLAB's own robotics toolkit.
% You are probably wondering why I did not just use the toolkit instead of
% writing my own function. One, MATLAB does not seem to have solid support
% for a way to list and get dependencies which makes it a bit harder for
% other people to use as they have to figure out the dependencies and
% install it. Two, I have finer control over what the algorithm actually
% does which makes it easier to profile (not that some matrix generation
% and multiplication will ever need to be profiled).
function tests = to_inertial_frame_test
    tests = functiontests(localfunctions);
end

% Setup acceptable tolerance level
function setup(testCase)
    testCase.TestData.tolerance = 1e-6;
    testCase.TestData.tolerance_type = 'AbsTol';
end

% Start with some trival test cases i.e. the body frame can be obtained
% from the inertial frame by one rotation.
function test_rotate_x_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(pi/2, 0, 0, 'XYZ');
    
    v = [1;0;0];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [1;0;0];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;1;0];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [0;0;1];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;0;1];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [0;-1;0];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

function test_rotate_y_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(0, pi/2, 0, 'XYZ');
    
    v = [1;0;0];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [0;0;-1];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;1;0];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [0;1;0];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;0;1];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [1;0;0];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

function test_rotate_z_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(0, 0, pi/2, 'XYZ');
    
    v = [1;0;0];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [0;1;0];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;1;0];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [-1;0;0];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;0;1];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [0;0;1];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

% Test cases where the body frame is obtained from the inertial frame by
% two successive rotations.
function test_rotate_x_y_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(pi/4, pi/6, 0, 'XYZ');
    
    v = [1;0;0];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        0.866025403784439;
        0.353553390593274;
        -0.353553390593274];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;1;0];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        -2.775557561562891e-17;
        0.707106781186548;
        0.707106781186548];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;0;1];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        0.5;
        -0.612372435695795;
        0.612372435695795];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

function test_rotate_x_z_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(pi/3, 0, pi/6, 'XYZ');
    
    v = [1;0;0];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        0.866025403784439;
        0.250000000000000;
        0.433012701892219];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;1;0];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        -0.500000000000000;
        0.433012701892219;
        0.750000000000000];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;0;1];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        5.55111512312578e-17;
        -0.866025403784439;
        0.500000000000000];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

function test_rotate_y_z_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(0, pi/4, pi/3, 'XYZ');
    
    v = [1;0;0];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        0.353553390593274;
        0.866025403784439;
        -0.353553390593274];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;1;0];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        -0.612372435695795;
        0.500000000000000;
        0.612372435695795];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;0;1];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        0.707106781186548;
        -5.55111512312578e-17;
        0.707106781186548];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

% Test cases where the body frame is obtained from the inertial frame by
% three successive rotations.
function test_rotate_x_y_z_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(pi/6, pi/4, pi/3, 'XYZ');
    
    v = [1;0;0];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        0.353553390593274;
        0.926776695296637;
        0.126826484044322];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;1;0];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        -0.612372435695795;
        0.126826484044322;
        0.780330085889911];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;0;1];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        0.707106781186548;
        -0.353553390593274;
        0.612372435695795];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

function test_rotate_x_y_neg_z_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(deg2rad(21), deg2rad(36), deg2rad(-20), 'XYZ');
    
    v = [1;0;0];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        0.760227299704533;
        -0.121363266779217;
        -0.638220502851978];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;1;0];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        0.276700108369021;
        0.949322922055961;
        0.149073940337350];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;0;1];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        0.587785252292473;
        -0.289925761421452;
        0.755282430652048];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

% Some tests with non-unit vectors
function test_rotate_x_neg_y_z_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(deg2rad(1), deg2rad(-15), deg2rad(-89), 'XYZ');
    
    v = [10;0;0];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        0.168577301086656;
        -9.99774246294158;
        -0.129334211457006];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;20;0];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        19.3155742221432;
        0.258668422914008;
        5.18089597616726];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;0;1015];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        -262.701330779059;
        -17.1105960602957;
        980.265391773765];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

function test_rotate_x_neg_y_neg_z_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(deg2rad(-31), deg2rad(-78), deg2rad(-23), 'XYZ');
    
    v = [30000;0;0];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        5741.51161461752;
        3864.38960064929;
        29190.7782937284];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;2345;0];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        190.502100663543;
        2311.86623137367;
        -343.523620551627];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;0;0.0023];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        -0.00224973948168775;
        0.000246289605077168;
        0.000409894736446143];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

function test_rotate_neg_x_y_z_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(deg2rad(-41), deg2rad(10), pi/4, 'XYZ');
    
    v = [200;0;0];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        139.272848064004;
        90.6208429116427;
        -111.314584049550];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;2000;0];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        -1392.72848064004;
        1228.43261889147;
        -742.469312535900];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;0;0.0003];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        5.20944533000791e-05;
        0.000193827605455054;
        0.000222973153762792];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

function test_rotate_neg_x_neg_y_z_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(-pi/6, deg2rad(-50), pi/3, 'XYZ');
    
    v = [200;0;230];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        -111.911460948711;
        262.222797269901;
        107.773046260526];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;2000;-100];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        -1036.73635414094;
        170.472075131174;
        -1704.73370460111];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [-20;100;0.0003];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        -62.0951458328403;
        -8.69955301667840;
        -80.4270516766486];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

function test_rotate_neg_x_y_neg_z_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(deg2rad(-20), deg2rad(70), deg2rad(-40), 'XYZ');
    
    v = [200;10;230];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        270.728291930565;
        -138.007469772207;
        -25.6929997359586];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [40;2000;-100];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        356.203463916493;
        980.809943302998;
        -1709.59964535907];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [-20;-100;0.0003];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        -27.2244017360969;
        -34.3213061514730;
        92.0916928623775];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

function test_rotate_neg_x_neg_y_neg_z_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(deg2rad(-20), -pi/2, -pi/2, 'XYZ');
    
    v = [200;100;-230];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        230;
        -153.736509824615;
        162.373290743725];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [40;-2000;-100];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        99.9999999999999;
        -721.627991482774;
        -1865.70443583879];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [-20;-100;0];
    v_prime = coordinate.to_inertial_frame(q,v);
    expected = [
        -5.55111512312578e-15;
        -15.4081619168487;
        -100.809664945104];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end
