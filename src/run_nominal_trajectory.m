% Runs the trajectory simulation once in a non stochastic manner using the
% average values of each parameter.
clc;
clear;
%close all;
format short g;

INPUT_PATH = "../input";
INPUT_FILE = fullfile(INPUT_PATH, "fields_input.csv");
vehicle = rocket_nominal(INPUT_FILE);

SIM_END_TIME = 600;
STEP_SIZE = 0.1;

%% Run simulation
[time, state] = trajectory(vehicle, SIM_END_TIME, STEP_SIZE);

%% Plot animation
animation.animate(time, state, vehicle);
% plotter.scaling_factor = 3000;
% plotter.num_time_steps = length(time);
% 
% init_orientation = state(1, 4:7);
% fuselage_vec_init = plotter.scaling_factor*[vehicle.fuselage_length; 0; 0];
% % If number of fins change, this code has to be manually changed.
% % Would be nice if the fin orientation can be computed based on fin number
% % instead of a hard code.
% fin(1).vec_init = plotter.scaling_factor*[0; -vehicle.fuselage_length/3; 0];
% fin(2).vec_init = plotter.scaling_factor*[0; 0; vehicle.fuselage_length/3];
% fin(3).vec_init = plotter.scaling_factor*[0; vehicle.fuselage_length/3; 0];
% fin(4).vec_init = plotter.scaling_factor*[0; 0; -vehicle.fuselage_length/3];
% 
% % Apogee
% [apogee, apogee_time] = util.find_apogee(time, state(:,3));
% 
% for time_step_num = 1:plotter.num_time_steps
%     curr_orientation = state(time_step_num, 4:7);
%     fuselage_vec = coordinate.to_inertial_frame(curr_orientation, fuselage_vec_init);
%     % Plot line representing fuselage
%     plot3(...
%         [state(time_step_num,1), state(time_step_num,1) + fuselage_vec(1)]',...
%         [state(time_step_num,2), state(time_step_num,2) + fuselage_vec(2)]',...
%         [state(time_step_num,3), state(time_step_num,3) + fuselage_vec(3)]',...
%         'k',...
%         'LineWidth',...
%         1.5);
%     hold on;
%     % Plot lines representing fins
%     for fin_num = 4:-1:1
%         fin(fin_num).vec = coordinate.to_inertial_frame(curr_orientation, fin(fin_num).vec_init);
%         plot3(...
%             [state(time_step_num,1), state(time_step_num,1) + fin(fin_num).vec(1)]',...
%             [state(time_step_num,2), state(time_step_num,2) + fin(fin_num).vec(2)]',...
%             [state(time_step_num,3), state(time_step_num,3) + fin(fin_num).vec(3)]',...
%             'k',...
%             'LineWidth',...
%             1.5);
%     end
%     axis([-75000 75000 -75000 75000 0 150000]);
%     daspect([1 1 1]);
%     grid on;
%     hold off;
%     sim_time = time(time_step_num);
%     altitude = state(time_step_num,3);
%     apogee_msg = '';
%     if sim_time >= apogee_time
%         apogee_msg = ['Apogee: ', num2str(apogee), ' m'];
%     end
%     msg = ['Time: ', num2str(sim_time), ' s  Altitude: ', num2str(altitude), ' m  ',  apogee_msg];
%     
%     text(-150000, 75000, 250000, msg);
%     %   pause;
%     pause(0.0001)
%     % End if touched ground
%     if (state(time_step_num,3) < vehicle.launch_alt) && (state(time_step_num,10) < 0)
%         break
%     end
% end