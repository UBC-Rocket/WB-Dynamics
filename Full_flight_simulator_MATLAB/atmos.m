function varargout = atmos(h)
%  ATMOS  Find gas properties in the 1976 Standard Atmosphere.
%   [rho,a,T,P] = ATMOS(h)
%
%   ATMOS by itself gives atmospheric properties at sea level on a standard day.
%
%   REQUIRES: h to be the geopotential altitude in meters
%
%   RETURN: the properties of the 1976 Standard Atmosphere at
%   geopotential altitude h.
%
%   ATMOS returns properties the same size as h and/or tOffset (P does not vary
%   with temperature offset and is always the size of h).
%
%   This model is not recommended for use at altitudes above 86 km geometric
%   height (84852 m / 278386 ft geopotential) but will attempt to extrapolate
%   above 86 km (with a lapse rate of 0°/km) and below 0.
%
%   See also ATMOSISA, ATMOSNONSTD, TROPOS,
%     DENSITYALT - http://www.mathworks.com/matlabcentral/fileexchange/39325,
%     UNITS      - http://www.mathworks.com/matlabcentral/fileexchange/38977.
%
%   [rho,a,T,P] = ATMOS(h)
%   Copyright 2015 Sky Sartorius
%   www.mathworks.com/matlabcentral/fileexchange/authors/101715
%   
%   Modified from original version by William Shen. Removed user customizable 
%   input for faster computational time for use in the ODE RocketDynamicModel
%   as the input was always the geopotential altitude in meters.
%
%   References: ESDU 77022; www.pdas.com/atmos.html

%% Constants, etc.:
%  Lapse rate Base Temp       Base Geop. Alt    Base Pressure
%   Ki (°C/m) Ti (°K)         Hi (m)            P (Pa)
D =[-0.0065   288.15          0                 101325            % Troposphere
    0         216.65          11000             22632.04059693474 % Tropopause
    0.001     216.65          20000             5474.877660660026 % Stratosph. 1
    0.0028    228.65          32000             868.0158377493657 % Stratosph. 2
    0         270.65          47000             110.9057845539146 % Stratopause
    -0.0028   270.65          51000             66.938535373039073% Mesosphere 1
    -0.002    214.65          71000             3.956392754582863 % Mesosphere 2
    0         186.94590831019 84852.04584490575 .373377242877530];% Mesopause
% Constants:
rho0 = 1.225;   % Sea level density, kg/m^3
gamma = 1.4;
g0 = 9.80665;   %m/sec^2
K = D(:,1);	%°K/m
T = D(:,2);	%°K
H = D(:,3);	%m
P = D(:,4);	%Pa
R = P(1)/T(1)/rho0; %N-m/kg-K
% Ref:
%   287.05287 N-m/kg-K: value from ESDU 77022
%   287.0531 N-m/kg-K:  value used by MATLAB aerospace toolbox ATMOSISA
%% Convert from geometric altitude to geopotental altitude, if necessary.
hGeop = h;
%% Calculate temperature and pressure:
% Pre-allocate.
temp = zeros(size(h));
press = temp;
nSpheres = size(D,1);
for i = 1:nSpheres
    % Put inputs into the right altitude bins:
    if i == 1 % Extrapolate below first defined atmosphere.
        n = hGeop <= H(2);
    elseif i == nSpheres % Capture all above top of defined atmosphere.
        n = hGeop > H(nSpheres);
    else 
        n = hGeop <= H(i+1) & hGeop > H(i);
    end
    
    
    if K(i) == 0 % No temperature lapse.
        temp(n) = T(i);
        press(n) = P(i) * exp(-g0*(hGeop(n)-H(i))/(T(i)*R));
    else
        TonTi = 1 + K(i)*(hGeop(n) - H(i))/T(i);
        temp(n) = TonTi*T(i); 
        press(n) = P(i) * TonTi.^(-g0/(K(i)*R)); % Undefined for K = 0.
    end
end
%% Populate the rest of the parameters:
rho = press./temp/R;
a = sqrt(gamma * R * temp);

varargout = {rho,a,temp,press};