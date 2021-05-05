function u = create_uncertainty(var,rand)
%CREATE_UNCERTAINTY Creates a struct holding the variability and randomness
%   The struct contains the fields `var` which holds the scaling factor and
%   `rand` which is meant to be a random number between -1 and 1.
%   The fields are meant to be used in this manner. Given a value of `N`
%   the input values would be used to apply a variation on `N` using the
%   formula: `N_final` = `N` + `N` * var * rand
%
%   Input:
%       var  :  number between 0 and 1 which represents the percentage that
%               a value should be scaled.
%       rand :  number between -1 and 1 (should be random)
%   Ouput:
%       u    :  a struct with the fields var and rand
%
    u.var = var;
    u.rand = rand;
end

