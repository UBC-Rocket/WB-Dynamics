function tests = euler_to_quat_test
    tests = functiontests(localfunctions);
end

% Check if two the two quaternions `expected` and `actual` are equal to the
% specified tolerance level;
function verify(testCase, expected, actual)
    tolerance = 1e-5;
    verifyEqual(testCase, expected(1), actual(1), 'RelTol', tolerance);
    verifyEqual(testCase, expected(2), actual(2), 'RelTol', tolerance);
    verifyEqual(testCase, expected(3), actual(3), 'RelTol', tolerance);
    verifyEqual(testCase, expected(4), actual(4), 'RelTol', tolerance);
end

function test_rotate_x_y_z(testCase)
    q = lin_alg.euler_to_quat([90, 60, 30]);
    expected = [
        0.683012701892219;
        0.183012701892219;
        0.500000000000000;
        0.500000000000000];
    verify(testCase, expected, q);
end

function test_rotate_x_y_neg_z(testCase)
    q = lin_alg.euler_to_quat([30, 30, -45]);
    expected = [
        0.135299025036549;
        0.326640741219094;
        -0.295160309540330;
        0.887626268016025];
    verify(testCase, expected, q);
end

function test_rotate_x_neg_y_z(testCase)
    q = lin_alg.euler_to_quat([20, -60, 70]);
    expected = [
        -0.159244118269248;
        -0.489610207818600;
        0.418063163371769;
        0.748429252921121];
    verify(testCase, expected, q);
end

function test_rotate_x_neg_y_neg_z(testCase)
    q = lin_alg.euler_to_quat([50, -60, -30]);
    expected = [
        0.470811924208330;
        -0.342985757141044;
        -0.407252279861359;
        0.703450412587383];
    verify(testCase, expected, q);
end

function test_rotate_neg_x_y_z(testCase)
    q = lin_alg.euler_to_quat([-40, 80, 10]);
    expected = [
        -0.208361577654914;
        0.624559318381697;
        -0.156270988962034;
        0.736267946326996];
    verify(testCase, expected, q);
end

function test_rotate_neg_x_y_neg_z(testCase)
    q = lin_alg.euler_to_quat([-70, 25, -90]);
    expected = [
        -0.521333804473597;
        -0.270598050073098;
        -0.653281482438188;
        0.477714417108261];
    verify(testCase, expected, q);
end

function test_rotate_neg_x_neg_y_z(testCase)
    q = lin_alg.euler_to_quat([-17, -89, 36]);
    expected = [
        -0.314479044258746;
        -0.626704093717776;
        0.316515927272437;
        0.638876026645512];
    verify(testCase, expected, q);
end

function test_rotate_neg_x_neg_y_neg_z(testCase)
    q = lin_alg.euler_to_quat([-5, -64, -21]);
    expected = [
        0.060106287204435;
        -0.527290933095440;
        -0.131669703362746;
        0.837266143666520];
    verify(testCase, expected, q);
end
