windx = 0;
windy = -10;

output = zeros(1,3);

set_param('Main_Simulink_file/windVec', 'value', '[windx,windy,0]');
scopeConfig = get_param('Main_Simulink_file/Z-data','ScopeConfiguration');
scopeConfig.DataLogging = true;
scopeConfig.DataLoggingSaveFormat = 'Dataset';
simOut = sim('Main_Simulink_file');
z = simOut.ScopeData{1}.Values.Data;