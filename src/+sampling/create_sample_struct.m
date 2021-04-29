function s = create_sample_struct(names, errors, scaling_factor)
%CREATE_SAMPLE_STRUCT Creates a structure to hold variable errors and
%scaling factors.
%   Input:
%       names: names of variables as a string to sample from. Size
%           should be (number of variables, 1) of chars 
%       errors: percentage errors of each variable. Size should be
%           (1, number of variables)
%       scaling_factor: random number that represents how much the value
%           should be scaled. Size should be (1, number of variables).
    [nvars,~] = size(names);
    for i = 1:nvars
        s.(strcat(names(i,:), '_err')) = errors(i);
        s.(strcat(names(i,:), '_fac')) = scaling_factor(i);
    end
end

