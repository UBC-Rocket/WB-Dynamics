function MisalignMoment = thrustMisAlignmentMoment(Rocket)
MisalignMoment = cross(Rocket.ThrustForceVec,Rocket.ThrustOffset);

