function tests = quat_dot_test
    tests = functiontests(localfunctions);
end

function verify_within_tolerance(testCase, expected, actual)
    tolerance = 1e-6;
    tolerance_type = 'AbsTol';

    testCase.verifyEqual(actual, expected, tolerance_type, tolerance);
end

function test_derivative_zero(testCase)
    omega = zeros(3,1);
    expected = zeros(4,1);

    q1 = lin_alg.euler_to_quat(pi/6, deg2rad(20), deg2rad(40), 'XYZ');
    
    result = lin_alg.quat_dot(omega, q1);
    verify_within_tolerance(testCase, expected, result);

    q2 = lin_alg.euler_to_quat(deg2rad(-20), deg2rad(67), deg2rad(21), 'ZYX');
    result = lin_alg.quat_dot(omega, q2);
    verify_within_tolerance(testCase, expected, result);
end

% Test the gradient in all three directions
function test_derivative_positive_x(testCase)
    q = lin_alg.euler_to_quat(deg2rad(10), deg2rad(-10), deg2rad(50), 'XYZ');
    
    omega_1 = [2; 0; 4];
    expected_1 = [
        0.671868035045498;
        0.3285317707357076;
        1.920650036651746;
        -0.8670430530319762];
    result_1 = lin_alg.quat_dot(omega_1, q);
    verify_within_tolerance(testCase, expected_1, result_1);
    
    omega_2 = [10; 3*pi; -1];
    expected_2 = [
        2.6268879543300283;
        6.337176560037195;
        0.32349818300276045;
        0.540010879849585];
    result_2 = lin_alg.quat_dot(omega_2, q);
    verify_within_tolerance(testCase, expected_2, result_2);
    
    omega_3 = [0.1; -2; 0.03];
    expected_3 = [
        0.45592451454373967;
        -0.8826373814364831;
        -0.02268725832145773;
        -0.12367044205815458]; 
    result_3 = lin_alg.quat_dot(omega_3, q);
    verify_within_tolerance(testCase, expected_3, result_3);
end

function test_derivative_positive_y(testCase)
    q = lin_alg.euler_to_quat(pi/6, pi/4, pi/3, 'ZYX');
    
    omega_1 = [0.5*pi; 2*pi; 0];
    expected_1 = [
        0.5759505884649514;
        2.6010130835416168;
        0.7869798634544732;
        -1.6643705205172394];
    result_1 = lin_alg.quat_dot(omega_1, q);
    verify_within_tolerance(testCase, expected_1, result_1);
    
    omega_2 = [0.1; 0.1; 0.1];
    expected_2 = [
        0.061989144236608756;
        0.02420998964851884;
        0.03715534190077225;
        -0.04111815859529999];
    result_2 = lin_alg.quat_dot(omega_2, q);
    verify_within_tolerance(testCase, expected_2, result_2);
    
    omega_3 = [-0.01; 0.0005; -0.3];
    expected_3 = [
        -0.07006934179734517;
        0.05415780150695624;
        -0.1210659712367827;
        0.0050312011005766225]; 
    result_3 = lin_alg.quat_dot(omega_3, q);
    verify_within_tolerance(testCase, expected_3, result_3);
end

function test_derivative_positive_z(testCase)
    q = lin_alg.euler_to_quat(deg2rad(5), pi/2, deg2rad(10), 'ZYX');
    
    omega_1 = [2*pi; 0.01*pi; 0.05];
    expected_1 = [
        2.2374724829168153;
        -0.08657236931895804;
        -2.201181815146679;
        -0.1072234625794139];
    result_1 = lin_alg.quat_dot(omega_1, q);
    verify_within_tolerance(testCase, expected_1, result_1);
    
    omega_2 = [0.001*pi; -pi; pi/2];
    expected_2 = [
        0.5074924928578597;
        -1.1339365024611447;
        0.5052731657088279;
        1.1338396045451955];
    result_2 = lin_alg.quat_dot(omega_2, q);
    verify_within_tolerance(testCase, expected_2, result_2);
    
    omega_3 = [-0.01; 0.0005; 1];
    expected_3 = [
        0.3496924281365309;
        -0.015090956032576567;
        0.3567567658586598;
        0.015399391678548887]; 
    result_3 = lin_alg.quat_dot(omega_3, q);
    verify_within_tolerance(testCase, expected_3, result_3);
end

function test_derivative_negative_x(testCase)
    q = lin_alg.euler_to_quat(deg2rad(-1), pi/4, deg2rad(-35), 'XYZ');
    
    omega_1 = [-pi; pi; 0.1];
    expected_1 = [
        -0.9229240881418852;
        1.8299457933293368;
        0.42063948909244103;
        -0.7482473800585383];
    result_1 = lin_alg.quat_dot(omega_1, q);
    verify_within_tolerance(testCase, expected_1, result_1);
    
    omega_2 = [-4; -2; 10];
    expected_2 = [
        -0.2284868765095842;
        0.295698108616428;
        5.248235749641603;
        1.5219651415217859];
    result_2 = lin_alg.quat_dot(omega_2, q);
    verify_within_tolerance(testCase, expected_2, result_2);
    
    omega_3 = [-0.00025; 0.000004; 0.45];
    expected_3 = [
        0.08146056869087889;
        0.027657854022899747;
        0.19806347910092273;
        0.06320674595994441]; 
    result_3 = lin_alg.quat_dot(omega_3, q);
    verify_within_tolerance(testCase, expected_3, result_3);
end

function test_derivative_negative_y(testCase)
    q = lin_alg.euler_to_quat(pi/2, deg2rad(20), pi/6, 'XYZ');
    
    omega_1 = [10*pi; -5*pi; 8*pi];
    expected_1 = [
        11.6391573150832;
        -9.191118448048034;
        3.4888251794860734;
        -15.304256449993021];
    result_1 = lin_alg.quat_dot(omega_1, q);
    verify_within_tolerance(testCase, expected_1, result_1);
    
    omega_2 = [23; -2*pi; 0.054];
    expected_2 = [
        8.307006158611186;
        1.4042878108109051;
        -1.486958299065793;
        -8.302464263285486];
    result_2 = lin_alg.quat_dot(omega_2, q);
    verify_within_tolerance(testCase, expected_2, result_2);
    
    omega_3 = [-0.0041; -0.0004567; 0.35];
    expected_3 = [
        -0.01203048925343872;
        -0.124031758464722;
        0.11186267520586575;
        -0.050866361772602495]; 
    result_3 = lin_alg.quat_dot(omega_3, q);
    verify_within_tolerance(testCase, expected_3, result_3);
end

function test_derivative_negative_z(testCase)
    q = lin_alg.euler_to_quat(pi/4, deg2rad(-10), -pi/4, 'XYZ');
    
    omega_1 = [pi/4000; -3*pi; -pi/1000];
    expected_1 = [
        -1.804733101890504;
        -3.9463710366473146;
        -1.806293380450909;
        0.33617081945916155];
    result_1 = lin_alg.quat_dot(omega_1, q);
    verify_within_tolerance(testCase, expected_1, result_1);
    
    omega_2 = [-pi; 3*pi; -0.05];
    expected_2 = [
        0.48755484002613714;
        4.558047728316798;
        1.8963187809161257;
        0.25515146133493444];
    result_2 = lin_alg.quat_dot(omega_2, q);
    verify_within_tolerance(testCase, expected_2, result_2);
    
    omega_3 = [pi/2; 5*pi; -10*pi];
    expected_3 = [
        2.542976933102407;
        12.293711161163671;
        -10.203978567010907;
        -6.878862072805471]; 
    result_3 = lin_alg.quat_dot(omega_3, q);
    verify_within_tolerance(testCase, expected_3, result_3);
end
