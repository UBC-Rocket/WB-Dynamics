# WB Monte Carlo Trajectory Simulation
MATLAB Simulation Using Latin Hypercube Sampling Method To Compute A Trajectory Distribution

The project itself should be first loaded by double clicking the `WB-Dynamics.prj` which will load paths to find all required files.

### Shoot Single Trajectory
1. Follow the template `input/template_fields_input.csv` to create a file called `input/fields_input.csv` and fill in the `Value` column withe the appropriate values. The units are listed in the column `Units`. Tip: Easy way to create the new file is running `cp input/template.csv input/fields_input.csv` in the root directory of this project.
2. Running `src/run_nominal_trajectory.m` will run the simulation once with no variation of input variables. 

### Run Monte Carlo
1. Follow the templates `input/template_fields_input.csv` and `input/template_errors_input.csv` to create two files `input/fields_input.csv` and `input/errors_input.csv` respectively.
2. Running `src/run_monte_carlo.m` will sample the parameters and run the simulation multiple times. For testing purposes it is recommended to decrease the sample size to around 100 for a quicker run time.
3. Output results will be stored in `output/output.csv`.

### Tests
Test suite can be run using the `tests/run_tests.m` file. Make sure that after making any changes, run the tests to see if they still pass. Sometimes if the function is significantly updated, the respective test suite may need to be updated too.
