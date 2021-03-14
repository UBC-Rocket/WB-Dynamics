# WB Monte Carlo Trajectory Simulation
MATLAB Simulation Using Latin Hypercube Sampling Method To Compute A Trajectory Distribution

### Usage
1. Follow the template `resources/spaceshot_cd_data_template.csv` to create a file called `resources/spaceshot_cd_data.csv` with appropriate values. Tip: RASAero II makes this easy to do. For the column named `distribution type` use:
    - `0` for normal distribution. `max value` column value should be the value for the 99.85% interval. Similarily, `min value` column value should be the value for the 0.15% interval.
    - `1` for uniform distribution. For a uniform distribution of `a` to `b`, `max value` column value should correspond to `b` and `min value` should correspond to `a`.
2. Follow the template `resources/rocket_specs_template.csv` to create a file called `resources/rocket_specs.csv` with appropriate values.
3. Running `MCLandingDispersion.m` will run the simulation for a default of 10000 times.
4. The landing points value will be stored in `output/landing_points.csv` once all the iterations have been run.

### Looking for Launch Stability Content? 
Link is [here](https://github.com/Ivan-Bao/WB-Dynamics/tree/main)
but will be later moved as a seperate project with a seperate repository
