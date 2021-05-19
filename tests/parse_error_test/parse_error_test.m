function tests = parse_error_test
    tests = functiontests(localfunctions);
end

function test_parse_good_input(testCase)
    result = util.parse_error('./good_input.csv');
    testCase.verifyEqual(result.load_mass_sd, 1);
    testCase.verifyEqual(result.thrust_variation, 0.05);
    testCase.verifyEqual(result.CG_variation, 0.01);
    testCase.verifyEqual(result.CP_variation, 0.02);
    testCase.verifyEqual(result.CD_vehicle_variation, 0.1);
    testCase.verifyEqual(result.thrust_misalign_angle_sd, 0);
    testCase.verifyEqual(result.CD_ballute_sd, 0.03);
    testCase.verifyEqual(result.CD_chute_sd, 0.02);
    testCase.verifyEqual(result.ballute_alt_sd, 1);
    testCase.verifyEqual(result.chute_alt_sd, 2);
    testCase.verifyEqual(result.launch_angle_sd, 0.05);
    testCase.verifyEqual(result.launch_direction_sd, 0.05);
    testCase.verifyEqual(result.wind_speed_variation, 0.1);
end

function test_parse_bad_structure(testCase)
    testCase.verifyError(...
        @()util.parse_error('./bad_values.csv'),...
        'errors_input:bad_input');
end

function test_parse_bad_values(testCase)
    testCase.verifyError(...
        @()util.parse_error('./bad_values.csv'),...
        'errors_input:bad_input');
end

