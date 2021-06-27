env = environment.environment_nominal();
result = zeros(100,3);
for i = 1:10001
    altitude = (i-1)*10;
    wind_vel = environment.wind(0, altitude, env);
    
    result(i,1) = altitude;
    result(i,2) = norm(wind_vel);
    angle = atan(abs(wind_vel(2))/abs(wind_vel(1)));
    if wind_vel(1) < 0 && wind_vel(2) > 0
        angle = pi - angle;
    elseif wind_vel(1) < 0 && wind_vel(2) < 0
        angle = pi + angle;
    elseif wind_vel(1) > 0 && wind_vel(2) < 0
        angle = 2*pi - angle;
    end
    result(i,3) = angle;
end

tiledlayout(2,1);

nexttile
plot(result(:,1), result(:,2));
title('Wind speeds');
xlabel('Altitude (m)');
ylabel('Speed (m/s)');


nexttile
plot(result(:,1), rad2deg(result(:,3)));
title('Wind direction');
xlabel('Altitude (m)');
ylabel('Angle (degrees)');