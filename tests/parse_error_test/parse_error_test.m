function tests = parse_error_test
    tests = functiontests(localfunctions);
end

function setup(testCase)
    proj = matlab.project.rootProject;
    testCase.TestData.curr_dir = ...
        fullfile(proj.RootFolder, "tests", "parse_error_test");
end

function test_parse_good_input(testCase)
    file_path = fullfile(testCase.TestData.curr_dir, 'good_input.csv');
    result = util.parse_error(file_path);
    
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
    testCase.verifyEqual(result.wind_meridional_velocity_variation, 0.03);
    testCase.verifyEqual(result.wind_zonal_velocity_variation, 0.05);
end

function test_parse_bad_structure(testCase)
    file_path = fullfile(testCase.TestData.curr_dir, 'bad_structure.csv');
    testCase.verifyError(...
        @()util.parse_error(file_path),...
        'errors_input:bad_input');
end

function test_parse_bad_values(testCase)
    file_path = fullfile(testCase.TestData.curr_dir, 'bad_values.csv');
    testCase.verifyError(...
        @()util.parse_error(file_path),...
        'errors_input:bad_input');
end

