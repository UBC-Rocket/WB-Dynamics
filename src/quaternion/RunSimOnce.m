% Vehicle properties mean
fuse_dia_mean           = 0.3048;
fuse_len_mean           = 5.943587967;
prop_flow_rate_mean     = 5.625;
nozzle_eff_mean         = 0.98;
c_star_mean             = 1584.619354;
exit_press_mean         = 77295.59995;
chamber_press_mean      = 1000000;
burn_time_mean          = 32;
mass_mean               = 319.5162962; 

% Aerodynamic properties mean
rocket_drag_data = ReadDragData();      % Load drag data
mach_data = rocket_drag_data(:,1);
drag_coeff_data = rocket_drag_data(:,2);

% Environment properties mean
head_wind_mean          = 5;
cross_wind_mean         = 5;

% Guidence properties mean; will need to make a better ballute/chute calc
launch_angle_mean       = 90;
launch_alt_mean         = 1401;
ballute_alt_mean        = 75000;
chute_alt_mean          = 3000;
ballute_drag_coeff_mean = 0.75;
chute_drag_coeff_mean   = 0.53;

[Time, Trajectory] = ComputeFlightTrajectory(...
fuse_dia_mean, fuse_len_mean, prop_flow_rate_mean,...
nozzle_eff_mean, c_star_mean, exit_press_mean,...
chamber_press_mean, burn_time_mean, mass_mean,...
mach_data, drag_coeff_data, head_wind_mean, cross_wind_mean,...
launch_alt_mean, launch_angle_mean, ballute_alt_mean,...
chute_alt_mean, ballute_drag_coeff_mean, chute_drag_coeff_mean);