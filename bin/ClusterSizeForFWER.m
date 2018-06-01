function [k, stats] = ClusterSizeForFWER(ClusterSizeDistribution, pth_fwer)
    % ClustSizeDistribution is a vector, where position in the vector
    % correponds to the cluster size, and the value at that position indicates
    % the frequency of that cluster size over simulations.
    Probability = ClusterSizeDistribution/sum(ClusterSizeDistribution);
    ReverseCumulative = flipud(cumsum(flipud(Probability(:))));
    k = find(ReverseCumulative <= pth_fwer, 1);
    stats = struct(...
        'Count', ClusterSizeDistribution, ...
        'Probability', Probability, ...
        'ReverseCumulative', ReverseCumulative);
end
