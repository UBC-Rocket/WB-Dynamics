N = 3;

landingSpots = zeros(2*N, 2*N);
landingSpots(:,:,2) = zeros(2*N, 2*N);

increment = 1;


for i = -N:N

    for j = -N:N
        windx = increment*i;
        windy = increment*j;
        set_param('Main_Simulink_file/windVec', 'value', '[windx,windy,0]');
        simOut = sim('Main_Simulink_file');
        zSimData = simOut.zData;
        xSimData = simOut.xData;
        ySimData = simOut.yData;
        groundIDX = calcGroundIndex(zSimData);
        landingSpots(i+N+1,j+N+1) = xSimData(1,1,groundIDX);
        landingSpots(i+N+1,j+N+1,2) = ySimData(1,1,groundIDX);
        
    end
end

function idx = calcGroundIndex(x)
    for k = 1:length(x)
        if x(k) < 0
            idx = k;
            break;
        end       
    end
end