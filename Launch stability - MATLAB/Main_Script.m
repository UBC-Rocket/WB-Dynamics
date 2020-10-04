%% Setup workspace
clear;
clc;
close all;
format short g;

%% Define simulation properties
% Free-flight simulation settings
Sim.TimeStepSize = 1;
Sim.MaxStepSize = 0.01;

% Result display settings
Sim.PlotAnimation = 'ON';

% Global properties
Global.EarthRad = 6371.009e3;
Global.GravAccelSL = 9.81;
Global.WindVelVec = [0 -10 0]';
Global.SpHeatRatio = 1.4;

% Rocket physical properties
Rocket.BurnTime = 34;
Rocket.LoadMass = 711.9440829;
Rocket.FuseDia = 0.508;
Rocket.FuseLength = 7.90936;
Rocket.PropFlowRate = 12.5;
Rocket.NozzleEff = 0.98;
Rocket.C_Star = 1580.684648;
Rocket.ExitPressure = 78522.89615;
Rocket.ChamberPressure = 950000;
Rocket.ExpAreaRatio = 2.5;

% Rocket detailed dimensions (as per Fig. 3 from Box et al.)
Rocket.DirVec_B = [1 0 0]';
Rocket.NoseShape = 'Ogive';
Rocket.NumFins = 4;
Rocket.T_f = 0.01;
Rocket.l_TR = Rocket.FuseLength;
Rocket.l_n = 1.5;
Rocket.l_b = Rocket.FuseLength - Rocket.l_n;
Rocket.l_c = 0;
Rocket.l_r = 1.016;
Rocket.l_t = 0.635;
Rocket.l_m = 0.635;
Rocket.l_s = 0.508;
Rocket.l_w = Rocket.l_r - Rocket.l_t;
Rocket.l_TS = Rocket.FuseDia + 2*Rocket.l_s;
Rocket.d_n = Rocket.FuseDia;
Rocket.d_b = Rocket.FuseDia;
Rocket.d_u = Rocket.FuseDia;
Rocket.d_d = Rocket.FuseDia;
Rocket.d_f = Rocket.FuseDia;
Rocket.K = 1;
Rocket.X_b = Rocket.l_n;
Rocket.X_c = Rocket.l_TR - Rocket.l_c;
Rocket.X_f = 6;
AeroData = load('Aero data.mat');
Rocket.delta_Data = AeroData.delta_Data;
Rocket.eta_Data = AeroData.eta_Data;

% Rocket launch properties
Rocket.LaunchAngle = 85;
Rocket.InitDistAlongRail = 0;
Rocket.LaunchAlt = 1401;
Rocket.RailLength = 15;
Rocket.RailFricCoeff = 0;
Rocket.LaunchVec = [
 cosd(Rocket.LaunchAngle);
 0;
 sind(Rocket.LaunchAngle)];

% Chute properties
Rocket.BalluteAlt = 75000;
Rocket.MainChuteAlt = 3000;
Rocket.BalluteDragCoeff = 0.75;
Rocket.MainChuteDragCoeff = 0.53;
Rocket.BalluteLineLength = 5;
Rocket.MainChuteLineLength = 7.148;
Rocket.BalluteDia = 1;
Rocket.MainChuteDia = 4.13;
Rocket.NumBallutes = 3;
Rocket.NumMainChutes = 3;
Rocket.BalluteArea = Rocket.NumBallutes*pi/4*(Rocket.BalluteDia^2);
Rocket.MainChuteArea = Rocket.NumMainChutes*pi/4*(Rocket.MainChuteDia^2);
Rocket.ChuteRelBasePosVec_B = [5.66 0 0]';

%% Run simulation
StateVecInit = [
 [0 0 Rocket.LaunchAlt]' + Rocket.InitDistAlongRail*Rocket.LaunchVec;
 0; -Rocket.LaunchAngle; 0;
 zeros(3,1);
 zeros(3,1)];
Func = @(Time,StateVec) RocketDynModel(StateVec,Time,Global,Rocket);
opts = odeset('MaxStep',Sim.MaxStepSize);
[Time,StateVecTraj] = ode45(...
 Func,(0:Sim.TimeStepSize:Rocket.BurnTime)',StateVecInit,opts);

%% Plot animation
Sim.NumTimeSteps = length(Time);
for TimeStepNum = Sim.NumTimeSteps:-1:1
 [~,TimeStep(TimeStepNum).Rocket] = RocketDynModel(StateVecTraj(TimeStepNum,:)',Time(TimeStepNum),Global,Rocket);
end
if strcmp(Sim.PlotAnimation,'ON')
 Sim.PlotScalingFactor = 3000;
 FuseVecInit = Sim.PlotScalingFactor*[Rocket.FuseLength 0 0]';
 Fin(1).VecInit = Sim.PlotScalingFactor*[0 -Rocket.FuseLength/3 0]';
 Fin(2).VecInit = Sim.PlotScalingFactor*[0 0 Rocket.FuseLength/3]';
 Fin(3).VecInit = Sim.PlotScalingFactor*[0 Rocket.FuseLength/3 0]';
 Fin(4).VecInit = Sim.PlotScalingFactor*[0 0 -Rocket.FuseLength/3]';
 for TimeStepNum = 1:Sim.NumTimeSteps
  FuseVec = TimeStep(TimeStepNum).Rocket.TotalRotMat*FuseVecInit;
  plot3(...
   [TimeStep(TimeStepNum).Rocket.PosVec(1),TimeStep(TimeStepNum).Rocket.PosVec(1) + FuseVec(1)]',...
   [TimeStep(TimeStepNum).Rocket.PosVec(2),TimeStep(TimeStepNum).Rocket.PosVec(2) + FuseVec(2)]',...
   [TimeStep(TimeStepNum).Rocket.PosVec(3),TimeStep(TimeStepNum).Rocket.PosVec(3) + FuseVec(3)]',...
   'k','LineWidth',1.5);
  hold on;
  for FinNum = 4:-1:1
   Fin(FinNum).Vec = TimeStep(TimeStepNum).Rocket.TotalRotMat*Fin(FinNum).VecInit;
   plot3(...
    [TimeStep(TimeStepNum).Rocket.PosVec(1),TimeStep(TimeStepNum).Rocket.PosVec(1) + Fin(FinNum).Vec(1)]',...
    [TimeStep(TimeStepNum).Rocket.PosVec(2),TimeStep(TimeStepNum).Rocket.PosVec(2) + Fin(FinNum).Vec(2)]',...
    [TimeStep(TimeStepNum).Rocket.PosVec(3),TimeStep(TimeStepNum).Rocket.PosVec(3) + Fin(FinNum).Vec(3)]',...
    'k','LineWidth',1.5);
  end
  axis([0 300000 -75000 75000 0 150000]);
  daspect([1 1 1]);
  grid on;
  hold off;
  pause;
 end
end