% Computes the trajectory of a rocket flight with a time step of 1 sec for
% a total time of 1000 sec.
%
% @return           `Time` being a `SimTime + 1` by 1 matrix that represents
%                   each time step in the integrator.
%                   `StateVecTraj` being a `SimTime + 1` by 12 matrix where
%                   each row represents the rocket state at each time step.
function [Time, StateVecTraj] = ComputeFlightTrajectory(fuse_dia, fuse_len,...
    flow_rate, nozz_eff, c_star, exit_press, cham_press, burn_time, mass,...
    mach_numbers, drag_coeff, head_wind, cross_wind, launch_alt, launch_ang,...
    ballute_alt, chute_alt, ballute_coeff, chute_coeff)
%% Define simulation properties
% Free-flight simulation settings
Sim.TimeStepSize = 1;
Sim.SimTime = 1000;

% Global properties
Global.EarthRad = 6371.009e3; % Earth Radius
Global.GravAccelSL = 9.81; % gravitational acceleration at sea level

% Wind direction 
Global.WindVelVec = [head_wind cross_wind 0]'; %WindVec';
Global.SpHeatRatio = 1.4;

% Rocket physical properties
Rocket.BurnTime = burn_time;
Rocket.LoadMass = mass; 
Rocket.FuseDia = fuse_dia; 
Rocket.FuseLength = fuse_len; 
Rocket.PropFlowRate = flow_rate;
Rocket.NozzleEff = nozz_eff; 
Rocket.C_Star = c_star;
Rocket.ExitPressure = exit_press;
Rocket.ChamberPressure = cham_press;
Rocket.ExpAreaRatio = 2.3; %check

%% Rocket drag properties
Rocket.MachNumData = mach_numbers;
Rocket.DragCoeffData = drag_coeff; %check
Rocket.DragArea = pi/4*Rocket.FuseDia^2; 
Rocket.ACRelBasePosVec_B = [fuse_len-5.152644; 0; 0];  %WHAT THE FUCK IS THIS?
Rocket.DirVec_B = [1 0 0]';

%% Rocket launch properties
Rocket.LaunchAngle = launch_ang; %80; % ANGLE IN DEGREES [0, 180]
Rocket.InitDistAlongRail = 0;
Rocket.LaunchAlt = launch_alt; %1401;
Rocket.RailLength = 15;
Rocket.RailFricCoeff = 0;
Rocket.LaunchVec = [
 cosd(Rocket.LaunchAngle);
 0;
 sind(Rocket.LaunchAngle)];

%% Chute properties
Rocket.BalluteAlt = ballute_alt; %Ballute.Alt;%75000;
Rocket.MainChuteAlt = chute_alt; %Chute.Alt;%3000;

% Rocket.BalluteInfo = Ballute.Info;
% Rocket.MainChuteInfo = Chute.Info;

Rocket.BalluteDragCoeff = ballute_coeff; 
Rocket.MainChuteDragCoeff = chute_coeff; 
Rocket.BalluteLineLength = 5;
Rocket.MainChuteLineLength = 7.148;
Rocket.BalluteDia = 1;
Rocket.MainChuteDia = 4.13;
Rocket.NumBallutes = 3;
Rocket.NumMainChutes = 3;
Rocket.BalluteArea = Rocket.NumBallutes*pi/4*(Rocket.BalluteDia^2);
Rocket.MainChuteArea = Rocket.NumMainChutes*pi/4*(Rocket.MainChuteDia^2);
Rocket.ChuteRelBasePosVec_B = [5.66 0 0]'; %% measured from engine-up

%% Run simulation \\ I have NO idea what's going on here
StateVecInit = [
 [0 0 Rocket.LaunchAlt]' + Rocket.InitDistAlongRail*Rocket.LaunchVec;
 0; -Rocket.LaunchAngle; 0;
 zeros(3,1);
 zeros(3,1)];
Func = @(Time,StateVec) RocketDynModel(StateVec,Time,Global,Rocket);
[Time,StateVecTraj] = ode45(...
 Func,(0:Sim.TimeStepSize:Sim.SimTime)',StateVecInit);