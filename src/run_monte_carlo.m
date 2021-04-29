% Runs the trajectory simulation many times in a stochastic manner using
% Monte Carlo. To sample, latin hypercube is used as it is a more
% computationally feasible method. Every variable is normally distributed.
% Now this claim can be argued against.
clc;
clear;
rng default; % For reproducibility

NUM_OF_SAMPLES = 100;

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
% Variables that will be sampled:
%   load_mass
%   thrust
%	CG
%	CP
%	CD_vehicle
%	CD_ballute
%	CD_chute
%	ballute_alt
%	chute_alt
%	launch_angle
% All from a normal distribution.

load_mass_sd = 0.01;
thrust_err = 0.05;
CG_err = 0.05;
CP_err = 0.05;
CD_vehicle_err = 0.05;
CD_chute_sd = 0.05;
CD_ballute_sd = 0.05;
chute_alt_sd = 0.01;
ballute_alt_sd = 0.01;
launch_angle_sd = 0.0005;

means = [
    load_mass;
    0;
    0;
    0;
    0;
    main_chute_drag_coeff;
    ballute_drag_coeff;
    main_chute_alt;
    ballute_alt;
    launch_angle]';

sds = [
    load_mass_sd;
    1/3;    % Normal distribution with -3 sigma at -1 and 3 sigma at 1 has sd of about 1/3
    1/3;
    1/3;
    1/3;
    CD_chute_sd;
    CD_ballute_sd;
    chute_alt_sd;
    ballute_alt_sd;
    launch_angle_sd]';
  
[~, nvar] = size(means);
    
uncertainties = sampling.latin_hs_norm(means, sds, NUM_OF_SAMPLES, nvar);


%% Perform simulation
points = zeros(NUM_OF_SAMPLES, 5);

for sam_num = 1:NUM_OF_SAMPLES
    % Parse sample results
    load_mass_sam = uncertainties(sam_num,1);
    thrust_uncertainty = sampling.create_uncertainty(thrust_err,uncertainties(sam_num, 2));
    CG_uncertainty = sampling.create_uncertainty(CG_err,uncertainties(sam_num, 3));
    CP_uncertainty = sampling.create_uncertainty(CP_err,uncertainties(sam_num, 4));
    CD_uncertainty = sampling.create_uncertainty(CD_vehicle_err,uncertainties(sam_num, 5));
    main_chute_drag_coeff_sam = uncertainties(sam_num,6);
    ballute_drag_coeff_sam = uncertainties(sam_num,7);
    main_chute_alt_sam = uncertainties(sam_num,8);
    ballute_alt_sam = uncertainties(sam_num,9);
    launch_angle_sam = uncertainties(sam_num,10);
    
    vehicle = create_rocket(...
        load_mass_sam, ...
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
        ballute_alt_sam, ...
        main_chute_alt_sam, ...
        ballute_drag_coeff_sam, ...
        main_chute_drag_coeff_sam, ...
        ballute_dia, ...
        main_chute_dia, ...
        chute_attachment_pos, ...
        launch_angle_sam, ...
        launch_alt, ...
        thrust_uncertainty, ...
        CG_uncertainty, ...
        CP_uncertainty, ...
        CD_uncertainty);

    [time, state] = trajectory(vehicle);
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