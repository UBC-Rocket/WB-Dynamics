% This implementation although does not have a singularity when the y angle approaches
% 90 degrees, it seems adding wind vector breaks the integrator.
function [StateDerivVec,Rocket] = RocketDynModel(StateVec,Time,Global,Rocket)
%% Extract states and inputs
% States
disp(Time);
Rocket.PosVec = StateVec(1:3); %(x, y, z) respectively
Rocket.QuatVec = StateVec(4:7);
Rocket.VelVec = StateVec(8:10);
Rocket.AngVelVec_B = StateVec(11:13);

%% Rocket internal properties
Rocket.Mass = ComputeRocketMass(Rocket,Time);
[Rocket.CGRelBasePosVec_B,Rocket.CGRelBaseVelVec_B,Rocket.CGRelBaseAccVec_B] =...
 ComputeCGRelBase(Rocket,Time);
Rocket.MOIMat = [ % Load time-varying MOI data
 (1/2)*Rocket.Mass*(Rocket.FuseDia/2)^2 0 0;
 0 (1/12)*Rocket.Mass*(3*(Rocket.FuseDia/2)^2 + Rocket.FuseLength^2) 0;
 0 0 (1/12)*Rocket.Mass*(3*(Rocket.FuseDia/2)^2 + Rocket.FuseLength^2)];

%% Updated global properties
[Global.AirDensity,Global.SoundSpeed,~,Global.AtmPressure] = Atmos(Rocket.PosVec(3));
Global.GravAccel = Global.GravAccelSL*((Global.EarthRad/(Global.EarthRad + Rocket.PosVec(3)))^2);

%% Kinematics
% Forward coordinate transformation matrix
Rocket.TotalRotMat = 2*[
 0.5*(Rocket.QuatVec(1)^2 + Rocket.QuatVec(2)^2 - Rocket.QuatVec(3)^2 - Rocket.QuatVec(4)^2), Rocket.QuatVec(2)*Rocket.QuatVec(3) - Rocket.QuatVec(1)*Rocket.QuatVec(4), Rocket.QuatVec(2)*Rocket.QuatVec(4) + Rocket.QuatVec(1)*Rocket.QuatVec(3);
 Rocket.QuatVec(2)*Rocket.QuatVec(3) + Rocket.QuatVec(1)*Rocket.QuatVec(4), 0.5*(Rocket.QuatVec(1)^2 - Rocket.QuatVec(2)^2 + Rocket.QuatVec(3)^2 - Rocket.QuatVec(4)^2), Rocket.QuatVec(3)*Rocket.QuatVec(4) - Rocket.QuatVec(1)*Rocket.QuatVec(2);
 Rocket.QuatVec(2)*Rocket.QuatVec(4) - Rocket.QuatVec(1)*Rocket.QuatVec(3), Rocket.QuatVec(3)*Rocket.QuatVec(4) - Rocket.QuatVec(1)*Rocket.QuatVec(2), 0.5*(Rocket.QuatVec(1)^2 - Rocket.QuatVec(2)^2 - Rocket.QuatVec(3)^2 + Rocket.QuatVec(4)^2)];

% Quaternion derivative matrix
Rocket.QuatDerivMat = 0.5*[
 0, -Rocket.AngVelVec_B(1), -Rocket.AngVelVec_B(2), -Rocket.AngVelVec_B(3);
 Rocket.AngVelVec_B(1), 0, Rocket.AngVelVec_B(3), -Rocket.AngVelVec_B(2);
 Rocket.AngVelVec_B(2), -Rocket.AngVelVec_B(3), 0, Rocket.AngVelVec_B(1);
 Rocket.AngVelVec_B(3), Rocket.AngVelVec_B(2), -Rocket.AngVelVec_B(1), 0];

% Rocket direction vector
Rocket.DirVec = Rocket.TotalRotMat*Rocket.DirVec_B;

% Aerodynamic center velocity vector
Rocket.ACVelVec =...
 Rocket.VelVec...
 + Rocket.TotalRotMat*(...
 -Rocket.CGRelBaseVelVec_B...
 + cross(Rocket.AngVelVec_B,Rocket.ACRelBasePosVec_B - Rocket.CGRelBasePosVec_B));

% Chute attachment point velocity
Rocket.ChuteVelVec =...
 Rocket.VelVec...
 + Rocket.TotalRotMat*(...
 -0*Rocket.CGRelBaseVelVec_B... % Not quite sure what the Relative Base Velocity Vector is
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
   
  % calculate ballute force.
  Rocket.BalluteForceVec =...
   0.5*Rocket.BalluteDragCoeff*Global.AirDensity*Rocket.BalluteArea...
   *norm(Rocket.ChuteRelWindVelVec)*Rocket.ChuteRelWindVelVec;
 else
  Rocket.BalluteForceVec = zeros(3,1);
 end
 
 % Main chute force (currently using massless parachute model)
 if (Rocket.VelVec(3) < 0) && (Rocket.PosVec(3) < Rocket.MainChuteAlt)
  
  % compute main chute force
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
   -Rocket.PropFlowRate*cross(-Rocket.CGRelBasePosVec_B,cross(Rocket.AngVelVec_B,-Rocket.CGRelBasePosVec_B));
 else
  Rocket.ThrustDampMom = zeros(3,1);
 end
 
 % Fuselage aerodynamic moment
 Rocket.AeroMomVec =...
  cross(Rocket.ACRelBasePosVec_B - Rocket.CGRelBasePosVec_B,Rocket.TotalRotMat'*Rocket.AeroForceVec);
 
 % Engine Axial Offset moment
 % Rocket.EngAxMomVec = ...
 % cross(Rocket.EngRelBasePosVec_B - Rocket.CGRelBasePosVec_B, Rocket.TotalTransMat_F*Rocket.ThrustForceVec);

 % Ballute moment
 Rocket.BalluteMomVec =...
  cross(Rocket.ChuteRelBasePosVec_B - Rocket.CGRelBasePosVec_B,Rocket.TotalRotMat'*Rocket.BalluteForceVec);
 
 % Main chute moment
 Rocket.MainChuteMomVec =...
  cross(Rocket.ChuteRelBasePosVec_B - Rocket.CGRelBasePosVec_B,Rocket.TotalRotMat'*Rocket.MainChuteForceVec);
 
 % Total aerodynamic moment
 Rocket.MomVec =...
  Rocket.AeroMomVec + Rocket.BalluteMomVec + Rocket.MainChuteMomVec + Rocket.ThrustDampMom; % + Rocket.EndAxMomVec

 %% Compute state derivatives
 Rocket.AccVec = Rocket.ForceVec/Rocket.Mass;
 Rocket.AngAccVec_B = Rocket.MOIMat\(...
  Rocket.MomVec - cross(Rocket.AngVelVec_B,Rocket.MOIMat*Rocket.AngVelVec_B));
end

%% Compile state derivative vector

StateDerivVec = [
 Rocket.VelVec;
 Rocket.QuatDerivMat*Rocket.QuatVec;
 Rocket.AccVec;
 Rocket.AngAccVec_B];