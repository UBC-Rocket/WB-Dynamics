clc;
clear;
SRC_DIR = "../src";
% add source code folder so that the test cases can find the functions
% to test.
addpath(SRC_DIR);

curr_dir = dir(pwd);
% First two entries are not folders that contain tests
folders = find(vertcat(curr_dir.isdir));
%% Run tests
runtests(pwd);
for i = 3:length(folders)
    runtests(curr_dir(folders(i)).name);
end
%runtests("coordinate_tests");
%runtests("lin_alg_tests");
%runtests("recovery_tests");