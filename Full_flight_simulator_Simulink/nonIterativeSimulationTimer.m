TIMES = 10;

singleRunTimes = zeros(TIMES,1);
windx = 10;
windy = 10;

for i = 1:TIMES
tic
set_param('Main_Simulink_file/windVec', 'value', '[windx,windy,0]');
sim('Main_Simulink_file');
singleRunTimes(i,1) = toc;
end
writematrix(singleRunTimes, "singleRunTime.csv");