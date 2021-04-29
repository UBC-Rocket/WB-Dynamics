function samples = create_sample(num_of_samples, variable_names, errors, types)
%CREATE_SAMPLES Latin hypercube samples variables
%   Input:
%       num_of_samples: Total number of samples to take  
%       variable_names: names of variables as a string to sample from. Size
%           should be (number of variables, 1) of chars
%       errors: percentage errors of each variable. Size should be
%           (1, number of variables)
%       types:  Types of distribution of each variable. Size should be
%           (number of variables, 1) of chars
    [nvars,~] = size(variable_names);
    xmin = -1*ones(1, nvars);
    xmax = 1*ones(1, nvars);
    xmean = (xmax + xmin)/2;
    xsd = (xmax - xmin)/6;
    %s = sampling.latin_hs(xmin, xmax, types, num_of_samples);
    s = sampling.latin_hs_norm(xmean, xsd, num_of_samples, nvars);
    % Preallocate struct array
    pre_struct = sampling.create_sample_struct(...
        variable_names,...
        zeros(1,nvars),...
        zeros(1,nvars));
    samples = repmat(pre_struct,1,num_of_samples);
    for i = 1:num_of_samples
        samples(i) = sampling.create_sample_struct(...
            variable_names,...
            errors,...
            s(i,:));
    end
end
