function [y] = ApplyClusterThreshold(bs_rank_map, mask, k, pth_voxel_level, nperm)
    if nargin < 5
        nperm = 10000;
    end
    rth = ceil(nperm * (1-pth_voxel_level));
    bs_rank_map_masked = bs_rank_map .* mask;
    clusters = bwconncomp(bs_rank_map_masked > rth);
    nn = cellfun('prodofsize', clusters.PixelIdxList);
    ix = cell2mat(clusters.PixelIdxList(nn>=k)');
    y = nan(size(bs_rank_map));
    y(ix) = bs_rank_map_masked(ix);
end
