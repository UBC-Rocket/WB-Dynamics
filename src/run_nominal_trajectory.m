% Runs the trajectory simulation once in a non stochastic manner using the
% average values of each parameter.
clc;
clear;
%close all;
format short g;

INPUT_PATH = "../input";
INPUT_FILE = fullfile(INPUT_PATH, "input.csv");
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
thrust_misalign_angle = parameters.thrust_misalign_angle;

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

%% Complex variable uncertainties
% Since this is meant to be non stochastic the `var` is set to zero
thrust_uncertainty = sampling.create_uncertainty(0,0);
CG_uncertainty = sampling.create_uncertainty(0,0);
CP_uncertainty = sampling.create_uncertainty(0,0);
CD_uncertainty = sampling.create_uncertainty(0,0);

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
    thrust_misalign_angle, ...
    ballute_alt, ...
    main_chute_alt, ...
    ballute_drag_coeff, ...
    main_chute_drag_coeff, ...
    ballute_dia, ...
    main_chute_dia, ...
    number_of_ballutes, ...
    number_of_chutes, ...
    chute_attachment_pos, ...
    launch_angle, ...
    launch_alt, ...
    thrust_uncertainty, ...
    CG_uncertainty, ...
    CP_uncertainty, ...
    CD_uncertainty);
%disp(vehicle);
%% Run simulation
[time, state] = trajectory(vehicle);

%% Plot animation
plotter.scaling_factor = 3000;
plotter.num_time_steps = length(time);

init_orientation = state(1, 4:7);
fuselage_vec_init = plotter.scaling_factor*[fuselage_length; 0; 0];
% If number of fins change, this code has to be manually changed.
% Would be nice if the fin orientation can be computed based on fin number
% instead of a hard code.
fin(1).vec_init = plotter.scaling_factor*[0; -fuselage_length/3; 0];
fin(2).vec_init = plotter.scaling_factor*[0; 0; fuselage_length/3];
fin(3).vec_init = plotter.scaling_factor*[0; fuselage_length/3; 0];
fin(4).vec_init = plotter.scaling_factor*[0; 0; -fuselage_length/3];

% Apogee
[apogee, apogee_time] = find_apogee(time, state(:,3));

for time_step_num = 1:plotter.num_time_steps
    curr_orientation = state(time_step_num, 4:7);
    fuselage_vec = coordinate.to_inertial_frame(curr_orientation, fuselage_vec_init);
    % Plot line representing fuselage
    plot3(...
        [state(time_step_num,1), state(time_step_num,1) + fuselage_vec(1)]',...
        [state(time_step_num,2), state(time_step_num,2) + fuselage_vec(2)]',...
        [state(time_step_num,3), state(time_step_num,3) + fuselage_vec(3)]',...
        'k',...
        'LineWidth',...
        1.5);
    hold on;
    % Plot lines representing fins
    for fin_num = 4:-1:1
        fin(fin_num).vec = coordinate.to_inertial_frame(curr_orientation, fin(fin_num).vec_init);
        plot3(...
            [state(time_step_num,1), state(time_step_num,1) + fin(fin_num).vec(1)]',...
            [state(time_step_num,2), state(time_step_num,2) + fin(fin_num).vec(2)]',...
            [state(time_step_num,3), state(time_step_num,3) + fin(fin_num).vec(3)]',...
            'k',...
            'LineWidth',...
            1.5);
    end
    axis([-75000 75000 -75000 75000 0 150000]);
    daspect([1 1 1]);
    grid on;
    hold off;
    sim_time = time(time_step_num);
    altitude = state(time_step_num,3);
    apogee_msg = '';
    if sim_time >= apogee_time
        apogee_msg = ['Apogee: ', num2str(apogee), ' m'];
    end
    msg = ['Time: ', num2str(sim_time), ' s  Altitude: ', num2str(altitude), ' m  ',  apogee_msg];
    
    text(-150000, 75000, 250000, msg);
    %   pause;
    pause(0.0001)
    % End if touched ground
    if (state(time_step_num,3) < launch_alt) && (state(time_step_num,10) < 0)
        break
    end
end