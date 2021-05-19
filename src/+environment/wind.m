function wind_vec = wind(h, wind_dir, wind_speed_uncertainty)
    % Wind speed model obtained from here: http://www.intercomms.net/AUG03/content/struzak1.php
    % specifically figure 1.
    % Essentially for altitudes below 110 km, the speeds are linearly
    % interpolated using their altitude range. For altitudes 110 km and
    % greater, a asymptotically approaching 0 m/s as height approaches
    % infinity is used

    WIND_VALS = [
    %   Altitude    Base speed  Gradient
    %   (m)         (m/s)       (s^-1)
        0           5            0.00150
        10000       20          -0.00200   
        20000       0            0.00133     
        50000       40           0.00125  
        70000       65          -0.00325
        90000       0            0.00370
        100000      37           0.00270
        110000      10           0
    ];

    % find altitude range
    low = 1;
    high = size(WIND_VALS, 1);

    if h >= WIND_VALS(high,1)
        low = high;
        wind_speed_nominal = 10*exp(WIND_VALS(low,1) - h);
    else
        while low < high - 1
            partition = floor((low + high)/2);
            if h < WIND_VALS(partition,1)
                high = partition;
            else
                low = partition;
            end
        end
        wind_speed_nominal = WIND_VALS(low,2) + WIND_VALS(low,3)*(h - WIND_VALS(low,1));
    end
    wind_speed_final = sampling.apply_uncertainty(wind_speed_nominal, wind_speed_uncertainty);
    wind_dir_vec = [
        cos(wind_dir(low));
        sin(wind_dir(low));
        0
    ];
    wind_vec = wind_speed_final * wind_dir_vec;
end