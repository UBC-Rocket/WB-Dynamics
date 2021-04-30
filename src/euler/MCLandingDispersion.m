% Monte Carlo Trajectory Simulation Using Latin Hypercube Method
% Considers the distribution of 18 variables

NUM_OF_SAMP             = 50;
NUM_OF_VAR              = 18;

%% Data Output Directories
DATA_PATH = "../output"; % path to folder to hold output data

% file that lists intial conditions for each sample
OUTPUT_GUIDE_DIR = fullfile(DATA_PATH, "number_guide.csv"); 

% file that lists all landing points from all samples
LANDING_PTS_DIR = fullfile(DATA_PATH, "landing_points.csv");

% file that logs all computational errors that occur during simulation. Be
% sure to check, reproduce and investigate the origins of those errors. 
% Samples that have an error will have their number flagged with a 1. The 
% flag 0 means no error.
ERRORS_DIR = fullfile(DATA_PATH, "errors.csv");

% make directory to hold outputs if it does not alredy 
if ~exist(DATA_PATH, 'dir')
       mkdir(DATA_PATH);
end

%% Variables

% Vehicle properties mean
fuse_dia_mean           = 0.3048;       % Normal
fuse_len_mean           = 5.943587967;  % Normal
prop_flow_rate_mean     = 5.625;        % Uniform 
nozzle_eff_mean         = 0.98;         % Uniform
c_star_mean             = 1584.619354;  % Uniform
exit_press_mean         = 77295.59995;  % Normal
chamber_press_mean      = 1000000;      % Normal
burn_time_mean          = 32;           % Normal
mass_mean               = 319.5162962;  % Normal

% Vehicle properties sigma (normal) or half of width (uniform)

fuse_dia_err            = fuse_dia_mean*0.01/3;
fuse_length_err         = fuse_len_mean*0.01/3;
prop_flow_rate_err      = prop_flow_rate_mean*0.01;
nozzle_eff_err          = nozzle_eff_mean*0.01;
c_star_err              = c_star_mean*0.01;
exit_press_err          = exit_press_mean*0.01/3;
chamber_press_err       = chamber_press_mean*0.01/3;
burn_time_err           = 1/3;
mass_err                = mass_mean*0.01/3;


% Aerodynamic properties mean
rocket_drag_data = ReadDragData();      % Load drag data
mach_data = rocket_drag_data(:,1);      % Variable is not varied
drag_coeff_data = rocket_drag_data(:,2);% Normal

% Aerodynamic properties error
drag_coeff_err   = 0.05;

% Environment properties mean
head_wind_mean          = 0;            % Uniform
cross_wind_mean         = 0;            % Uniform

% Enviornment properties error
head_wind_err           = 5;
cross_wind_err          = 5;

% Guidence properties mean; will need to make a better ballute/chute calc
launch_angle_mean       = 80;           % Normal
launch_alt_mean         = 1401;         % Normal
ballute_alt_mean        = 75000;        % Uniform
chute_alt_mean          = 3000;         % Uniform
ballute_drag_coeff_mean = 0.75;         % Uniform
chute_drag_coeff_mean   = 0.53;         % Uniform

% Guidence properties error
launch_angle_err        = 1;
launch_alt_err          = 1;
ballute_alt_err         = 100;
chute_alt_err           = 100;
ballute_drag_coeff_err  = ballute_drag_coeff_mean*0.2;
chute_drag_coeff_err    = chute_drag_coeff_mean*0.2;


%% Sampling
% Note that these are column vectors

% fuse diameter sample - from a normal distribution
fuse_dia_sam = lhsnorm(fuse_dia_mean, fuse_dia_err, NUM_OF_SAMP);

% fuse length sample - from a normal distribution
fuse_len_sam = lhsnorm(fuse_len_mean, fuse_length_err, NUM_OF_SAMP);

% propellant flow rate sample - from an uniform distribution
prop_flow_rate_sam = lhsdesign(NUM_OF_SAMP,1)*2*prop_flow_rate_err + prop_flow_rate_mean - prop_flow_rate_err;

% nozzle efficiency sample - from an uniform distribution
nozzle_eff_sam = lhsdesign(NUM_OF_SAMP,1)*2*nozzle_eff_err + nozzle_eff_mean - nozzle_eff_err;

% c star sample - from an uniform distribution
c_star_sam = lhsdesign(NUM_OF_SAMP,1)*2*c_star_err + c_star_mean - c_star_err;

% exit pressure sample - from a normal distribution
exit_press_sam = lhsnorm(exit_press_mean, exit_press_err, NUM_OF_SAMP);

% chamber pressure sample - from a normal distribution
chamber_press_sam = lhsnorm(chamber_press_mean, chamber_press_err, NUM_OF_SAMP);

% burn time sample - from a normal distribution
burn_time_sam = lhsnorm(burn_time_mean, burn_time_err, NUM_OF_SAMP);

% mass sample - from a normal distribution
mass_sam = lhsnorm(mass_mean, mass_err, NUM_OF_SAMP);

% drag coefficient factor sample - from an uniform distribution
drag_coeff_sam = lhsnorm(0, 1, NUM_OF_SAMP);

% head wind sample - from an uniform distribution
head_wind_sam = lhsdesign(NUM_OF_SAMP,1)*2*head_wind_err + head_wind_mean - head_wind_err;

% cross wind sample - from an uniform distribution
cross_wind_sam = lhsdesign(NUM_OF_SAMP,1)*2*cross_wind_err + cross_wind_mean - cross_wind_err;

% launch altitude sample - from a normal distribution
launch_alt_sam = lhsnorm(launch_alt_mean, launch_alt_err, NUM_OF_SAMP);

% launch angle sample - from a normal distribution
launch_ang_sam = lhsnorm(launch_angle_mean, launch_angle_err, NUM_OF_SAMP);

% ballute opening altitude sample - from an uniform distribution
ballute_alt_sam = lhsdesign(NUM_OF_SAMP,1)*2*ballute_alt_err + ballute_alt_mean - ballute_alt_err;

% main chute opening altitude sample - from an uniform distribution
chute_alt_sam = lhsdesign(NUM_OF_SAMP,1)*2*chute_alt_err + chute_alt_mean - chute_alt_err;

% ballute drag coefficient sample - from an uniform distribution
ballute_drag_coeff_sam = lhsdesign(NUM_OF_SAMP, 1)*2*ballute_drag_coeff_err + ballute_drag_coeff_mean - ballute_drag_coeff_err;

% main chute drag coefficient sample - from an uniform distribution
chute_drag_coeff_sam = lhsdesign(NUM_OF_SAMP, 1)*2*chute_drag_coeff_err + chute_drag_coeff_mean - chute_drag_coeff_err;


%% Perform Simulation on samples

points = zeros(NUM_OF_SAMP, 2);

errors = zeros(NUM_OF_SAMP, 1);

for sam_num = 1:NUM_OF_SAMP
    lastwarn('');
    drag_coeff_error_fun = @(x) x + x*drag_coeff_err*drag_coeff_sam(sam_num);
    drag_data_sam = arrayfun(drag_coeff_error_fun, drag_coeff_data);
    [Time, Trajectory] = ComputeFlightTrajectory(...
        fuse_dia_sam(sam_num), fuse_len_sam(sam_num), prop_flow_rate_sam(sam_num),...
        nozzle_eff_sam(sam_num), c_star_sam(sam_num), exit_press_sam(sam_num),...
        chamber_press_sam(sam_num), burn_time_sam(sam_num), mass_sam(sam_num),...
        mach_data, drag_data_sam, head_wind_sam(sam_num), cross_wind_sam(sam_num),...
        launch_alt_sam(sam_num), launch_ang_sam(sam_num), ballute_alt_sam(sam_num),...
        chute_alt_sam(sam_num), ballute_drag_coeff_sam(sam_num), chute_drag_coeff_sam(sam_num));
    
    [warnMsg, warnId] = lastwarn;
    % do error logging
    if ~isempty(warnMsg)
        errors(sam_num,1) = 1;
    end
    
    output = [Time Trajectory];
     
    launch_height = launch_alt_sam(sam_num);
    burn = round(burn_time_sam(sam_num));     
    
    %% Find zeros
    % current method does a linear search to find the closest point
    % and it does not seem to be the best way to do it. Assumes that the
    % landing time is greater than the burn time
    
    % gonna figure out what this is and then make a newton-raphson 
    
    index = 0;
    difference = realmax;
    for i = burn:size(Trajectory)
        curr_diff = abs(Trajectory(i,3) - launch_height);
        if (curr_diff < difference)
            difference = curr_diff;
            index = i;
        end
    end
    
    points(sam_num,1) = Trajectory(index,1);
    points(sam_num,2) = Trajectory(index,2);

end

sim_number = 1:NUM_OF_SAMP;

% create a table that lists all the inital parameters of each sample
parameter_guide = table(sim_number', fuse_dia_sam, fuse_len_sam, prop_flow_rate_sam, ...
    nozzle_eff_sam, c_star_sam, exit_press_sam, chamber_press_sam, burn_time_sam, ...
    mass_sam, drag_coeff_sam, head_wind_sam, cross_wind_sam, launch_alt_sam, ...
    launch_ang_sam, ballute_alt_sam, chute_alt_sam, ballute_drag_coeff_sam, chute_drag_coeff_sam);

%% Log Output
writetable(parameter_guide, OUTPUT_GUIDE_DIR);
writematrix(points, LANDING_PTS_DIR);
writematrix(errors, ERRORS_DIR);
