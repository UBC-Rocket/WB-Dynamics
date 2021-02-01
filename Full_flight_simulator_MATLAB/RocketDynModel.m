function [StateDerivVec,Rocket] = RocketDynModel(StateVec,Time,Global,Rocket)
%% Extract states and inputs
% States
Rocket.PosVec = StateVec(1:3);
Rocket.RollAngle = StateVec(4);
Rocket.ElevAngle = StateVec(5);
Rocket.HeadAngle = StateVec(6);
Rocket.VelVec = StateVec(7:9);
Rocket.AngVelVec_B = StateVec(10:12);

%% Rocket interial properties
Rocket.Mass = ComputeRocketMass(Rocket,Time);
[Rocket.CGRelBasePosVec_B,Rocket.CGRelBaseVelVec_B,Rocket.CGRelBaseAccVec_B] =...
 ComputeCGRelBase(Rocket,Time);
Rocket.MOIMat = [ % Load time-varying MOI data
 (1/2)*Rocket.Mass*(Rocket.FuseDia/2)^2 0 0;
 0 (1/12)*Rocket.Mass*(3*(Rocket.FuseDia/2)^2 + Rocket.FuseLength^2) 0;
 0 0 (1/12)*Rocket.Mass*(3*(Rocket.FuseDia/2)^2 + Rocket.FuseLength^2)];

%% Updated global properties
[Global.AirDensity,Global.SoundSpeed,~,Global.AtmPressure,~,~,~] = atmos(Rocket.PosVec(3));
Global.GravAccel = Global.GravAccelSL*((Global.EarthRad/(Global.EarthRad + Rocket.PosVec(3)))^2);

%% Kinematics
% Fuselage rotation matrices
Rocket.HeadRotMat = [
 cosd(Rocket.HeadAngle) -sind(Rocket.HeadAngle) 0;
 sind(Rocket.HeadAngle) cosd(Rocket.HeadAngle) 0;
 0 0 1];
Rocket.ElevRotMat = [
 cosd(Rocket.ElevAngle) 0 sind(Rocket.ElevAngle);
 0 1 0;
 -sind(Rocket.ElevAngle) 0 cosd(Rocket.ElevAngle)];
Rocket.RollRotMat = [
 1 0 0;
 0 cosd(Rocket.RollAngle) -sind(Rocket.RollAngle);
 0 sind(Rocket.RollAngle) cosd(Rocket.RollAngle)];
Rocket.TotalRotMat = Rocket.HeadRotMat*Rocket.ElevRotMat*Rocket.RollRotMat;

% Euler angle matrices
Rocket.EulerRotMat = [
 1 0 -sind(Rocket.ElevAngle);
 0 cosd(Rocket.RollAngle) cosd(Rocket.ElevAngle)*sind(Rocket.RollAngle);
 0 -sind(Rocket.RollAngle) cosd(Rocket.ElevAngle)*cosd(Rocket.RollAngle)];

% Forward coordinate transformation matrices
Rocket.HeadTransMat_F = Rocket.HeadRotMat';
Rocket.ElevTransMat_F = Rocket.ElevRotMat';
Rocket.RollTransMat_F = Rocket.RollRotMat';
Rocket.TotalTransMat_F = Rocket.RollTransMat_F*Rocket.ElevTransMat_F*Rocket.HeadTransMat_F;

% Backward coordinate transformation matrices
Rocket.HeadTransMat_B = Rocket.HeadRotMat;
Rocket.ElevTransMat_B = Rocket.ElevRotMat;
Rocket.RollTransMat_B = Rocket.RollRotMat;
Rocket.TotalTransMat_B = Rocket.HeadTransMat_B*Rocket.ElevTransMat_B*Rocket.RollTransMat_B;

% Rocket direction vector
Rocket.DirVec = Rocket.TotalRotMat*Rocket.DirVec_B;

% Aerodynamic center velocity vector
Rocket.ACVelVec =...
 Rocket.VelVec...
 + Rocket.TotalTransMat_B*(...
 -Rocket.CGRelBaseVelVec_B...
 + cross(Rocket.AngVelVec_B,Rocket.ACRelBasePosVec_B - Rocket.CGRelBasePosVec_B));

% Chute attachment point velocity
Rocket.ChuteVelVec =...
 Rocket.VelVec...
 + Rocket.TotalTransMat_B*(...
 -0*Rocket.CGRelBaseVelVec_B...
 + cross(Rocket.AngVelVec_B,Rocket.ChuteRelBasePosVec_B - Rocket.CGRelBasePosVec_B));

%% Kinetics
if Rocket.PosVec(3) < Rocket.RailLength*sind(Rocket.LaunchAngle) + Rocket.LaunchAlt
 %% Compute external forces
 % Thrust force
 Rocket = ComputeThrustMag(Global,Rocket,Time);
 
 % Gravitational force
 Rocket.GravForce = -Rocket.Mass*Global.GravAccel*sind(Rocket.LaunchAngle);
 
 % Rail friction force
 Rocket.FricForce = -Rocket.RailFricCoeff*Rocket.Mass*Global.GravAccel*cosd(Rocket.LaunchAngle);
 
 % Aerodynamic force
 Rocket = ComputeDragForceVec(Global,Rocket);
 Rocket.AeroForce = dot(Rocket.DragForceVec,Rocket.LaunchVec);
 
 % Net external force
 Rocket.TotalForce = Rocket.ThrustForce + Rocket.GravForce + Rocket.FricForce + Rocket.AeroForce;
 
 %% Compute state derivatives
 Rocket.AccVec = Rocket.TotalForce/Rocket.Mass*Rocket.LaunchVec;
 Rocket.AngAccVec_B = zeros(3,1);
else
 %% Kinetics - Forces
 % Gravitational force
 Rocket.GravForceVec = [0 0 -Rocket.Mass*Global.GravAccel]';
 
 % Thrust force
 Rocket = ComputeThrustMag(Global,Rocket,Time);
 Rocket.ThrustForceVec = Rocket.ThrustForce*Rocket.DirVec;
 
 % Aerodynamic force
 Rocket = ComputeDragForceVec(Global,Rocket);
 Rocket.AeroForceVec = Rocket.DragForceVec;
 
 % Ballute force (currently using massless parachute model)
 Rocket.ChuteRelWindVelVec = Global.WindVelVec - Rocket.ChuteVelVec;
 if (Rocket.VelVec(3) < 0) && (Rocket.PosVec(3) < Rocket.BalluteAlt) && (Rocket.PosVec(3) > Rocket.MainChuteAlt)
  Rocket.BalluteForceVec =...
   0.5*Rocket.BalluteDragCoeff*Global.AirDensity*Rocket.BalluteArea...
   *norm(Rocket.ChuteRelWindVelVec)*Rocket.ChuteRelWindVelVec;
 else
  Rocket.BalluteForceVec = zeros(3,1);
 end
 
 % Main chute force (currently using massless parachute model)
 if (Rocket.VelVec(3) < 0) && (Rocket.PosVec(3) < Rocket.MainChuteAlt)
  Rocket.MainChuteForceVec =...
   0.5*Rocket.MainChuteDragCoeff*Global.AirDensity*Rocket.MainChuteArea...
   *norm(Rocket.ChuteRelWindVelVec)*Rocket.ChuteRelWindVelVec;
 else
  Rocket.MainChuteForceVec = zeros(3,1);
 end
 
 % Total force vector
 Rocket.ForceVec =...
  Rocket.GravForceVec + Rocket.ThrustForceVec + Rocket.AeroForceVec...
  + Rocket.BalluteForceVec + Rocket.MainChuteForceVec;
 
 %% Kinetics - Moments
 % Thrust damping moment
 if Time < Rocket.BurnTime
  Rocket.ThrustDampMom =...
   -Rocket.PropFlowRate*cross(-Rocket.CGRelBasePosVec_B,cross(Rocket.AngVelVec_B,-Rocket.CGRelBasePosVec_B))+thrustMisAlignmentMoment(Rocket);
 else
  Rocket.ThrustDampMom = zeros(3,1);
 end
 
 % Fuselage aerodynamic moment
 Rocket.AeroMomVec =...
  cross(Rocket.ACRelBasePosVec_B - Rocket.CGRelBasePosVec_B,Rocket.TotalTransMat_F*Rocket.AeroForceVec);
 
 % Ballute moment
 Rocket.BalluteMomVec =...
  cross(Rocket.ChuteRelBasePosVec_B - Rocket.CGRelBasePosVec_B,Rocket.TotalTransMat_F*Rocket.BalluteForceVec);
 
 % Main chute moment
 Rocket.MainChuteMomVec =...
  cross(Rocket.ChuteRelBasePosVec_B - Rocket.CGRelBasePosVec_B,Rocket.TotalTransMat_F*Rocket.MainChuteForceVec);
 
 % Total aerodynamic moment
 Rocket.MomVec =...
  Rocket.AeroMomVec + Rocket.BalluteMomVec + Rocket.MainChuteMomVec + Rocket.ThrustDampMom;
 
 %% Compute state derivatives
 Rocket.AccVec = Rocket.ForceVec/Rocket.Mass;
 Rocket.AngAccVec_B = Rocket.MOIMat\(...
  Rocket.MomVec - cross(Rocket.AngVelVec_B,Rocket.MOIMat*Rocket.AngVelVec_B));
end

%% Compile state derivative vector
StateDerivVec = [
 Rocket.VelVec;
 Rocket.EulerRotMat\Rocket.AngVelVec_B;
 Rocket.AccVec;
 Rocket.AngAccVec_B];