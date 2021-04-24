clc;
clear;
SRC_DIR = "../src";
% add source code folder so that the test cases can find the functions
% to test.
addpath(SRC_DIR);
%% Run tests
atmos_results = runtests("atmos_test.m");
mass_results = runtests("mass_test.m");

%% Display results
disp(atmos_results);
disp(mass_results);