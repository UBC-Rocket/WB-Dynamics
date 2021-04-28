function [RocketCGRelBasePosVec,RocketCGRelBaseVelVec,RocketCGRelBaseAccVec] = CG_rel_base(Rocket,Time) 
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

% top third is the nosecone down to the bottom of the pressurant tanks
massTopThird = 54.43049545; 
massWetLOX = 148.2408389;
massWetKero = 67.56971073;
massEngine = 17.63974464;

%% Lengths in m

lenTopThird = 2.6;
lenTankLOX = 1.682371149;
lenTankKero = 1.183713846;
lenEngine = 0.477502972;

%% LOX and Kero Flow Rates
massFlowLOX = 3.810483871;
massFlowKero = 1.814516129;

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
RocketCGRelBasePosVec = [CGRocket, 0, 0]';

if Time <= Rocket.burn_time

    RocketCGRelBaseVelVec = [0,0,0]';
    RocketCGRelBaseAccVec = [0,0,0]';
    % for some reason, this AccVec is not used. I haven't seen a single
    % reference to it anywhere. 
    
    % The VelVec was also _tiny_ and was never really used, so I set it as
    % equal to the zero vector. Hopefully this doesn't fuck anything up

else
    
    RocketCGRelBaseVelVec = [0,0,0]';
    RocketCGRelBaseAccVec = [0,0,0]';
    
end
end