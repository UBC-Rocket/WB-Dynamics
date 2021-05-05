function value_final = apply_uncertainty(value, uncertainty)
%APPLY_UNCERTAINTY Applies uncertainties to a variable.
%   Formula used: V_F = V_N + (V_N * var) * rand where V_F is the final
%   variable value, V_N is the nominal variable value, var is the percent
%   uncertainty and rand is a randomly generated value from -1 to 1 based
%   on a probability distribution.
%
%   Input:
%       value       : number to apply uncertainty to
%       uncertainty : struct that holds the values `var` and `rand`
%   Output:
%       value_final : original input value scaled using the uncertainty
%
    value_final = value + (value * uncertainty.var) * uncertainty.rand;
end

