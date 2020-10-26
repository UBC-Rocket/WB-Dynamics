%% Setup workspace
clear;
clc;
close all;
format short g;

%% Define simulation properties
% Free-flight simulation settings
Sim.TimeStepSize = 1;
Sim.SimTime = 600;

% Result display settings
Sim.PlotAnimation = 'ON';

% Global properties
Global.EarthRad = 6371.009e3;
Global.GravAccelSL = 9.81;
Global.WindVelVec = [0 -10 0]';
Global.SpHeatRatio = 1.4;

% Rocket physical properties
Rocket.BurnTime = 34;
Rocket.LoadMass = 687.6761773;
Rocket.FuseDia = 0.48;
Rocket.FuseLength = 8.013640494;
Rocket.PropFlowRate = 12;
Rocket.NozzleEff = 0.98;
Rocket.C_Star = 1580.684648;
Rocket.ExitPressure = 93914.05538;
Rocket.ChamberPressure = 1000000;
Rocket.ExpAreaRatio = 2.3;

% Rocket drag properties
load('Rocket drag data.mat');
Rocket.MachNumData = RocketDragData(:,1);
Rocket.DragCoeffData = RocketDragData(:,2);
Rocket.DragArea = pi/4*Rocket.FuseDia^2;
Rocket.ACRelBasePosVec_B = [0.625 0 0]';
Rocket.DirVec_B = [1 0 0]';

% Rocket launch properties
Rocket.LaunchAngle = 80;
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
[Time,StateVecTraj] = ode45(...
 Func,(0:Sim.TimeStepSize:Sim.SimTime)',StateVecInit);

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