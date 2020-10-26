function Mass = ComputeRocketMass(Time,BurnTime,LoadMass,PropFlowRate)
if Time <= BurnTime
 Mass = LoadMass - PropFlowRate*Time;
else
 Mass = LoadMass - PropFlowRate*BurnTime;
end