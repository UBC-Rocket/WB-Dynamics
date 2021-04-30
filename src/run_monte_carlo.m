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
INPUT_FILE = fullfile(INPUT_PATH, "input.csv");
NUM_OF_SAMPLES = 100;
parameters = parse_input(INPUT_FILE);

%% Physical properties
load_mass = parameters.load_mass;
fuselage_dia = parameters.fuselage_dia;
fuselage_length = parameters.fuselage_length;
nose_length = parameters.nose_length;

%% Fin properties
num_of_fins = parameters.num_of_fins;
fin_span = parameters.fin_span;
fin_thickness = parameters.fin_thickness;
fin_leading_edge_sweep_angle = parameters.fin_leading_edge_sweep_angle;
fin_leading_edge_thickness_angle = parameters.fin_leading_edge_thickness_angle;

%% Engine properties
burn_time = parameters.burn_time;
prop_flow_rate = parameters.prop_flow_rate;
nozzle_eff = parameters.nozzle_eff;
c_star = parameters.c_star;
exit_pressure = parameters.exit_pressure;
chamber_pressure = parameters.chamber_pressure;
exp_area_ratio = parameters.exp_area_ratio;
nozzle_exit_area = parameters.nozzle_exit_area;

%% Recovery properties
ballute_alt = parameters.ballute_alt;
main_chute_alt = parameters.main_chute_alt;
ballute_drag_coeff = parameters.ballute_drag_coeff;
main_chute_drag_coeff = parameters.main_chute_drag_coeff;
ballute_dia = parameters.ballute_dia;
main_chute_dia = parameters.main_chute_dia;
chute_attachment_pos = parameters.chute_attachment_pos;
number_of_ballutes = parameters.number_of_ballutes;
number_of_chutes = parameters.number_of_chutes;

%% Launch properties
launch_angle = parameters.launch_angle;
launch_alt = parameters.launch_alt;

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
points = zeros(NUM_OF_SAMPLES, 6);

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
        number_of_ballutes, ...
        number_of_chutes, ...
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