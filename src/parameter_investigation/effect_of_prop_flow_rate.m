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


%% Propellant flow rate
prop_flow_rates = linspace(5, 20, NUM_OF_POINTS);

prop_flow_rate_vs_apogee = zeros(NUM_OF_POINTS, 2);
prop_flow_rate_vs_apogee(:,1) = prop_flow_rates';

for i = 1:NUM_OF_POINTS
    curr_vehicle = vehicle;
    
    curr_prop_flow_rate = prop_flow_rates(i);
    mass_flow_LOX = curr_prop_flow_rate * vehicle.mass_flow_LOX / vehicle.prop_flow_rate;
    mass_flow_kero = curr_prop_flow_rate * vehicle.mass_flow_kero / vehicle.prop_flow_rate;
    burn_time = (vehicle.LOX_mass + vehicle.kero_mass) / curr_prop_flow_rate;
    
    curr_vehicle.prop_flow_rate = curr_prop_flow_rate;
    curr_vehicle.mass_flow_LOX = mass_flow_LOX;
    curr_vehicle.mass_flow_kero = mass_flow_kero;
    curr_vehicle.burn_time = burn_time;
    
    [time, state] = trajectory(curr_vehicle, env, STEP_SIZE);
    [apogee, apogee_time] = util.find_apogee(time, state(:,3));
    
    prop_flow_rate_vs_apogee(i,2) = apogee;
end

plot(prop_flow_rate_vs_apogee(:,1), prop_flow_rate_vs_apogee(:,2));
xlabel('Propellant flow rate (kg/s)');
ylabel('Apogee (m)');