function vehicle = rocket_nominal(input_file)
% Generates a MATLAB struct that contains all the static
% properties of a rocket from a file. 
%   There isn't any fine control on
%   what happens to each field which suggests that perhaps
%   an object oriented approach would perhaps be better in
%   the future. At the moment we are all "consenting programmers"
%   and we know what we are doing.
%
%   Additional note: There might be a better way that can do this assignment
%   Units:
%       Physical properties:
%           load_mass: total mass of vehicle in kg at launch
%           fuselage_diameter: total diameter of the vehicle in meters.
%               Assumes the vehicle has a constant diameter thoughout.
%           fuselage_length: total length of the vehicle in meters
%               including nose cone.
%           nose_length: length of the nose cone in meters
%       Fin properties:
%           num_of_fins: Total number of fins on vehicle.
%           fin_span: Fin span of a single fin in meters.
%           fin_thickness: Thickness of a single fin in meters.
%           fin_leading_edge_sweep_angle: The angle that the front of the
%               fins makes with the perpendicular component relative to the
%               fuselage in degrees.
%           fin_leading_edge_thickness_angle: The angle that the front of
%               the fin makes relative to the rest of the plane that forms
%               the fin in degrees.
%       Engine properties
%           burn_time: Total burn time of the engine in seconds.
%           prop_flow_rate: Propellant flow rate in kg per second.
%           nozzle_eff: Efficiency of nozzle as a scaling factor.
%           c_star: C Star of engine in meters/second.
%           exit_pressure: Exit pressure of gases in Pascals.
%           chamber_pressure: Chamber pressure of gases in Pascals.
%           nozzle_exit_area: Area of nozzle in meters^2.
%           thrust_misalign_angle: Angle in degrees that engine is offset 
%               from the plane formed by the roll and pitch axis.
%       Recovery properties
%           ballute_alt: Altitude in meters that ballute opens above sea
%               level.
%           main_chute_alt: Altitude in meters that main chute opens above
%               sea level
%           ballute_drag_coeff: Drag coefficient of a single ballute.
%           main_chute_drag_coeff: Drag coefficient of a single main chute.
%           ballute_dia: Diameter of single ballute in meters.
%           main_chute_dia: Diameter of single main chute in meters.
%           num_of_ballutes: Number of ballutes.
%           num_of_chutes: Number of main chutes.  
%           chute_attachment_pos: Position relative to the bottom
%               of the rocket in meter where the recovery device(s) is
%               attached.
%       Launch properties
%           launch_angle: Angle vehicle is launched at relative to ground
%               in degrees.
%           launch_alt: Altitude that vehicle is launched in meters above
%               sea level.
%           rail_length: Length of launch rail in meters.
%           rail_fric_coeff: Coefficient of friction of launch rail.
%       Uncertainties:
%           Since variables such as thrust, center of gravity, center of
%           pressure and vehicle coefficent of drag is complex in nature so
%           instead of varying each dependent variable (which makes it
%           computationally expensive) we scale the final result by a
%           factor that is determined by sampling.
%
%           thrust_uncertainty: struct with the fields `var` and `rand`
%               where `var` is the percentage error of the total thrust
%               and `rand` is a random number sampled from a distribution
%               with a lower bound of -1 and an upper bound of 1.
%           CG_uncertainty: struct with the fields `var` and `rand`
%               where `var` is the percentage error of the CG
%               and `rand` is a random number sampled from a distribution
%               with a lower bound of -1 and an upper bound of 1.
%           CP_uncertainty: struct with the fields `var` and `rand`
%               where `var` is the percentage error of the CP
%               and `rand` is a random number sampled from a distribution
%               with a lower bound of -1 and an upper bound of 1.
%           CD_uncertainty: struct with the fields `var` and `rand`
%               where `var` is the percentage error of the total vehicle CD
%               and `rand` is a random number sampled from a distribution
%               with a lower bound of -1 and an upper bound of 1.
%       Since this is using nominal values, the uncertainties are set to
%       zero.

    % The majority of the properties are already stored in this struct. The
    % next few lines aims to add a couple extra that are not explictly
    % specified by the input file.
    vehicle = util.parse_input(input_file);
    
    vehicle.roll_axis_body = [1;0;0];
    % vehicle.thrust_dir_body = [
    %     cosd(vehicle.thrust_misalign_angle);
    %     0;
    %     sind(vehicle.thrust_misalign_angle)];
    
    %% Recovery property
    vehicle.chute_attachment_rel_base = [vehicle.chute_attachment_pos;0;0];
    
    %% Launch properties
    % set static for now until better model is developed
    vehicle.rail_length = 15;
    vehicle.rail_fric_coeff = 0;
    
    %% Memonize repetitive calculations for CD
    vehicle.S_r = pi*(vehicle.fuselage_diameter/2)^2; % Reference diameter
    vehicle.body_length = vehicle.fuselage_length - vehicle.nose_length;
    vehicle.AR_B = vehicle.body_length/vehicle.fuselage_diameter; % Aspect raito body
    vehicle.AR_N = vehicle.nose_length/vehicle.fuselage_diameter; % Aspect ratio nose
    vehicle.A_le = deg2rad(vehicle.fin_leading_edge_sweep_angle); % Fin leading edge sweep angle
    vehicle.S_le = deg2rad(vehicle.fin_leading_edge_thickness_angle); % Fin leading edge thickness angle
    
    %% Complex uncertainties.
    % Set to zero because this is non-stochastic
    vehicle.thrust_uncertainty = sampling.create_uncertainty(0,0);
    vehicle.CG_uncertainty = sampling.create_uncertainty(0,0);
    vehicle.CP_uncertainty = sampling.create_uncertainty(0,0);
    vehicle.CD_uncertainty = sampling.create_uncertainty(0,0);
end

