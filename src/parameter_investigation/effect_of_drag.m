clc;
clear;
close all;

PROJ = matlab.project.rootProject;
PROJ_PATH = PROJ.RootFolder;

INPUT_PATH = fullfile(PROJ_PATH, "input");
INPUT_FILE = fullfile(INPUT_PATH, "fields_input.csv");

vehicle = rocket_nominal(INPUT_FILE);
env = environment.environment_nominal();

STEP_SIZE = 0.1;

NUM_OF_POINTS = 50;


%% Drag force scaling factor
drag_scaling_factors = linspace(-10, 10, NUM_OF_POINTS);
drag_scaling_vs_apogee = zeros(NUM_OF_POINTS, 2);
drag_scaling_vs_apogee(:,1) = drag_scaling_factors';

for i = 1:NUM_OF_POINTS
    curr_vehicle = vehicle;
    
    scaling_percentange = drag_scaling_factors(i)/100;
    curr_vehicle.CD_uncertainty.rand = 1;
    curr_vehicle.CD_uncertainty.var = scaling_percentange;
    
    [time, state] = trajectory(curr_vehicle, env, STEP_SIZE);
    [apogee, apogee_time] = util.find_apogee(time, state(:,3));
    
    drag_scaling_vs_apogee(i,2) = apogee;
end

%% Plotting
plot(drag_scaling_vs_apogee(:,1), drag_scaling_vs_apogee(:,2));