function samples = rocket_samples(...
    fields_file,...
    error_file,...
    num_of_samples)
%ROCKET_SAMPLES Creates an array of vehicle structs
%   The struct fields are created via Latin Hypercube sampling
%
%   Input:
%       fields_file: path to file containing the nominal values
%       errors_file: path to file containing the variable errors to sample
%       num_of_samples: number to samples to take.
%   Ouput:
%       samples: Array of vehicle structs of length num_of_samples each 
%           representing a single sample out of the total `num_of_samples`. 
%           See `rocket_nominal` function to see all fields that vehicle 
%           struct contains.
%   
    nominal_vehicle = rocket_nominal(fields_file);
    errors = parse_error(error_file);
    
    %% Take samples
    % Variables that will be sampled:
    %   load_mass
    %   thrust
    %	CG
    %	CP
    %	CD_vehicle
    %   thrust_misalign_angle
    %	CD_ballute
    %	CD_chute
    %	ballute_alt
    %	chute_alt
    %	launch_angle
    % All from a normal distribution.
    
    means = [
        nominal_vehicle.load_mass; 
        0;
        0;
        0;
        0;
        nominal_vehicle.thrust_misalign_angle;
        nominal_vehicle.main_chute_drag_coeff;
        nominal_vehicle.ballute_drag_coeff;
        nominal_vehicle.main_chute_alt;
        nominal_vehicle.ballute_alt;
        nominal_vehicle.launch_angle]';
    
    deviations = [
        errors.load_mass_sd;
        1/3;
        1/3;
        1/3;
        1/3;
        errors.thrust_misalign_angle_sd;
        errors.CD_chute_sd;
        errors.CD_ballute_sd;
        errors.chute_alt_sd;
        errors.ballute_alt_sd;
        errors.launch_angle_sd]';
    
    [~, nvar] = size(means);
    
    uncertainties = sampling.latin_hs_norm(...
        means,...
        deviations,...
        num_of_samples,...
        nvar);
    
    for sam_num = num_of_samples:-1:1
        % Parse sample results
        load_mass_sam = uncertainties(sam_num,1);
        thrust_uncertainty = sampling.create_uncertainty(...
            errors.thrust_variation,...
            uncertainties(sam_num, 2));
        CG_uncertainty = sampling.create_uncertainty(...
            errors.CG_variation,...
            uncertainties(sam_num, 3));
        CP_uncertainty = sampling.create_uncertainty(...
            errors.CP_variation,...
            uncertainties(sam_num, 4));
        CD_uncertainty = sampling.create_uncertainty(...
            errors.CD_vehicle_variation,...
            uncertainties(sam_num, 5));
        thrust_misalign_angle_sam = uncertainties(sam_num,6);
        main_chute_drag_coeff_sam = uncertainties(sam_num,7);
        ballute_drag_coeff_sam = uncertainties(sam_num,8);
        main_chute_alt_sam = uncertainties(sam_num,9);
        ballute_alt_sam = uncertainties(sam_num,10);
        launch_angle_sam = uncertainties(sam_num,11);
        
        new_vehicle = cell2struct(...
            struct2cell(nominal_vehicle),...
            fieldnames(nominal_vehicle));
        
        new_vehicle.load_mass = load_mass_sam;
        new_vehicle.thrust_misalign_angle = thrust_misalign_angle_sam;
        new_vehicle.main_chute_drag_coeff = main_chute_drag_coeff_sam;
        new_vehicle.ballute_drag_coeff = ballute_drag_coeff_sam;
        new_vehicle.main_chute_alt = main_chute_alt_sam;
        new_vehicle.ballute_alt = ballute_alt_sam;
        new_vehicle.launch_angle = launch_angle_sam;
        new_vehicle.thrust_uncertainty = thrust_uncertainty;
        new_vehicle.CG_uncertainty = CG_uncertainty;
        new_vehicle.CP_uncertainty = CP_uncertainty;
        new_vehicle.CD_uncertainty = CD_uncertainty;
        samples(sam_num) = new_vehicle;
    end
end

