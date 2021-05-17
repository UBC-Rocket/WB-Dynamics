function errors = parse_error(path_to_file)
%UNTITLED Validates then parses values regarding uncertainties from file
%   Will throw MException if failed to parse values or failed validation.
%
%   Input:
%       path_to_file: path of file containing uncertanties to use
%   Ouput:
%       errors: struct containing the fields:
%           - load_mass_sd : standard deviation of the load mass as an
%                            absolute uncertainty
%           - thrust_variation : percentage variation of the thrust force.
%                                See `sampling.apply_uncertainty` to see
%                                how this value is used
%           - CG_variation : percentage variation of the CG position
%                            relative to the base of the vehicle. See
%                           `sampling.apply_uncertainty` to see how this 
%                            value would be used
%           - CD_vehicle_variation : percentage variation of the vehicle CD.
%                                    See `sampling.apply_uncertainty` to 
%                                    see how this value would be used
%           - thrust_msialgin_angle_sd : standard deviation of the thrust
%                                        misalignment angle as an absolute 
%                                        uncertainty
%           - CD_ballute_sd: standard deviation of the ballute CD value as
%                            an absolute uncertainty
%           - CD_chute_sd: standard deviation of the main chute CD value as
%                          an absolute uncertainty
%           - ballute_alt_sd: standard deviation of the ballute opening
%                             altitude as an absolute uncertainty
%           - chute_alt_sd: standard deviation of the main chute opening
%                           altitude as an absolute uncertainty
%           - launch_angle_sd: standard deviation of the launch angle as an
%                              absolute uncertainty
%           - wind_speed_variation: percentage variation of the wind velocity magnitude.
%                                   See `sampling.apply_uncertainty` to see how this
%                                   value would be used.
%
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
        {'launch angle standard deviation'}
        {'wind velocity mangitude scaling factor'}
    ];
    
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
        "launch_angle_sd"
        "wind_speed_variation"
    ];
    
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

