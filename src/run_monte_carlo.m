% Runs the trajectory simulation many times in a stochastic manner using
% Monte Carlo. To sample, latin hypercube is used as it is a more
% computationally feasible method. Every variable is normally distributed.
% Now this claim can be argued against.
clc;
clear;
rng default; % For reproducibility

OUTPUT_PATH = "../output";
OUTPUT_FILE = fullfile(OUTPUT_PATH, "output.csv");
INPUT_PATH = "../input";
INPUT_FIELDS_FILE = fullfile(INPUT_PATH, "fields_input.csv");
INPUT_ERRORS_FILE = fullfile(INPUT_PATH, "errors_input.csv");
NUM_OF_SAMPLES = 100;
samples = rocket_samples(INPUT_FIELDS_FILE, INPUT_ERRORS_FILE, NUM_OF_SAMPLES);


%% Perform simulation
points = zeros(NUM_OF_SAMPLES, 6);

for sam_num = 1:NUM_OF_SAMPLES
    vehicle = samples(sam_num);

    [time, state] = trajectory(vehicle);
    [apogee, apogee_time] = find_apogee(time, state(:,3));
    [x, y, landing_time] = find_landing_pos(time, state, vehicle.launch_alt);
    
    % touch down velocity
    v_x = spline(time, state(:,8), landing_time);
    v_y = spline(time, state(:,9), landing_time);
    v_z = spline(time, state(:,10), landing_time);
    v_mag = norm([v_x, v_y, v_z]);
    
    points(sam_num,1) = apogee_time;
    points(sam_num,2) = apogee;
    points(sam_num,3) = landing_time;
    points(sam_num,4) = x;
    points(sam_num,5) = y;
    points(sam_num,6) = v_mag;
end
writematrix(points, OUTPUT_FILE);
scatter(points(:,4), points(:,5));