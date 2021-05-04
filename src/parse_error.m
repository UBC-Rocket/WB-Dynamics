function errors = parse_error(path_to_file)
%UNTITLED Validates then parses values regarding uncertainties from file
%into a struct.
    result = readtable(path_to_file);

    expected_variable_names = [
        {'load mass standard deviation'}
        {'thrust scaling factor'}
        {'CG scaling factor'}
        {'CP scaling factor'}
        {'CD vehicle scaling factor'}
        {'thrust misalignment standard deviation'}
        {'ballute CD standard deviation'}
        {'main chute CD standard deviation'}
        {'ballute opening altitude standard deviation'}
        {'main chute opening altitude standard deviation'}
        {'launch angle standard deviation'}];
    
    parsed_variable_names = [
        "load_mass_sd"
        "thrust_variation"
        "CG_variation"
        "CP_variation"
        "CD_vehicle_variation"
        "thrust_misalign_angle_sd"
        "CD_ballute_sd"
        "CD_chute_sd"
        "ballute_alt_sd"
        "chute_alt_sd"
        "launch_angle_sd"];
    
    for i = 1:length(expected_variable_names)
        rows = strcmp(result.Variable, expected_variable_names(i));
        if any(rows)
            % A generic check to see if all values are greater than zero.
            parsed_value = result.Value(rows);
            if parsed_value < 0
                ME = MException(...
                    'errors_input:bad_input',...
                    'Error, %s should not be less than zero, given: &s',...
                    string(expected_variable_names(i)),...
                    parsed_value);
                throw(ME);
            end
            errors.(parsed_variable_names(i)) = result.Value(rows);
        else
            ME = MException(...
                'errors_input:bad_input',...
                '%s does not contain the row %s',...
                path_to_file,...
                string(expected_variable_names(i)));
            throw(ME);
        end
    end
end

