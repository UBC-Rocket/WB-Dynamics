function Rocket = ComputeAero(Global,Rocket)
%% Wind speed calculations
if Rocket.PosVec(3) < Rocket.RailLength*sind(Rocket.LaunchAngle) + Rocket.LaunchAlt
 Rocket.RelWindVelVec = -Rocket.VelVec;
 Rocket.AttackAngle = 0;
else
 Rocket.RelWindVelVec = Global.WindVelVec - Rocket.VelVec;
 Rocket.AttackAngle =...
  acos(-dot(Rocket.RelWindVelVec,Rocket.DirVec)/(norm(Rocket.RelWindVelVec)*norm(Rocket.DirVec) + 1e-3));
end
Rocket.MachNum = norm(Rocket.RelWindVelVec)/Global.SoundSpeed;

%% Normal aerodynamic coefficient
% Nose
Rocket.C_N_alpha_n = 2;

% Conical body changes
Rocket.C_N_alpha_c = 2*(((Rocket.d_d/Rocket.d_n)^2) - ((Rocket.d_u/Rocket.d_n)^2));

% Fins
Rocket.K_fb = 1 + (Rocket.d_f/2)/(Rocket.l_s + Rocket.d_f/2);
Rocket.C_N_alpha_f =...
 Rocket.K_fb*(4*Rocket.NumFins*((Rocket.l_s/Rocket.d_n)^2))...
 /(1 + sqrt(1 + ((2*Rocket.l_m/(Rocket.l_r + Rocket.l_t))^2)));

% Body
Rocket.A_p = Rocket.d_n*Rocket.l_b;
Rocket.A_r = pi/4*Rocket.d_n;
% Rocket.C_N_alpha_L = Rocket.K*Rocket.A_p/Rocket.A_r*Rocket.AttackAngle;
Rocket.C_N_alpha_L = 0;

% Total coefficient
Rocket.C_N_alpha = Rocket.C_N_alpha_c + Rocket.C_N_alpha_f + Rocket.C_N_alpha_L;
Rocket.C_N = Rocket.C_N_alpha*Rocket.AttackAngle;

%% Center of pressure
% Nose
if strcmp(Rocket.NoseShape,'Conical')
 Rocket.X_cp_n = (2/3)*Rocket.l_n;
elseif strcmp(Rocket.NoseShape,'Ogive')
 Rocket.X_cp_n = 0.466*Rocket.l_n;
elseif strcmp(Rocket.NoseShape,'Parabolic')
 Rocket.X_cp_n = 0.5*Rocket.l_n;
else
 error('Nose cone shape does not exist...');
end

% Conical body changes
if abs(Rocket.d_u - Rocket.d_d) > 0
 Rocket.X_cp_c =...
  Rocket.X_c + (Rocket.l_c/3)*(1 + (1 - (Rocket.d_u/Rocket.d_d))/(1 - ((Rocket.d_u/Rocket.d_d)^2)));
else
 Rocket.X_cp_c = 0;
end

% Fins
Rocket.X_cp_f =...
 Rocket.X_f + (Rocket.l_m*(Rocket.l_r + 2*Rocket.l_t))/(3*(Rocket.l_r + Rocket.l_t))...
 + (1/6)*(Rocket.l_r + Rocket.l_t - (Rocket.l_r*Rocket.l_t)/(Rocket.l_r + Rocket.l_t));

% Body
% Rocket.X_cp_L = Rocket.X_b + 0.5*Rocket.l_b;
Rocket.X_cp_L = 0;

% Total center of pressure
Rocket.X_cp =...
 (Rocket.C_N_alpha_c*Rocket.X_cp_c + Rocket.C_N_alpha_f*Rocket.X_cp_f + Rocket.C_N_alpha_L*Rocket.X_cp_L)...
 /Rocket.C_N_alpha;
Rocket.ACRelBasePosVec_B = [
 Rocket.l_TR - Rocket.X_cp;
 0;
 0];

%% Drag coefficient
% Reynolds numbers
Rocket.Re_fb = Global.AirDensity*norm(Rocket.RelWindVelVec)*Rocket.l_TR/Global.AirViscosity;
Rocket.Re_f = Global.AirDensity*norm(Rocket.RelWindVelVec)*Rocket.l_m/Global.AirViscosity;
Rocket.Re_c = 5e5;

% Friction coefficients
if Rocket.Re_fb > 0
 if Rocket.Re_fb <= Rocket.Re_c
  Rocket.C_f_fb = 1.328/sqrt(Rocket.Re_fb);
 else
  Rocket.C_f_fb =...
   0.074/(Rocket.Re_fb^(1/5))...
   - Rocket.Re_c/Rocket.Re_fb*(0.074/(Rocket.Re_fb^(1/5)) - 1.328/sqrt(Rocket.Re_fb));
 end
else
 Rocket.C_f_fb = 1;
end
if Rocket.Re_f > 0
 if Rocket.Re_f <= Rocket.Re_c
  Rocket.C_f_f = 1.328/sqrt(Rocket.Re_f);
 else
  Rocket.C_f_f =...
   0.074/(Rocket.Re_f^(1/5))...
   - Rocket.Re_c/Rocket.Re_f*(0.074/(Rocket.Re_f^(1/5)) - 1.328/sqrt(Rocket.Re_f));
 end
else
 Rocket.C_f_f = 1;
end

% Forebody
Rocket.C_D_fb = (1 + 60/((Rocket.l_TR/Rocket.d_b)^3) + 0.0025*Rocket.l_b/Rocket.d_b)*(2.7*Rocket.l_n/Rocket.d_b + 4*Rocket.l_b/Rocket.d_b + 2*(1 - Rocket.d_d/Rocket.d_b)*Rocket.l_c/Rocket.d_b)*Rocket.C_f_fb;

% Body
Rocket.C_D_b = 0.029*((Rocket.d_d/Rocket.d_b)^3)/sqrt(Rocket.C_D_fb);

% Fins
Rocket.A_fe = 0.5*(Rocket.l_r + Rocket.l_t)*Rocket.l_s;
Rocket.A_fp = Rocket.A_fe + 0.5*Rocket.d_f*Rocket.l_r;
Rocket.C_D_f = 2*Rocket.C_f_f*(1 + 2*Rocket.T_f/Rocket.l_m)*4*Rocket.NumFins*Rocket.A_fp/(pi*(Rocket.d_f^2));

% Interference
Rocket.C_D_i =...
 2*Rocket.C_f_f*(1 + 2*Rocket.T_f/Rocket.l_m)*4*Rocket.NumFins*(Rocket.A_fp - Rocket.A_fe)...
 /(pi*(Rocket.d_f^2));

% Total drag coefficient at zero AoA
Rocket.C_d_0 = Rocket.C_D_fb + Rocket.C_D_b + Rocket.C_D_f + Rocket.C_D_i;

% Non-zero AoA effects on body
Rocket.delta = interp1(Rocket.delta_Data(:,1),Rocket.delta_Data(:,2),Rocket.AttackAngle,'spline');
Rocket.eta = interp1(Rocket.eta_Data(:,1),Rocket.eta_Data(:,2),Rocket.AttackAngle,'spline');
Rocket.C_D_b_alpha =...
 2*Rocket.delta*(Rocket.AttackAngle^2) +...
 3.6*Rocket.eta*(1.36*Rocket.l_TR - 0.55*Rocket.l_n)*(Rocket.AttackAngle^3)/(pi*Rocket.d_b);

% Non-zero AoA effects on fins
Rocket.R_s = Rocket.l_TS/Rocket.d_f;
Rocket.k_fb = 0.8065*(Rocket.R_s^2) + 1.1553*Rocket.R_s;
Rocket.k_bf = 0.1935*(Rocket.R_s^2) + 0.8174*Rocket.R_s + 1;
Rocket.C_D_f_alpha =...
 (Rocket.AttackAngle^2)*(1.2*4*Rocket.A_fp/(pi*(Rocket.d_f^2)) +...
 3.12*(Rocket.k_fb + Rocket.k_bf - 1)*(4*Rocket.A_fe/(pi*(Rocket.d_f^2))));

% Total drag coefficient
Rocket.C_D = Rocket.C_d_0 + Rocket.C_D_b_alpha + Rocket.C_D_f_alpha;

% Axial aerodynamic coefficient
Rocket.C_A =...
 (Rocket.C_D*cos(Rocket.AttackAngle) - 0.5*Rocket.C_N*sin(2*Rocket.AttackAngle))...
 /(1 - ((sin(Rocket.AttackAngle))^2));

%% Compressibility corrections
if Rocket.MachNum <= 0.8
 Rocket.C_N = Rocket.C_N/sqrt(1 - (Rocket.MachNum^2));
 Rocket.C_A = Rocket.C_A/sqrt(1 - (Rocket.MachNum^2));
elseif Rocket.MachNum >= 1.2
 Rocket.C_N = Rocket.C_N/sqrt((Rocket.MachNum^2) - 1);
 Rocket.C_A = Rocket.C_A/sqrt((Rocket.MachNum^2) - 1);
else
 Rocket.C_N = Rocket.C_N/sqrt(1 - (0.8^2));
 Rocket.C_A = Rocket.C_A/sqrt(1 - (0.8^2));
end

%% Aerodynamic force
% Normal aerodynamic force
Rocket.NormalRelWindVelVec =...
 Rocket.RelWindVelVec - dot(Rocket.RelWindVelVec,Rocket.DirVec)*Rocket.DirVec;
Rocket.NormalAeroForceDirVec =...
 Rocket.NormalRelWindVelVec/(norm(Rocket.NormalRelWindVelVec) + 1e-3);
Rocket.NormalAeroForceVec =...
 0.5*Rocket.C_N*Global.AirDensity*Rocket.A_r*(norm(Rocket.RelWindVelVec)^2)...
 *Rocket.NormalAeroForceDirVec;

% Axial aerodynamic force
Rocket.AxialRelWindVelVec =...
 dot(Rocket.RelWindVelVec,Rocket.DirVec)*Rocket.DirVec;
Rocket.AxialAeroForceDirVec =...
 Rocket.AxialRelWindVelVec/(norm(Rocket.AxialRelWindVelVec) + 1e-3);
Rocket.AxialAeroForceVec =...
 0.5*Rocket.C_A*Global.AirDensity*Rocket.A_r*(norm(Rocket.RelWindVelVec)^2)...
 *Rocket.AxialAeroForceDirVec;

% Total aerodynamic force vector
Rocket.AeroForceVec = Rocket.AxialAeroForceVec + Rocket.NormalAeroForceVec;
