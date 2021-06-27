clear;
clc;

proj = matlab.project.rootProject;
test_path = fullfile(proj.RootFolder, "tests");

curr_dir = dir(test_path);

suite = matlab.unittest.TestSuite.fromFolder(test_path, 'IncludingSubfolders', true);
result = run(suite);
disp(result);