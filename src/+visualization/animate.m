function animate(time, state, vehicle)
    % Animation settings
    scaling_factor = 3000;
    num_time_steps = length(time);
    vehicle_color = [176,196,222]/255;
    
    f = figure;
    f.Name = 'Flight Trajectory';
    f.NumberTitle = 'off';
    f.WindowState = 'maximized';
    
    vehicle.fin_root_chord = 0.8128;
    vehicle.fin_tip_chord = 0.34349944;
    
    %% Values for basic animation
    fuselage_vec_init = scaling_factor*[vehicle.fuselage_length; 0; 0];
    fin(1).vec_init = scaling_factor*[0; -vehicle.fuselage_length/3; 0];
    fin(2).vec_init = scaling_factor*[0; 0; vehicle.fuselage_length/3];
    fin(3).vec_init = scaling_factor*[0; vehicle.fuselage_length/3; 0];
    fin(4).vec_init = scaling_factor*[0; 0; -vehicle.fuselage_length/3];
    
    %% Values for "better" animation
    [nose_init, body_init, fin1_init, fin2_init, fin3_init, fin4_init] = ...
        visualization.gen_rocket(vehicle);
    
    % Apogee
    [apogee, apogee_time] = util.find_apogee(time, state(:,3));
        
    for time_step_num = 1:num_time_steps
        curr_orientation = state(time_step_num, 4:7);
        
        %% Plot basic animation
        subplot(1,2,1);
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
            fin(fin_num).vec = ...
                coordinate.to_inertial_frame(...
                curr_orientation,...
                fin(fin_num).vec_init);
            plot3(...
                [state(time_step_num,1), state(time_step_num,1) + fin(fin_num).vec(1)]',...
                [state(time_step_num,2), state(time_step_num,2) + fin(fin_num).vec(2)]',...
                [state(time_step_num,3), state(time_step_num,3) + fin(fin_num).vec(3)]',...
                'k',...
                'LineWidth',...
                1.5);
        end
        % Trace out the flight path
        plot3(...
            state(1:time_step_num,1),...
            state(1:time_step_num,2),...
            state(1:time_step_num,3));
        axis([-75000 75000 -75000 75000 0 150000]);
        daspect([1 1 1]);
        
        % Labels
        xlabel('displacement EAST (m)');
        ylabel('displacement NORTH (m)');
        zlabel('Atitude (m)');
        hold off;
        grid on;
        %% Plot "better" animation
        subplot(1,2,2);

    
        body_curr = lin_alg.rotate_3d_obj(body_init, curr_orientation);
        nose_curr = lin_alg.rotate_3d_obj(nose_init, curr_orientation);
        fin1_curr = lin_alg.rotate_3d_plane(fin1_init, curr_orientation);
        fin2_curr = lin_alg.rotate_3d_plane(fin2_init, curr_orientation);
        fin3_curr = lin_alg.rotate_3d_plane(fin3_init, curr_orientation);
        fin4_curr = lin_alg.rotate_3d_plane(fin4_init, curr_orientation);

        % Draw body
        surf(...
            body_curr(:,:,1) + state(time_step_num,1),...
            body_curr(:,:,2) + state(time_step_num,2),...
            body_curr(:,:,3) + state(time_step_num,3),...
            'facecolor', vehicle_color,...
            'LineStyle', 'none',...
            'EdgeColor', 'w');
        hold on;
        
        % Draw nose cone
        surf(...
            nose_curr(:,:,1) + state(time_step_num,1),...
            nose_curr(:,:,2) + state(time_step_num,2),...
            nose_curr(:,:,3) + state(time_step_num,3),...
            'facecolor', vehicle_color,...
            'LineStyle', 'none',...
            'EdgeColor', 'w');
        % Draw fins
        fill3(...
            fin1_curr(1,:) + state(time_step_num,1),... 
            fin1_curr(2,:) + state(time_step_num,2),...
            fin1_curr(3,:) + state(time_step_num,3),...
            vehicle_color);
        fill3(...
            fin2_curr(1,:) + state(time_step_num,1),... 
            fin2_curr(2,:) + state(time_step_num,2),...
            fin2_curr(3,:) + state(time_step_num,3),...
            vehicle_color);
        fill3(...
            fin3_curr(1,:) + state(time_step_num,1),... 
            fin3_curr(2,:) + state(time_step_num,2),...
            fin3_curr(3,:) + state(time_step_num,3),...
            vehicle_color);
        fill3(...
            fin4_curr(1,:) + state(time_step_num,1),... 
            fin4_curr(2,:) + state(time_step_num,2),...
            fin4_curr(3,:) + state(time_step_num,3),...
            vehicle_color);
        % Labels
        xlabel('displacement EAST (m)');
        ylabel('displacement NORTH (m)');
        zlabel('Atitude (m)');
        
        % Set plot bounds so animation is not cause seizures.
        % Also sets bounds so that the aspect ratio is correct.
        xlim(...
            [-vehicle.fuselage_length/2 vehicle.fuselage_length/2]...
            + state(time_step_num,1));
        ylim(...
            [-vehicle.fuselage_length/2 vehicle.fuselage_length/2]...
            + state(time_step_num,2));
        zlim(...
            [-2 vehicle.fuselage_length + 2]...
            + state(time_step_num,3));
        grid on;
        hold off;
        
        %% Legend
        subplot(1,2,1);
        sim_time = time(time_step_num);
        altitude = state(time_step_num,3);
        apogee_msg = '';
        if sim_time >= apogee_time
            apogee_msg = ['Apogee: ', num2str(apogee), ' m'];
        end
        burn_out_msg = '';
        if sim_time >= vehicle.burn_time
            burn_out_msg = ['Burn out: ', num2str(vehicle.burn_time), ' s'];
        end
        msg = {...
            ['Time: ', num2str(sim_time), ' s'],...
            ['Velocity magnitude: ', num2str(norm(state(time_step_num,8:10))), ' m/s'],...
            ['Altitude: ', num2str(altitude), ' m'],...
            burn_out_msg,...
            apogee_msg};
        text(-150000, 75000, 240000, msg);
        pause(0.0001)
        % End if touched ground
        if (state(time_step_num,3) < vehicle.launch_alt) && (state(time_step_num,10) < 0)
            break
        end
    end
end