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

%% Effect of mass
mass_delta = linspace(-25, 150, NUM_OF_POINTS);
mass_vs_apogee = zeros(NUM_OF_POINTS, 2);
mass_vs_apogee(:,1) = mass_delta' + vehicle.load_mass;

for i = 1:NUM_OF_POINTS
    curr_vehicle = vehicle;
    curr_mass_delta = mass_delta(i);
    tank_mass_delta = curr_mass_delta/3;
    
    curr_vehicle.load_mass = mass_vs_apogee(i, 1);
    curr_vehicle.pressurant_tank_mass = curr_vehicle.pressurant_tank_mass + tank_mass_delta;
    curr_vehicle.LOX_tank_mass = curr_vehicle.LOX_tank_mass + tank_mass_delta;
    curr_vehicle.kero_tank_mass = curr_vehicle.kero_tank_mass + tank_mass_delta;
    
    [time, state] = trajectory(curr_vehicle, env, STEP_SIZE);
    [apogee, apogee_time] = util.find_apogee(time, state(:,3));
    mass_vs_apogee(i,2) = apogee;
end

plot(mass_vs_apogee(:,1), mass_vs_apogee(:,2));
xlabel('mass (kg)');
ylabel('Apogee (m)');