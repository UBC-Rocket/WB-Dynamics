function Mass = ComputeRocketMass(Rocket,Time)
if Time <= Rocket.BurnTime
 Mass = Rocket.LoadMass - Rocket.PropFlowRate*Time;
else
 Mass = Rocket.LoadMass - Rocket.PropFlowRate*Rocket.BurnTime;
end