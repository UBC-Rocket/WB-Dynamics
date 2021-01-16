function varargout = atmosImproved(h)
%ATMOSIMPROVED Find gas properties in the 1976 Standard Atmosphere
%   Gives atmospheric properties on a standard day from heights 0km to
%   1000km
%   
%   REQUIRES: h to be the geometric height in meters
%   RETURN: density, speed of sound, temperture and pressure at geometric
%           height of h
%   
%   For heights between 0km and 86km, the model outlined in part 1 of the
%   1976 Standard Atmosphere is used.
%   
%   For heights greater than 86km, extrapolation is done
%   
%   Modification from Sky Sartorius
%   www.mathworks.com/matlabcentral/fileexchange/authors/101715
%   
%   REFERENCES: 1976 Standard Atmosphere publication
%               https://ntrs.nasa.gov/citations/19770009539

%% CONSTANTS
% Global constants
gamma = 1.4;
g0 = 9.80665;                       % m/sec^2
RE = 6356766;                       % radius of earth in m
R = 287.053;                        % specific gas constant of air J/kg-K

% Lower atmosphere (0km to 86km)
LOWERATMOSVALS = [
%   Lapse Rate  Base Temp       Base Geop Alt       Base Pressure
%   L (°K)      T (°K)          Hgp (m)             P (Pa)
    -0.0065     288.15          0                   101325              % Troposphere
    0           216.65          11000               22632.04059693474   % Tropopause
    0.001       216.65          20000               5474.877660660026   % Stratosph. 1
    0.0028      228.65          32000               868.0158377493657   % Stratosph. 2
    0           270.65          47000               110.9057845539146   % Stratopause
    -0.0028     270.65          51000               66.938535373039073  % Mesosphere 1
    -0.002      214.65          71000               3.956392754582863   % Mesosphere 2
    0           186.94590831019 84852.04584490575   0.373377242877530   % Mesopause
];


% Calculate geopotential height
geopH = (RE * h)/(RE + h);

%% Calculate values

% find altitude range in baseGeopH table
low = 1;
high = size(LOWERATMOSVALS,1);

if geopH >= LOWERATMOSVALS(high,3)
    low = high;
else
    while low < high - 1
        partition = floor((low + high)/2);
        if geopH < LOWERATMOSVALS(partition,3)
            high = partition;
        else
            low = partition;
        end
    end
end

lapseRate = LOWERATMOSVALS(low,1);    % lapse rate
baseTemp = LOWERATMOSVALS(low,2);     % base temperature
baseGeopH = LOWERATMOSVALS(low,3);    % base geopotential height
basePress = LOWERATMOSVALS(low,4);    % base pressure

if lapseRate == 0
    temp = baseTemp;
    press = basePress*exp(-g0*(geopH - baseGeopH)/(R*baseTemp));
else
    tonTi = 1 + lapseRate*(geopH - baseGeopH)/baseTemp;
    temp = tonTi*baseTemp;
    press = basePress*tonTi^(-g0/(R*lapseRate));
end

rho = press/(R*temp);
a = sqrt(gamma*R*temp);

varargout = {rho,a,temp,press};
end

