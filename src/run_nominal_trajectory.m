% Runs the trajectory simulation once in a non stochastic manner using the
% average values of each parameter.
clc;
clear;

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
[nvars, ~] = size(stochastic_vars);
% set error to zero for no uncertainties
errors = zeros(1,nvars);
scaling = zeros(1,nvars);
uncertainties = sampling.create_sample_struct(stochastic_vars, errors, scaling);

[time, state] = trajectory(vehicle, uncertainties);
plot(time, state(:,3));
%plot(state(:,1), state(:,2));