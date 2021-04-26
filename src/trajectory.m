clc;
clear;

%% Simulation params
TIME_STEP = 0.1;
START_TIME = 0;
END_TIME = 210;

%% Physical properties
load_mass = 319.5162962; % kg
fuselage_dia = 0.3048; % meters
fuselage_length = 5.943587967; % meters
nose_length = 0.6; % meters

%% Engine properties
burn_time = 32; % s
prop_flow_rate = 5.625; % kg/s
nozzle_eff = 0.98;
c_star = 1584.619354; % m/s
exit_pressure = 77295.59995; % Pa
chamber_pressure = 1000000; % Pa
exp_area_ratio = 2.6;
nozzle_exit_area = 0.029670491; %m^2

%% Recovery properties
ballute_alt = 75000; % meters above sea level
main_chute_alt = 3000; % meters above sea level
ballute_drag_coeff = 0.75;
main_chute_drag_coeff = 0.53;
ballute_dia = 1; % m
main_chute_dia = 4.13; % m

%% Launch properties
launch_angle = 90; % degrees
launch_alt = 1401; % meters above sea level

vehicle = create_rocket(...
    load_mass, ...
    fuselage_dia, ...
    fuselage_length, ...
    nose_length, ...
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
    launch_angle, ...
    launch_alt);

env = create_environment();

stateInit = [
    0;
    0;
    launch_alt;
    0;
    0;
    0]; 
func = @(time, state) rocket_ode(time, state, vehicle, env);
[time, state] = ode45(func, (START_TIME:TIME_STEP:END_TIME), stateInit);