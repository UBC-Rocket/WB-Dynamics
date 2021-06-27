function RocketCGRelBasePosVec = CG_rel_base(Rocket, Time) 
%% General Summary:
% This centre of mass calculation is the most braindead way I can calculate
% it. The rocket is divided into four components: the nosecone (includes
% pressurant tank), the LOX tank, the Kero tank, and the engine. I assume
% that the nosecone and engine have constant mass, since it's a good
% assumption (the helium weighs like 2kg and so I just assume it's nothing)
% and the LOX and Kero tanks drain at their constant burn rate. A four body
% linear system.
% I then just calculate the CoM at each timestep with a dumb, 
% straightforward method. Requires three CoM calculations per rocket 
% CoM calculation, but there's no cancerous ODE's/PDE's to deal with, 
% nor integrals or else, so it should be pretty fast. Excel does it fine.
% I'm calculating the CoM from the engine up, since that seems to be a
% reasonable measurement point. 

%% Weights in kg

% top 1/3 of rocket mass values (INPUT)
noseConeMass = Rocket.nose_cone_mass; 
payloadAdapterMass = Rocket.payload_adapter_mass;
payloadMass = Rocket.payload_mass; 
noseConeIntHullMass = Rocket.nose_cone_int_hull_mass;
aviRecSectionHullMass = Rocket.avi_rec_section_hull_mass;
aviMass = Rocket.avi_mass;
recSysMass = Rocket.rec_sys_mass;
recChuteMass = Rocket.rec_chute_mass;
pressurantTankMass = Rocket.pressurant_tank_mass; 
pressurantGasMass = Rocket.pressurant_gas_mass;
pressurantMountMass = Rocket.pressurant_mount_mass; 
pressurantLOXIntHullMass = Rocket.pressureant_LOX_int_hull_mass;
pressurantRCSMass = Rocket.pressurant_RCS_mass;

% LOX & Kero Tank values (INPUT)
LOXTankMass = Rocket.LOX_tank_mass;
LOXMass = Rocket.LOX_mass;
LOXKeroIntHullMass = Rocket.LOX_kero_int_hull_mass;

KeroTankMass = Rocket.kero_tank_mass;
KeroMass = Rocket.kero_mass;
KeroEngIntHullMass = Rocket.kero_engine_int_hull_mass;

% Engine Mass (INPUT)
massEngine = Rocket.mass_engine;

% all values in kg; in the feynman doc if you just ctrl + f "kg", you can
% just directly copy/paste the values down starting from the outputs at 
% "Nose Cone Mass" in order, down to "RCS Plumbing and Valves mass". 

% Internal Calculations, can be ignored
massTopThird = noseConeMass + payloadAdapterMass + payloadMass + ...
    noseConeIntHullMass + aviRecSectionHullMass + aviMass + recSysMass + ...
    recChuteMass + pressurantTankMass + pressurantGasMass + ...
    pressurantMountMass + pressurantLOXIntHullMass + pressurantRCSMass; 
massWetLOX = LOXTankMass + LOXMass + LOXKeroIntHullMass;
massWetKero = KeroTankMass + KeroMass + KeroEngIntHullMass;

%% Lengths in m 

% top third of rocket lengths (INPUT)
noseConeLength = Rocket.nose_length;
payloadLength = Rocket.payload_length;
recSysLength = Rocket.rec_sys_length;
pressurantTankLength = Rocket.pressurant_tank_length;
pressurantLOXIntHullLength = Rocket.pressurant_LOX_int_hull_length;

% Tank Info (INPUT)
LOXTankLength = Rocket.LOX_tank_length;
LOXKeroIntHullLength = Rocket.LOX_kero_int_hull_length; 

KeroTankLength = Rocket.kero_tank_length;
KeroEngIntHullLength = Rocket.kero_eng_int_hull_length;

% Engine Length (INPUT)
lenEngine = Rocket.engine_length;

% same deal as weights, just ctrl + f lengths and get the correct values,
% making sure that there's no redundant ones. the Feynman doc has a few
% redundant values, so double check that the values you're adding
% correspond to this one. 

% Internal Calculations, can be ignored
lenTopThird = noseConeLength + payloadLength + recSysLength...
    + pressurantTankLength + pressurantLOXIntHullLength; 
lenTankLOX = LOXTankLength + LOXKeroIntHullLength;
lenTankKero = KeroTankLength + KeroEngIntHullLength;

%% LOX and Kero Flow Rates (INPUT)
massFlowLOX = Rocket.mass_flow_LOX;
massFlowKero = Rocket.mass_flow_kero;

% Calculations that can be ignored, provided that the burn time is accurate
% and the mass flow rates are correct
if Time <= Rocket.burn_time
    massLOXBurned = massFlowLOX * Time;
    massKeroBurned = massFlowKero * Time;
else
    massLOXBurned = massFlowLOX * Rocket.burn_time;
    massKeroBurned = massFlowKero * Rocket.burn_time;
end

%% Calculation of CoM's (measured from engine)

% CoM of each component is assumed to be in the centre (not completely
% accurate, but bite me, im tired)
topThirdCG = lenTopThird/2; 
tankLOXCG = lenTankLOX/2; 
tankKeroCG = lenTankKero/2; 
engineCG = lenEngine/2;

% CoM method is the simple [(x1)(m1) + (x2)(m2)]/(m1 + m2) method
% Top third/Engine system (constant) calculation
CGtopThirdEng = engineCG + ((engineCG + lenTankLOX + lenTankKero + topThirdCG)...
    *(massTopThird))/(massTopThird + massEngine);

% Kero and LOX Tank system measured from engine bottom
CGKeroLOX = ((lenEngine + lenTankKero + tankLOXCG)*(massWetLOX - massLOXBurned)...
    +(lenEngine + tankKeroCG)*(massWetKero - massKeroBurned))/...
    ((massWetLOX - massLOXBurned) + (massWetKero - massKeroBurned));

% CoM of whole rocket
CGRocket = ((CGKeroLOX)*((massWetLOX - massLOXBurned)+(massWetKero - massKeroBurned))...
    + (CGtopThirdEng)*(massEngine + massTopThird))/((massWetLOX - massLOXBurned) + ...
    (massWetKero - massKeroBurned) + (massTopThird + massEngine)); 

%% Making the vectors
CG_final = sampling.apply_uncertainty(CGRocket, Rocket.CG_uncertainty);
RocketCGRelBasePosVec = [CG_final, 0, 0]';
end