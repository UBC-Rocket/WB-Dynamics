%The output of this program is a 2D matrix, the first layer is all the
%x-coordinates of the landing spot, and the second layer is all the
%y-coordinates. The center of the matrix is the zero-wind landing spot
%(sort of like the "zero input response" in signal processing) And you
%would expect the center row of the layer 2 matrix would be all zero, since
%for no wind in y-direction, no deviation is expected in y-coordinate when
%the rocket lands.

%You can read the matrix as if it's a 2d graph, center at (N,N) entry. It's
%x and y index are wind vector components and the values at these indices
%are the coordinates of the corresponding expected landing spot.



N = 3; % (size of the simulation)/2 -1, it determines the size of the matrix

landingSpots = zeros(2*N+1, 2*N+1)-1; 
%first layer of matrix for storing x-coordinates of the landing spot

landingSpots(:,:,2) = zeros(2*N+1, 2*N+1)-1;
%second layer of matrix for storing y-coordinates of the landing spot

%If the deviation is too big to be considered, the coordinates will be
%(-1,-1)

maxDeviation = 10000000.0; %Define a max allowed deviation from (0,0)

xIncrement = 0.05; %increment of wind velocity between each iteration
yIncrement = 0.2;
noWindReference = [0,0]; %Set a reference such that this is the 
%landing spot when there's no wind, will be computed before comparison.

%First compute a landing spot when there's no wind, as a reference. 
%It is assumed ideally there would be no wind so the trajectory and landing
%spot are in the most predictable state, and the landing spot is at the
%center of the desired landing zone. To define a center reference
%otherwise, comment out this chunk of code and redefine noWindReference.
windx = 0;
windy = 0;
set_param('Main_Simulink_file/windVec', 'value', '[windx,windy,0]');
simOut = sim('Main_Simulink_file');
zSimData = simOut.zData;
xSimData = simOut.xData;
ySimData = simOut.yData;
groundIDX = calcGroundIndex(zSimData);
noWindReference(1) = xSimData(1,1,groundIDX);
noWindReference(2) = ySimData(1,1,groundIDX);
%we could also manually define a center point, for example, a designated
%landing area and see what wind condition will blow the rocket too far off

% To get the relative coordinates from the set reference, one could subtract
% the reference landing point coordinates from each entry of the result
% matrix. This is equivalent to setting the reference landing point as the
% origin.
% Between each row, the y-component of the wind vector varies
% Between each column, the x-component of the wind vector varies


for j = 1:N
    for i = 1:N %First quarter of the area, I have to split this area into
        %4 quadrants and compute from the center each time, so the results
        %starts from the least deviations and will not terminate the loop
        %prematurely. You could think this being the first quadrant of a 2D
        %graph.
        windx = xIncrement*i;
        windy = yIncrement*j;
        set_param('Main_Simulink_file/windVec', 'value', '[windx,windy,0]');
        simOut = sim('Main_Simulink_file');
        zSimData = simOut.zData;
        xSimData = simOut.xData;
        ySimData = simOut.yData;
        groundIDX = calcGroundIndex(zSimData);
        landingSpots(j+N+1,i+N+1) = xSimData(1,1,groundIDX);
        landingSpots(j+N+1,i+N+1,2) = ySimData(1,1,groundIDX);
        if sqrt((landingSpots(j+N+1,i+N+1)- noWindReference(2))^2 +...
                (landingSpots(j+N+1,i+N+1,2) - noWindReference(2))^2) > maxDeviation
            break;%If the computed landing spot deviates too much from
                    %the chosen center (i.e. no wind reference landing spot)
                    %Then it breaks the loop to avoid unnecessary
                    %computation.
        end
    end
    for i = 0:-1:-N %Second quadrant
        windx = xIncrement*i;
        windy = yIncrement*j;
        set_param('Main_Simulink_file/windVec', 'value', '[windx,windy,0]');
        simOut = sim('Main_Simulink_file');
        zSimData = simOut.zData;
        xSimData = simOut.xData;
        ySimData = simOut.yData;
        groundIDX = calcGroundIndex(zSimData);
        landingSpots(j+N+1,i+N+1) = xSimData(1,1,groundIDX);
        landingSpots(j+N+1,i+N+1,2) = ySimData(1,1,groundIDX);
        if sqrt((landingSpots(j+N+1,i+N+1)- noWindReference(2))^2 +...
                (landingSpots(j+N+1,i+N+1,2) - noWindReference(2))^2) > maxDeviation
            break;
        end
    end
    
end
for j = 0:-1:-N

    for i = 0:-1:-N %Third quadrant
        windx = xIncrement*i;
        windy = yIncrement*j;
        set_param('Main_Simulink_file/windVec', 'value', '[windx,windy,0]');
        simOut = sim('Main_Simulink_file');
        zSimData = simOut.zData;
        xSimData = simOut.xData;
        ySimData = simOut.yData;
        groundIDX = calcGroundIndex(zSimData);
        landingSpots(j+N+1,i+N+1) = xSimData(1,1,groundIDX);
        landingSpots(j+N+1,i+N+1,2) = ySimData(1,1,groundIDX);
        if sqrt((landingSpots(j+N+1,i+N+1)- noWindReference(2))^2 +...
                (landingSpots(j+N+1,i+N+1,2) - noWindReference(2))^2) > maxDeviation
            break; 
        end
        
        
        
    end
    for i = 1:N   %Fourth quadrant
        windx = xIncrement*i;
        windy = yIncrement*j;
        set_param('Main_Simulink_file/windVec', 'value', '[windx,windy,0]');
        simOut = sim('Main_Simulink_file');
        zSimData = simOut.zData;
        xSimData = simOut.xData;
        ySimData = simOut.yData;
        groundIDX = calcGroundIndex(zSimData);
        landingSpots(j+N+1,i+N+1) = xSimData(1,1,groundIDX);
        landingSpots(j+N+1,i+N+1,2) = ySimData(1,1,groundIDX);
        if sqrt((landingSpots(j+N+1,i+N+1)- noWindReference(2))^2 +...
                (landingSpots(j+N+1,i+N+1,2) - noWindReference(2))^2) > maxDeviation
            break;
        end
    end
end



function idx = calcGroundIndex(x) %Computes the index point where height 
                                    %reaches zero from the data array.
    for k = 1:length(x)
        if x(k) < 0
            idx = k;
            break;
        end       
    end
end