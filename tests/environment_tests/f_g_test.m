%%  Unit tests for the `f_g` function to compute gravitational force
%   Essentially the tests will try out a couple of different altitudes
%   with a couple different masses at each altitude. Note that since we are
%   comparing floating point values, we just compare relative tolerances 
%   instead of a strict equality.

function tests = f_g_test
    tests = functiontests(localfunctions);
end

function verify(testCase, expected, actual)
    tolerance = 1e-5;
    verifyEqual(testCase, actual(1), 0);
    verifyEqual(testCase, actual(2), 0);
    verifyEqual(testCase, actual(3), expected, 'RelTol', tolerance);
end

function test_0km_small_mass(testCase)
    m = 0.01;
    h = 0;
    expected = -0.098175;
    f_grav = environment.f_g(m, h);
    verify(testCase, expected, f_grav);
end

function test_0km_unit_mass(testCase)
    m = 1;
    h = 0;
    expected = -9.8175;
    f_grav = environment.f_g(m, h);
    verify(testCase, expected, f_grav);
end

function test_0km_big_mass(testCase)
    m = 100;
    h = 0;
    expected = -981.75;
    f_grav = environment.f_g(m, h);
    verify(testCase, expected, f_grav);
end

function test_50km_small_mass(testCase)
    m = 0.01;
    h = 50000;
    expected = -0.096652;
    f_grav = environment.f_g(m, h);
    verify(testCase, expected, f_grav);
end

function test_50km_unit_mass(testCase)
    m = 1;
    h = 50000;
    expected = -9.6652;
    f_grav = environment.f_g(m, h);
    verify(testCase, expected, f_grav);
end

function test_50km_big_mass(testCase)
    m = 100;
    h = 50000;
    expected = -966.52;
    f_grav = environment.f_g(m, h);
    verify(testCase, expected, f_grav);
end

function test_100km_small_mass(testCase)
    m = 0.01;
    h = 100000;
    expected = -0.095164;
    f_grav = environment.f_g(m, h);
    verify(testCase, expected, f_grav);
end

function test_100km_unit_mass(testCase)
    m = 1;
    h = 100000;
    expected = -9.5164;
    f_grav = environment.f_g(m, h);
    verify(testCase, expected, f_grav);
end

function test_100km_big_mass(testCase)
    m = 100;
    h = 100000;
    expected = -951.64;
    f_grav = environment.f_g(m, h);
    verify(testCase, expected, f_grav);
end

function test_150km_small_mass(testCase)
    m = 0.01;
    h = 150000;
    expected = -0.093710;
    f_grav = environment.f_g(m, h);
    verify(testCase, expected, f_grav);
end

function test_150km_unit_mass(testCase)
    m = 1;
    h = 150000;
    expected = -9.3710;
    f_grav = environment.f_g(m, h);
    verify(testCase, expected, f_grav);
end

function test_150km_big_mass(testCase)
    m = 100;
    h = 150000;
    expected = -937.10;
    f_grav = environment.f_g(m, h);
    verify(testCase, expected, f_grav);
end


