% Generates a MATLAB struct that contains all the static
% properties of a rocket. There isn't any fine control on
% what happens to each field which suggests that perhaps
% an object oriented approach would perhaps be better in
% the future. At the moment we are all "consenting programmers"
% and we know what we are doing.
function vehicle = create_rocket(...
    load_mass, ...
    fuselage_dia, ...
    fuselage_length, ...
    nose_length, ...
    burn_time, ...
    prop_flow_rate, ...
    nozzle_eff, ...
    c_star, ...
    exit_pressure, ...
    chamber_pressure, ...
    exp_area_ratio, ...
    nozzle_exit_area, ...
    ballute_alt, ...
    main_chute_alt, ...
    ballute_drag_coeff, ...
    main_chute_drag_coeff, ...
    ballute_dia, ...
    main_chute_dia, ...
    launch_angle, ...
    launch_alt)

    % There might be a better way that can do this assignment

    %% Physical properties
    vehicle.load_mass = load_mass;
    vehicle.fuselage_diameter = fuselage_dia;
    vehicle.fuselage_length = fuselage_length;
    vehicle.nose_length = nose_length;
    vehicle.fin_root_chord = 0.6096;
    vehicle.fin_tip_chord = 0.381;
    vehicle.fin_mid_chord = 0.381;
    vehicle.fin_span = 0.3048;
    vehicle.fin_thickness = 0.01;
    vehicle.num_of_fins = 4;


    %% Engine properties
    vehicle.burn_time = burn_time;
    vehicle.prop_flow_rate = prop_flow_rate;
    vehicle.nozzle_eff = nozzle_eff;
    vehicle.c_star = c_star;
    vehicle.exit_pressure = exit_pressure;
    vehicle.chamber_pressure = chamber_pressure;
    vehicle.exp_area_ratio = exp_area_ratio;
    vehicle.nozzle_exit_area = nozzle_exit_area;

    %% Recovery properties
    vehicle.ballute_alt = ballute_alt;
    vehicle.main_chute_alt = main_chute_alt;
    vehicle.ballute_drag_coeff = ballute_drag_coeff;
    vehicle.main_chute_drag_coeff = main_chute_drag_coeff;
    vehicle.ballute_dia = ballute_dia;
    vehicle.main_chute_dia = main_chute_dia;
    vehicle.num_of_ballutes = 3;
    vehicle.num_of_chutes = 3;

    %% Launch properties
    vehicle.launch_angle = launch_angle;
    vehicle.launch_alt = launch_alt;
    vehicle.rail_length = 15;
    vehicle.rail_fric_coeff = 0;
end