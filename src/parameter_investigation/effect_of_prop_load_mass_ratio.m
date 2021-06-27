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


%% Total Propellant Load Mass Ratio

propellant_mass_ratio = linspace(0.5, 0.8, NUM_OF_POINTS);

prop_mass_ratio_vs_apogee = zeros(NUM_OF_POINTS, 2);
prop_mass_ratio_vs_apogee(:,1) = propellant_mass_ratio';

non_propellant_mass = vehicle.load_mass - (vehicle.LOX_mass + vehicle.kero_mass);

for i = 1:NUM_OF_POINTS
    curr_vehicle = vehicle;
    curr_ratio = prop_mass_ratio_vs_apogee(i,1);
    prop_mass = non_propellant_mass*curr_ratio/(1 - curr_ratio);
    total_mass = prop_mass + non_propellant_mass;
    LOX_mass = prop_mass * curr_vehicle.LOX_mass / (curr_vehicle.LOX_mass + curr_vehicle.kero_mass);
    kero_mass = prop_mass * curr_vehicle.kero_mass / (curr_vehicle.LOX_mass + curr_vehicle.kero_mass);
    burn_time = prop_mass / curr_vehicle.prop_flow_rate;
    
    curr_vehicle.load_mass = total_mass;
    curr_vehicle.burn_time = burn_time;
    curr_vehicle.LOX_mass = LOX_mass;
    curr_vehicle.kero_mass = kero_mass;
    
    [time, state] = trajectory(curr_vehicle, env, STEP_SIZE);
    [apogee, apogee_time] = util.find_apogee(time, state(:,3));
    
    prop_mass_ratio_vs_apogee(i,2) = apogee;
end

plot(prop_mass_ratio_vs_apogee(:,1), prop_mass_ratio_vs_apogee(:,2));
xlabel('Propellant load mass ratio');
ylabel('Apogee (m)');