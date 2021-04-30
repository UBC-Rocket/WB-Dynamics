# WB Monte Carlo Trajectory Simulation
MATLAB Simulation Using Latin Hypercube Sampling Method To Compute A Trajectory Distribution

### Usage
1. Follow the template `input/template.csv` to create a file called `input/input.csv` and fill in the `Value` column withe the appropriate values. The units are listed in the column `Units`. Tip: Easy way to create the new file is running `cp input/template.csv input/input.csv` in the root directory of this project.
2. Running `src/run_nominal_trajectory.m` will run the simulation once with no variation of input variables. Running `src/run_monte_carlo` will run the simulation multiple times with variations in input variables.
3. If running the Monte Carlo simulation, the output values will be stored in `output/output.csv`.

### Tests
Test suite can be run using the `tests/run_tests.m` file. Make sure that after making any changes, run the tests to see if they still pass. Sometimes if the function is significantly updated, the respective test suite may need to be updated too.

### Looking for Launch Stability Content? 
Link is [here](https://github.com/Ivan-Bao/WB-Dynamics/tree/main)
but will be later moved as a seperate project with a seperate repository
