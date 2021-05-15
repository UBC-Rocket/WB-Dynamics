% Runs the trajectory simulation once in a non stochastic manner using the
% average values of each parameter.
clc;
clear;
%close all;
format short g;

INPUT_PATH = "../input";
INPUT_FILE = fullfile(INPUT_PATH, "fields_input.csv");
vehicle = rocket_nominal(INPUT_FILE);

SIM_END_TIME = 600;
STEP_SIZE = 0.1;

%% Run simulation
[time, state] = trajectory(vehicle, SIM_END_TIME, STEP_SIZE);

%% Plot animation
visualization.animate(time, state, vehicle);