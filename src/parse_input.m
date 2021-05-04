function parameters = parse_input(path_to_file)
%PARSE_INPUT Validates then parses values regarding vehicle parameters 
%from file into a struct.
    result = readtable(path_to_file);

    expected_variable_names = [
        {'load mass'}
        {'fuselage diameter'}
        {'fuselage length'}
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
        {'main chute drag coefficient'}
        {'ballute diameter'}
        {'main chute diameter'}
        {'number of ballutes'}
        {'number of chutes'}
        {'chute attachment position relative to base'}
        {'launch angle'}
        {'launch altitude above sea level'}
        % top 1/3 of rocket mass values
        {'nose cone mass'}
        {'payload adapter mass'}
        {'payload mass'}
        {'nose cone int hull mass'}
        {'avionics rec section hull mass'}
        {'avionics mass'}
        {'recovery system mass'}
        {'recovery chute mass'}
        {'pressurant tank mass'}
        {'pressurant gas mass'}
        {'pressurant mount mass'}
        {'pressurant LOX interface hull mass'}
        {'pressurant RCS mass'}
        % LOX & Kero Tank values
        {'LOX tank mass'}
        {'LOX mass'}
        {'LOX kero interface hull mass'}
        {'kero tank mass'}
        {'kero mass'}
        {'kero engine interface hull mass'}
        {'mass engine'}
        % top third of rocket lengths
        {'nose cone length'}
        {'payload length'}
        {'recovery system length'}
        % Tank Info
        {'pressurant tank length'}
        {'pressurant LOX int hull length'}
        {'LOX tank length'}
        {'LOX kero int hull length'}
        {'kero tank length'}
        {'kero eng int hull length'} 
        {'engine length'}
        {'mass flow LOX'}
        {'mass flow kero'}];
    parsed_variable_names = [
        "load_mass"
        "fuselage_diameter"
        "fuselage_length"
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
        "num_of_ballutes"
        "num_of_chutes"
        "chute_attachment_pos"
        "launch_angle"
        "launch_alt"
        "nose_cone_mass"
        "payload_adapter_mass"
        "payload_mass"
        "nose_cone_int_hull_mass"
        "avi_rec_section_hull_mass"
        "avi_mass"
        "rec_sys_mass"
        "rec_chute_mass"
        "pressurant_tank_mass"
        "pressurant_gas_mass"
        "pressurant_mount_mass"
        "pressureant_LOX_int_hull_mass"
        "pressurant_RCS_mass"
        "LOX_tank_mass"
        "LOX_mass"
        "LOX_kero_int_hull_mass"
        "kero_tank_mass"
        "kero_mass"
        "kero_engine_int_hull_mass"
        "mass_engine"
        "nose_length"
        "payload_length"
        "rec_sys_length"
        "pressurant_tank_length"
        "pressurant_LOX_int_hull_length"
        "LOX_tank_length"
        "LOX_kero_int_hull_length"
        "kero_tank_length"
        "kero_eng_int_hull_length"
        "engine_length"
        "mass_flow_LOX"
        "mass_flow_kero"];

    % Validate and parse values
    for i = 1:length(expected_variable_names)
        rows = strcmp(result.Variable, expected_variable_names(i));
        if any(rows)
            % A generic check to see if all values are greater than zero.
            % Field specific checks are below and are somewhat of a hard
            % code for now.
            parsed_value = result.Value(rows);
            if parsed_value < 0
                ME = MException(...
                    'fields_input:bad_input',...
                    'Error, %s should not be less than zero, given: &s',...
                    string(expected_variable_names(i)),...
                    parsed_value);
                throw(ME);
            end
            parameters.(parsed_variable_names(i)) = result.Value(rows);
        else
            ME = MException(...
                'fields_input:bad_input',...
                'Error, %s does not contain the row %s',...
                path_to_file,...
                string(expected_variable_names(i))); 
            throw(ME);
        end
    end
    % At this point we already know all values are at least zero or greater.
    % Check if input values makes "sense"
    % Somewhat of a hard code for now....
    if parameters.load_mass == 0
        ME = MException(...
            'fields_input:bad_input',...
            'Error, load mass must be greater than zero, value given: %s',...
            parameters.load_mass);
        throw(ME);
    end
    if parameters.fuselage_diameter == 0
        ME = MException(...
            'fields_input:bad_input',...
            'Error, fuselage diameter must be greater than zero, value given: %s',...
            parameters.fuselage_dia);
        throw(ME);
    end
    if parameters.fuselage_length == 0
        ME = MException(...
            'fields_input:bad_input',...
            'Error, fuselage length must be greater than zero, value given: %s',...
            parameters.fuselage_length);
        throw(ME);
    end
    if parameters.nose_length == 0
        ME = MException(...
            'fields_input:bad_input',...
            'Error, nose cone length must be greater than zero, value given: %s',...
            parameters.nose_length);
        throw(ME);
    end
    if parameters.nose_length > parameters.fuselage_length
        ME = MException(...
            'fields_input:bad_input',...
            'Error, nose cone length cannot be longer than entire vehicle');
        throw(ME);
    end
    if floor(parameters.num_of_fins) ~= ceil(parameters.num_of_fins)
        ME = MException(...
            'fields_input:bad_input',...
            'Error, number of fins must be a whole number, given: %s',...
            parameters.num_of_fins);
        throw(ME);
    end
    if parameters.burn_time == 0
        ME = MException(...
            'fields_input:bad_input',...
            'Error, burn time must be greater than zero, given: %s',...
            parameters.burn_time);
        throw(ME);
    end
    if parameters.prop_flow_rate == 0
        ME = MException(...
            'fields_input:bad_input',...
            'Error, propellant flow rate must be greater than zero, given: %s',...
            parameters.prop_flow_rate);
        throw(ME);
    end
    if (parameters.nozzle_eff == 0) || (parameters.nozzle_eff > 1)
        ME = MException(...
            'fields_input:bad_input',...
            'Error, nozzle efficiency must be between 0 and 1, given: %s',...
            parameters.nozzle_eff);
        throw(ME);
    end
    if parameters.exp_area_ratio == 0
        ME = MException(...
            'fields_input:bad_input',...
            'Error, expansion area ratio must be greater than zero, given: %s',...
            parameters.exp_area_ratio);
        throw(ME);
    end
    if parameters.nozzle_exit_area == 0
        ME = MException(...
            'fields_input:bad_input',...
            'Error, nozzle exit area must be greater than zero, given: %s',...
            parameters.nozzle_exit_area);
        throw(ME);
    end
    if floor(parameters.num_of_ballutes) ~= ceil(parameters.num_of_ballutes)
        ME = MException(...
            'fields_input:bad_input',...
            'Error, number of ballutes must be a whole number, given: %s',...
            parameters.num_of_ballutes);
        throw(ME);
    end
    if floor(parameters.num_of_chutes) ~= ceil(parameters.num_of_chutes)
        ME = MException(...
            'fields_input:bad_input',...
            'Error, number of chutes must be a whole number, given: %s',...
            parameters.num_of_chutes);
        throw(ME);
    end
end
