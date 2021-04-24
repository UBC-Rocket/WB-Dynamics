%%  Unit tests for the `f_g` function to compute gravitational force
%   Essentially the tests will try out a couple of different altitudes
%   with a couple different masses at each altitude.

function tests = f_g_test
    tests = functiontests(localfunctions);
end

function test_sea_level_small_mass(testCase)
    m = 0.01;
    h = 0;
    expected = -0.098200;
    f_grav = f_g(m, h);
    verifyEqual(testCase, f_grav(1), 0);
    verifyEqual(testCase, round(f_grav(2), 5, 'significant'), expected);
    verifyEqual(testCase, f_grav(3), 0);
end

function test_sea_level_unit_mass(testCase)
    m = 1;
    h = 0;
    expected = -9.8200;
    f_grav = f_g(m, h);
    verifyEqual(testCase, f_grav(1), 0);
    verifyEqual(testCase, round(f_grav(2), 5, 'significant'), expected);
    verifyEqual(testCase, f_grav(3), 0);
end

function test_sea_level_big_mass(testCase)
    m = 100;
    h = 0;
    expected = -982.00;
    f_grav = f_g(m, h);
    verifyEqual(testCase, f_grav(1), 0);
    verifyEqual(testCase, round(f_grav(2), 5, 'significant'), expected);
    verifyEqual(testCase, f_grav(3), 0);
end

function test_50km_small_mass(testCase)
    m = 0.01;
    h = 50000;
    expected = -0.096676;
    f_grav = f_g(m, h);
    verifyEqual(testCase, f_grav(1), 0);
    verifyEqual(testCase, round(f_grav(2), 5, 'significant'), expected);
    verifyEqual(testCase, f_grav(3), 0);
end

function test_50km_unit_mass(testCase)
    m = 1;
    h = 50000;
    expected = -9.6676;
    f_grav = f_g(m, h);
    verifyEqual(testCase, f_grav(1), 0);
    verifyEqual(testCase, round(f_grav(2), 5, 'significant'), expected);
    verifyEqual(testCase, f_grav(3), 0);
end

function test_50km_big_mass(testCase)
    m = 100;
    h = 50000;
    expected = -966.76;
    f_grav = f_g(m, h);
    verifyEqual(testCase, f_grav(1), 0);
    verifyEqual(testCase, round(f_grav(2), 5, 'significant'), expected);
    verifyEqual(testCase, f_grav(3), 0);
end

function test_100km_small_mass(testCase)
    m = 0.01;
    h = 100000;
    expected = -0.095188;
    f_grav = f_g(m, h);
    verifyEqual(testCase, f_grav(1), 0);
    verifyEqual(testCase, round(f_grav(2), 5, 'significant'), expected);
    verifyEqual(testCase, f_grav(3), 0);
end

function test_100km_unit_mass(testCase)
    m = 1;
    h = 100000;
    expected = -9.5188;
    f_grav = f_g(m, h);
    verifyEqual(testCase, f_grav(1), 0);
    verifyEqual(testCase, round(f_grav(2), 5, 'significant'), expected);
    verifyEqual(testCase, f_grav(3), 0);
end

function test_100km_big_mass(testCase)
    m = 100;
    h = 100000;
    expected = -951.88;
    f_grav = f_g(m, h);
    verifyEqual(testCase, f_grav(1), 0);
    verifyEqual(testCase, round(f_grav(2), 5, 'significant'), expected);
    verifyEqual(testCase, f_grav(3), 0);
end

function test_150km_small_mass(testCase)
    m = 0.01;
    h = 150000;
    expected = -0.093734;
    f_grav = f_g(m, h);
    verifyEqual(testCase, f_grav(1), 0);
    verifyEqual(testCase, round(f_grav(2), 5, 'significant'), expected);
    verifyEqual(testCase, f_grav(3), 0);
end

function test_150km_unit_mass(testCase)
    m = 1;
    h = 150000;
    expected = -9.3734;
    f_grav = f_g(m, h);
    verifyEqual(testCase, f_grav(1), 0);
    verifyEqual(testCase, round(f_grav(2), 5, 'significant'), expected);
    verifyEqual(testCase, f_grav(3), 0);
end

function test_150km_big_mass(testCase)
    m = 100;
    h = 150000;
    expected = -937.34;
    f_grav = f_g(m, h);
    verifyEqual(testCase, f_grav(1), 0);
    verifyEqual(testCase, round(f_grav(2), 5, 'significant'), expected);
    verifyEqual(testCase, f_grav(3), 0);
end


