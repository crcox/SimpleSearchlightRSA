function [ RDMs ] = SetupTargetAndPermutedRDMs( T, P, rf, varargin )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
% NB: I stored the targets as similarity matrices. To adhere to the RDM
% convention, I flip them.
    p = inputParser();
    addRequired(p, 'T');
    addRequired(p, 'P');
    addRequired(p, 'rf');
    addParameter(p, 'rank', false, @islogical);
    parse(p, T, P, rf, varargin{:});
    
    nrow = nnz(rf);
    ndist = (nrow^2 - nrow) / 2;
    
    t = T.target(rf, rf);
    
    RDMs = zeros(ndist, size(P,2)+1);
    ltri = tril(true(nrow), -1);
    RDMs(:,1) = 1-t(ltri);
    for j = 1:100
        pix = P(:,j);
        tp_unfiltered = T.target(pix, pix);
        tp = tp_unfiltered(rf,rf);
        if p.Results.rank
            [~, ~, RDMs(:,j+1)] = unique(1-tp(ltri));
        else
            RDMs(:,j+1) = 1-tp(ltri);
        end
    end
    RDMs = zscore(RDMs);
end