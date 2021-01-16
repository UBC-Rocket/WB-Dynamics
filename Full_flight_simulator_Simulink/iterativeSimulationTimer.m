N = 5;

iteratedRunTimes = zeros((2*N)^2,1);

landingSpots = zeros(2*N, 2*N);
landingSpots(:,:,2) = zeros(2*N, 2*N);

increment = 1;


for i = -N:N
    for j = -N:N
        windx = increment*i;
        windy = increment*j;
        set_param('Main_Simulink_file/windVec', 'value', '[windx,windy,0]');
        tic
        simOut = sim('Main_Simulink_file');
        index = (i + N)*10 + j + N + 1;
        iteratedRunTimes(index,1) = toc;
    end
end

writematrix(iteratedRunTimes, "iteratedRunTime.csv");