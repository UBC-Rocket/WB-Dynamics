function s = latin_hs(xmin, xmax, xtype, nsample)
%LATIN_HYPERCUBE Latin hypercube sampling for a total of length of xtype
%samples where the distribution to sample from is specified by xtype.
%   Input:
%       xmin  : min value of data (-3 sigma for normal distribution). Size
%               should be (1, number of variables to sample).
%       xmax  : max value of data (3 sigma for normal distribution). Size
%               should be (1, number of variables to sample).
%       xtype : Distribution type of each variable. "norm" for normal
%               distribution and "unif" for uniform distribution. Size
%               should be (number of variables to sample, 1).
%   Output:
%       s     : random sample of the variables. Size is 
%               (nsample, number of variables to sample)
    [hmin, wmin] = size(xmin);
    [hmax, wmax] = size(xmax);
    [htype, ~] = size(xtype);
    if (hmin == hmax) && (wmin == wmax) && (wmin == htype)
        nvar = length(xmin);
        ran = zeros(nsample, nvar);
        for i = 1:nvar
            if strcmp(xtype(i,:), 'norm')
                ran(:,i) = randn(nsample,1);
            elseif strcmp(xtype(i,:), 'unif')
                ran(:,i) = rand(nsample,1);
            else
                error("Error. \nOnly 'norm' and 'unif' allowed, given %s", xtype(i));
            end
        end
        s = zeros(nsample, nvar);
        xmean = (xmin + xmax)/2; % Mean is just average of min and max
        xsd = (xmax - xmin)/6; % Difference between max and mean is 3 sigma
        for j = 1:nvar
            idx = randperm(nsample);
            P = (idx' - ran(:,j)) / nsample;
            % At this point we know xtype must contain either 'norm' or
            % 'unif' because otherwise an error would have been thrown.
            if strcmp(xtype(j,:), 'norm')
                s(:,j) = xmean(j) + sampling.ltqnorm(P).* xsd(j);
            else
                s(:,j) = xmin(j) + P.* (xmax(j)-xmin(j));
            end
        end
    else
        error('Error. xmin, xmax, xtype must be of the same size.');
    end
end

