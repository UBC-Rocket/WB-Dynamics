function tests = simulation_samples_test
    tests = functiontests(localfunctions);
end

% Essentially just check that the mean and sd of the samples match what was
% inputted.
function test_take_sample(testCase)
    rng default; % For reproducibility
    num_of_samples = 10000;
    
    proj = matlab.project.rootProject;
    curr_dir = ...
        fullfile(proj.RootFolder, "tests", "simulation_samples_test");
    
    fields_path = fullfile(curr_dir, 'fields_input.csv');
    errors_path = fullfile(curr_dir, 'errors_input.csv');
    
    [vehicle_samples, env_samples] = simulation_samples(...
        fields_path,...
        errors_path,...
        num_of_samples);
    
    load_mass_samples = zeros(num_of_samples,1);
    thrust_variation_samples = zeros(num_of_samples,1);
    CG_variation_samples = zeros(num_of_samples,1);
    CP_variation_samples = zeros(num_of_samples,1);
    CD_vehicle_variation_samples = zeros(num_of_samples,1);
    thrust_misalignment_samples = zeros(num_of_samples,1);
    CD_ballute_samples = zeros(num_of_samples,1);
    CD_chute_samples = zeros(num_of_samples,1);
    ballute_alt_samples = zeros(num_of_samples,1);
    chute_alt_samples = zeros(num_of_samples,1);
    launch_angle_samples = zeros(num_of_samples,1);
    launch_direction_samples = zeros(num_of_samples,1);
    wind_meridional_variation_samples = zeros(num_of_samples,1);
    wind_zonal_variation_samples = zeros(num_of_samples,1);
    
    for i = 1:num_of_samples
        curr_vehicle = vehicle_samples(i);
        load_mass_samples(i) = curr_vehicle.load_mass;
        thrust_variation_samples(i) = curr_vehicle.thrust_uncertainty.rand;
        CG_variation_samples(i) = curr_vehicle.CG_uncertainty.rand;
        CP_variation_samples(i) = curr_vehicle.CP_uncertainty.rand;
        CD_vehicle_variation_samples(i) = curr_vehicle.CD_uncertainty.rand;
        thrust_misalignment_samples(i) = curr_vehicle.thrust_misalign_angle;
        CD_ballute_samples(i) = curr_vehicle.ballute_drag_coeff;
        CD_chute_samples(i) = curr_vehicle.main_chute_drag_coeff;
        ballute_alt_samples(i) = curr_vehicle.ballute_alt;
        chute_alt_samples(i) = curr_vehicle.main_chute_alt;
        launch_angle_samples(i) = curr_vehicle.launch_angle;
        launch_direction_samples(i) = curr_vehicle.launch_direction;
        
        curr_env = env_samples(i);
        wind_meridional_variation_samples(i) = curr_env.wind_meridional_uncertainty.rand;
        wind_zonal_variation_samples(i) = curr_env.wind_zonal_uncertainty.rand;
    end
    
    testCase.verifyEqual(mean(load_mass_samples), 100, 'AbsTol', 1e-3);
    testCase.verifyEqual(std(load_mass_samples), 1, 'AbsTol', 1e-3);
    testCase.verifyEqual(mean(thrust_variation_samples), 0, 'AbsTol', 1e-3);
    testCase.verifyEqual(std(thrust_variation_samples), 1/3, 'AbsTol', 1e-3);
    testCase.verifyEqual(mean(CG_variation_samples), 0, 'AbsTol', 1e-3);
    testCase.verifyEqual(std(CG_variation_samples), 1/3, 'AbsTol', 1e-3);
    testCase.verifyEqual(mean(CP_variation_samples), 0, 'AbsTol', 1e-3);
    testCase.verifyEqual(std(CP_variation_samples), 1/3, 'AbsTol', 1e-3);
    testCase.verifyEqual(mean(CD_vehicle_variation_samples), 0, 'AbsTol', 1e-3);
    testCase.verifyEqual(std(CD_vehicle_variation_samples), 1/3, 'AbsTol', 1e-3);
    testCase.verifyEqual(mean(thrust_misalignment_samples), 0, 'AbsTol', 1e-3);
    testCase.verifyEqual(std(thrust_misalignment_samples), 0, 'AbsTol', 1e-3);
    testCase.verifyEqual(mean(CD_ballute_samples), 0.7, 'AbsTol', 1e-3);
    testCase.verifyEqual(std(CD_ballute_samples), 0.03, 'AbsTol', 1e-3);
    testCase.verifyEqual(mean(CD_chute_samples), 0.5, 'AbsTol', 1e-3);
    testCase.verifyEqual(std(CD_chute_samples), 0.02, 'AbsTol', 1e-3);
    testCase.verifyEqual(mean(ballute_alt_samples), 5000, 'AbsTol', 1e-3);
    testCase.verifyEqual(std(ballute_alt_samples), 1, 'AbsTol', 1e-3);
    testCase.verifyEqual(mean(chute_alt_samples), 3000, 'AbsTol', 1e-3);
    testCase.verifyEqual(std(chute_alt_samples), 2, 'AbsTol', 1e-3);
    testCase.verifyEqual(mean(launch_angle_samples), 89, 'AbsTol', 1e-3);
    testCase.verifyEqual(std(launch_angle_samples), 0.05, 'AbsTol', 1e-3);
    testCase.verifyEqual(mean(launch_direction_samples), 0.1, 'AbsTol', 1e-3);
    testCase.verifyEqual(std(launch_direction_samples), 0.05, 'AbsTol', 1e-3);
    testCase.verifyEqual(mean(wind_meridional_variation_samples), 0, 'AbsTol', 1e-3);
    testCase.verifyEqual(std(wind_meridional_variation_samples), 1/3, 'AbsTol', 1e-3);
    testCase.verifyEqual(mean(wind_zonal_variation_samples), 0, 'AbsTol', 1e-3);
    testCase.verifyEqual(std(wind_zonal_variation_samples), 1/3, 'AbsTol', 1e-3);
end

