clc;
clear;
SRC_DIR = "../src";
% add source code folder so that the test cases can find the functions
% to test.
addpath(SRC_DIR);
%% Run tests
runtests(pwd);
runtests("coordinate_tests");