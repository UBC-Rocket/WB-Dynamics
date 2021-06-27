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



%% Thrust misalignment
misalignment_angles = linspace(0, 5, NUM_OF_POINTS);

misalignment_vs_apogee = zeros(NUM_OF_POINTS,2);
misalignment_vs_apogee(:,1) = misalignment_angles';

for i = 1:NUM_OF_POINTS
    curr_vehicle = vehicle;
    curr_vehicle.thrust_misalign_angle = misalignment_angles(i);
    
    [time, state] = trajectory(curr_vehicle, env, STEP_SIZE);
    [apogee, apogee_time] = util.find_apogee(time, state(:,3));
    misalignment_vs_apogee(i,2) = apogee;
end

plot(misalignment_vs_apogee(:,1), misalignment_vs_apogee(:,2));
xlabel('Misalignment angle (degrees)');
ylabel('Apogee (m)');