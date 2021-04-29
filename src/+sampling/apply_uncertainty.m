function value_final = apply_uncertainty(value, value_name, uncertainties)
%APPLY_UNCERTAINTY Applies uncertainties to a variable.
%   Formula used: V_F = V_N + (V_N * var) * rand where V_F is the final
%   variable value, V_N is the nominal variable value, var is the percent
%   uncertainty and rand is a randomly generated value from -1 to 1 based
%   on a probability distribution.
    var = uncertainties.(strcat(value_name, "_err"));
    rand = uncertainties.(strcat(value_name, '_fac'));
    
    value_final = value + (value * var) * rand;
end

