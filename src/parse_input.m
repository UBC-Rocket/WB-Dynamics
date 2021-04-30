function parameters = parse_input(path_to_file)
%PARSE_INPUT Validates then parses values from file into a struct.
%   Detailed explanation goes here
    result = readtable(path_to_file);

    expected_variable_names = [
        {'load mass'}
        {'fuselage diameter'}
        {'fuselage length'}
        {'nose cone length'}
        {'number of fins'}
        {'fin span'}
        {'fin thickness'}
        {'fin leading edge sweep angle'}
        {'fin leading edge thickness angle'}
        {'burn time'}
        {'propellant flow rate'}
        {'nozzle efficiency'}
        {'c star'}
        {'exit pressure'}
        {'chamber pressure'}
        {'expansion area ratio'}
        {'nozzle exit area'}
        {'thrust misalignment angle'}
        {'ballute opening altitude'}
        {'main chute opening altitude'}
        {'ballute drag coefficient'}
        {'main chute opening coefficient'}
        {'ballute diameter'}
        {'main chute diameter'}
        {'number of ballutes'}
        {'number of chutes'}
        {'chute attachment position relative to base'}
        {'launch angle'}
        {'launch altitude above sea level'}];
    parsed_variable_names = [
        "load_mass"
        "fuselage_dia"
        "fuselage_length"
        "nose_length"
        "num_of_fins"
        "fin_span"
        "fin_thickness"
        "fin_leading_edge_sweep_angle"
        "fin_leading_edge_thickness_angle"
        "burn_time"
        "prop_flow_rate"
        "nozzle_eff"
        "c_star"
        "exit_pressure"
        "chamber_pressure"
        "exp_area_ratio"
        "nozzle_exit_area"
        "thrust_misalign_angle"
        "ballute_alt"
        "main_chute_alt"
        "ballute_drag_coeff"
        "main_chute_drag_coeff"
        "ballute_dia"
        "main_chute_dia"
        "number_of_ballutes"
        "number_of_chutes"
        "chute_attachment_pos"
        "launch_angle"
        "launch_alt"
    ];

    % Validate and parse values
    for i = 1:length(expected_variable_names)
        rows = strcmp(result.Variable, expected_variable_names(i));
        if any(rows)
            parameters.(parsed_variable_names(i)) = result.Value(rows);
        else
            error(...
                'Error, \n%s does not contain the row %s',...
                path_to_file,...
                string(expected_variable_names(i))); 
        end
    end
    % Check if input values makes "sense"
    % Somewhat of a hard code for now....
    if parameters.load_mass <= 0
        error(...
        'Error, \n load mass must be greater than zero, value given: %s',...
        parameters.load_mass);
    end
    if parameters.fuselage_dia <= 0
        error(...
        'Error, \n fuselage diameter must be greater than zero, value given: %s',...
        parameters.fuselage_dia);
    end
    if parameters.fuselage_length <= 0
        error(...
        'Error, \n fuselage length must be greater than zero, value given: %s',...
        parameters.fuselage_length);
    end
    if parameters.nose_length <= 0
        error(...
        'Error, \n nose cone length must be greater than zero, value given: %s',...
        parameters.nose_length);
    end
    if parameters.nose_length > parameters.fuselage_length
        error('Error, \n nose cone length cannot be longer than entire vehicle');
    end
    if parameters.num_of_fins < 0
        error(...
            'Error, \n number of fins must be 0 or greater, given: %s',...
            parameters.num_of_fins);
    end
    if floor(parameters.num_of_fins) ~= ceil(parameters.num_of_fins)
        error(...
            'Error, \n number of fins must be a whole number, given: %s',...
            parameters.num_of_fins);
    end
    if parameters.fin_span <= 0
        error(...
            'Error, \n fin span must be greater than zero, given: %s',...
            parameters.fin_span);
    end
    if parameters.fin_thickness <= 0
        error(...
            'Error, \n fin thickness must be greater than zero, given: %s',...
            parameters.fin_thickness);
    end
    if parameters.burn_time <= 0
        error(...
            'Error, \n burn time must be greater than zero, given: %s',...
            parameters.burn_time);
    end
    if parameters.prop_flow_rate <= 0
        error(...
            'Error, \n propellant flow rate must be greater than zero, given: %s',...
            parameters.prop_flow_rate);
    end
    if (parameters.nozzle_eff <= 0) || (parameters.nozzle_eff > 1)
        error(...
            'Error, \n nozzle efficiency must be between 0 and 1, given: %s',...
            parameters.nozzle_eff);
    end
    if parameters.exp_area_ratio <= 0
        error(...
            'Error, \n expansion area ratio must be greater than zero, given: %s',...
            parameters.exp_area_ratio);
    end
    if parameters.nozzle_exit_area <= 0
        error(...
            'Error, \n nozzle exit area must be greater than zero, given: %s',...
            parameters.nozzle_exit_area);
    end
    if parameters.ballute_drag_coeff < 0
        error(...
            'Error, \n ballute drag coefficient must be greater than or equal to zero, given: %s',...
            parameters.ballute_drag_coeff);
    end
    if parameters.main_chute_drag_coeff < 0
        error(...
            'Error, \n main chute drag coefficient must be greater than or equal to zero, givenL %s',...
            parameters.main_chute_drag_coeff);
    end
    if parameters.ballute_dia < 0
        error(...
            'Error, \n ballute diameter must be greater than or equal to zero, givenL %s',...
            parameters.ballute_dia);
    end
    if parameters.main_chute_dia < 0
        error(...
            'Error, \n main chute diameter must be greater than or equal to zero, givenL %s',...
            parameters.main_chute_dia);
    end
    if parameters.number_of_ballutes < 0
        error(...
            'Error, \n number of ballutes must be greater than or equal to zero, givenL %s',...
            parameters.number_of_ballutes);
    end
    if floor(parameters.number_of_ballutes) ~= ceil(parameters.number_of_ballutes)
        error(...
            'Error, \n number of ballutes must be a whole number, given: %s',...
            parameters.number_of_ballutes);
    end
    if parameters.number_of_chutes < 0
        error(...
            'Error, \n number of main chutes must be greater than or equal to zero, given: %s',...
            parameters.number_of_chutes);
    end
    if floor(parameters.number_of_chutes) ~= ceil(parameters.number_of_chutes)
        error(...
            'Error, \n number of chutes must be a whole number, given: %s',...
            parameters.number_of_chutes);
    end
    if parameters.chute_attachment_pos < 0
        error(...
            'Error, \n chute attachment position relative to base must be zero or greater, given: %s',...
            parameters.chute_attachment_pos);
    end
end

