% The expected values were generated using MATLAB's own robotics toolkit.
% You are probably wondering why I did not just use the toolkit instead of
% writing my own function. One, MATLAB does not seem to have solid support
% for a way to list and get dependencies which makes it a bit harder for
% other people to use as they have to figure out the dependencies and
% install it. Two, I have finer control over what the algorithm actually
% does which makes it easier to profile (not that some matrix generation
% and multiplication will ever need to be profiled).
function tests = to_body_frame_test
    tests = functiontests(localfunctions);
end

% Setup acceptable tolerance level
function setup(testCase)
    testCase.TestData.tolerance = 1e-6;
    testCase.TestData.tolerance_type = 'AbsTol';
end

% Start with some trival test cases
function test_rotate_x_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(pi/2, 0, 0, 'XYZ');
    
    v = [1;0;0];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [1;0;0];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;1;0];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [0;0;-1];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;0;1];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [0;1;0];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

function test_rotate_y_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(0, pi/2, 0, 'XYZ');
    
    v = [1;0;0];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [0;0;1];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;1;0];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [0;1;0];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;0;1];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [-1;0;0];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

function test_rotate_z_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(0, 0, pi/2, 'XYZ');
    
    v = [1;0;0];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [0;-1;0];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;1;0];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [1;0;0];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;0;1];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [0;0;1];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

function test_rotate_x_y_z_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(pi/6, pi/4, pi/3, 'XYZ');
    
    v = [1;0;0];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        0.353553390593274;
        -0.612372435695795;
        0.707106781186548];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;1;0];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        0.926776695296637;
        0.126826484044322;
        -0.353553390593274];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;0;1];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        0.126826484044322;
        0.780330085889911;
        0.612372435695795];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

function test_rotate_x_y_neg_z_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(deg2rad(21), deg2rad(36), deg2rad(-20), 'XYZ');
    
    v = [1;0;0];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        0.760227299704533;
        0.276700108369021;
        0.587785252292473];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;1;0];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        -0.121363266779217;
        0.949322922055961;
        -0.289925761421452];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;0;1];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        -0.638220502851978;
        0.149073940337350;
        0.755282430652048];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

% Some tests with non-unit vectors
function test_rotate_x_neg_y_z_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(deg2rad(1), deg2rad(-15), deg2rad(-89), 'XYZ');
    
    v = [10;0;0];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        0.168577301086656;
        9.65778711107158;
        -2.58819045102521];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;20;0];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        -19.9954849258832;
        0.258668422914008;
        -0.337154602173315];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;0;1015];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        -13.1274224628861;
        262.930470790488;
        980.265391773765];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

function test_rotate_x_neg_y_neg_z_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(deg2rad(-31), deg2rad(-78), deg2rad(-23), 'XYZ');
    
    v = [30000;0;0];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        5741.51161461752;
        2437.12708738008;
        -29344.4280220142];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;2345;0];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        302.066453784086;
        2311.86623137367;
        251.108314741722];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;0;0.0023];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        0.00223795966918585;
        -0.000336931482843813;
        0.000409894736446143];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

function test_rotate_neg_x_y_z_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(deg2rad(-41), deg2rad(10), deg2rad(45), 'XYZ');
    
    v = [200;0;0];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        139.272848064004;
        -139.272848064004;
        34.7296355333861];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;2000;0];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        906.208429116427;
        1228.43261889147;
        1292.18403636702];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;0;0.0003];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        -0.000166971876074325;
        -0.000111370396880385;
        0.000222973153762792];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

function test_rotate_neg_x_neg_y_z_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(-pi/6, deg2rad(-50), pi/3, 'XYZ');
    
    v = [200;0;230];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        40.9784435728715;
        -300.976746283308;
        -25.1746968017191];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [0;2000;-100];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        1893.15279434026;
        285.064788849424;
        587.120569763898];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [-20;100;0.0003];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        87.7232045893907;
        21.2637334053037;
        47.4604363478263];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

function test_rotate_neg_x_y_neg_z_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(deg2rad(-20), deg2rad(70), deg2rad(-40), 'XYZ');
    
    v = [200;10;230];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        -61.1169508563557;
        -141.705780238225;
        263.028877055539];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [40;2000;-100];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        -1644.31052284871;
        1118.27039936766;
        239.403881228131];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [-20;-100;0.0003];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        79.7822815998362;
        -55.7230105683398;
        -30.4915338416278];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

function test_rotate_neg_x_neg_y_neg_z_quat(testCase)
    tolerance = testCase.TestData.tolerance;
    tolerance_type = testCase.TestData.tolerance_type;
    q = lin_alg.euler_to_quat(deg2rad(-20), -pi/2, -pi/2, 'XYZ');
    
    v = [200;100;-230];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        -172.633895043495;
        -181.927288448192;
        -200];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [40;-2000;-100];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        1845.18322723925;
        -778.009548729929;
        -40.0000000000001];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
    
    v = [-20;-100;0];
    v_prime = coordinate.to_body_frame(q,v);
    expected = [
        93.9692620785908;
        -34.2020143325669;
        20.0000000000000];
    verifyEqual(testCase, v_prime, expected, tolerance_type, tolerance);
end

