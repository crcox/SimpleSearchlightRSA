function [ sldata ] = GenerateRDMsFromMRI( X, SL, varargin )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    p = inputParser();
    addRequired(p, 'X');
    addRequired(p, 'SL');
    addParameter(p, 'rank', false, @islogical);
    parse(p, X, SL, varargin{:});
    
    [nrow,ncol] = size(X);
    ndist = (nrow^2 - nrow) / 2;
    sldata = zeros(ndist,ncol);
    for j = 1:ncol
        if p.Results.rank
            [~, ~, sldata(:,j)] = unique(pdist(X(:,SL{j}), 'correlation'));
        else
            sldata(:,j) = pdist(X(:,SL{j}), 'correlation');
        end
    end
    sldata = zscore(sldata);
end

