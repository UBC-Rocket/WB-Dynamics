% Runs the trajectory simulation many times in a stochastic manner using
% Monte Carlo. To sample, latin hypercube is used as it is a more
% computationally feasible method. Every variable is normally distributed.
% Now this claim can be argued against.
clc;
clear;
rng default; % For reproducibility

SAMPLES = 100;

%% Physical properties
load_mass = 657.6964825; % kg
fuselage_dia = 0.4064; % meters
fuselage_length = 7.006609822; % meters
nose_length = 0.7112; % meters

%% Fin properties
num_of_fins = 4;
fin_span = 0.4064;
fin_thickness = 0.01;
fin_leading_edge_sweep_angle = 30;
fin_leading_edge_thickness_angle = 15;

%% Engine properties
burn_time = 36; % s
prop_flow_rate = 12; % kg/s
nozzle_eff = 0.98;
c_star = 1584.619354; % m/s
exit_pressure = 62227.7237; % Pa
chamber_pressure = 900000; % Pa
exp_area_ratio = 2.8;
nozzle_exit_area = 0.06244574; %m^2

%% Recovery properties
ballute_alt = 75000; % meters above sea level
main_chute_alt = 3000; % meters above sea level
ballute_drag_coeff = 0.75;
main_chute_drag_coeff = 0.53;
ballute_dia = 1; % m
main_chute_dia = 4.13; % m
chute_attachment_pos = 5.66; % m

%% Launch properties
launch_angle = 87; % degrees
launch_alt = 1401; % meters above sea level

%% Take samples
stochastic_vars = [
    "load_mass";
    "thrust";
    "CG";
    "CP";
    "CD_vehicle";
    "CD_ballute";
    "CD_chute";
    "ballute_alt";
    "chute_alt";
    "launch_angle"];
errors = [
    0.03
    0.15
    0.03
    0.03
    0.15
    0.15
    0.15
    0.15
    0.15
    0.0015];
types = [
    'norm'
    'norm'
    'norm'
    'norm'
    'norm'
    'norm'
    'norm'
    'norm'
    'norm'
    'norm'];
uncertainties = sampling.create_sample(SAMPLES, stochastic_vars, errors, types);


%% Perform simulation
points = zeros(SAMPLES, 5);

vehicle = create_rocket(...
    load_mass, ...
    fuselage_dia, ...
    fuselage_length, ...
    nose_length, ...
    num_of_fins, ...
    fin_span, ...
    fin_thickness, ...
    fin_leading_edge_sweep_angle, ...
    fin_leading_edge_thickness_angle, ...
    burn_time, ...
    prop_flow_rate, ...
    nozzle_eff, ...
    c_star, ...
    exit_pressure, ...
    chamber_pressure, ...
    exp_area_ratio, ...
    nozzle_exit_area, ...
    ballute_alt, ...
    main_chute_alt, ...
    ballute_drag_coeff, ...
    main_chute_drag_coeff, ...
    ballute_dia, ...
    main_chute_dia, ...
    chute_attachment_pos, ...
    launch_angle, ...
    launch_alt);

for sam_num = 1:SAMPLES
    uncertainty = uncertainties(sam_num);
    [time, state] = trajectory(vehicle, uncertainty);
    [apogee, apogee_time] = find_apogee(time, state(:,3));
    [x, y, landing_time] = find_landing_pos(time, state, launch_alt);
    
    points(sam_num,1) = apogee_time;
    points(sam_num,2) = apogee;
    points(sam_num,3) = landing_time;
    points(sam_num,4) = x;
    points(sam_num,5) = y;
end
writematrix(points, 'output.csv');
scatter(points(:,4), points(:,5));