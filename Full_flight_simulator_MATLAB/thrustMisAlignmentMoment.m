function MisalignMoment = thrustMisAlignmentMoment(Rocket)
MisalignMoment = cross(Rocket.ThrustForceVec,Rocket.ThrustOffset);
%This function is called at RocketDynModel, Thrust damping moment section.
