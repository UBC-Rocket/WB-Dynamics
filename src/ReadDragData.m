function [dragData] = ReadDragData()
%READDRAGDATA Parses drag coefficients and mach data from csv.
%   Reads data from `FILE_NAME` and creates a matrix
%   with first column being the mach number and the second column being the
%   corresponding measured drag coefficient.
FILE_NAME = "../resources/spaceshot_cd_data.csv";
dataMatrix = table2array(readtable(FILE_NAME, "ReadVariableNames", false));
dragData = [dataMatrix(:,1), dataMatrix(:,3)];
end

