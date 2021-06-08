% Runs the trajectory simulation once in a non stochastic manner using the
% average values of each parameter.
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


%% Run simulation
[time, state] = trajectory(vehicle, env, STEP_SIZE);

%% Plot
plot(time, state(:,3))
