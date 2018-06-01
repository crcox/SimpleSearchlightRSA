function bs_rank_map = RankTransformWithPermDist(real_map, perm_maps, varargin)
    % perm_maps should be a matrix, with a row for every nonzero voxel in
    % real_map (or in mask, if provided). real_map can be provided as either a
    % 3D array or a vector. If real_map is a vector and a mask is provided, the
    % output will be 3D, filling in the mask in columnwise order. If real_map
    % is a vector and a mask is not provided, the output will also be a vector.
    p = inputParser();
    addRequired(p, 'real_map');
    addRequired(p, 'perm_maps');
    addOptional(p, 'mask', []);
    addParameter(p, 'RealShouldBeHigher', false);
    parse(p, real_map, perm_maps, varargin{:});

    mask = p.Results.mask;
    if isvector(real_map)
        real_map_masked_vec = real_map;
    else
        if isempty(p.Results.mask)
            mask = abs(real_map) > 0;
        end
        real_map_masked_vec = real_map(mask);
    end

    if p.Results.RealShouldBeHigher
        bs_rank_vec = sum(bsxfun(@gt, real_map_masked_vec, perm_maps), 2);
    else
        bs_rank_vec = sum(bsxfun(@lt, real_map_masked_vec, perm_maps), 2);
    end

    if isempty(mask)
        bs_rank_map = bs_rank_vec;
    else
        bs_rank_map = zeros(size(mask));
        bs_rank_map(mask) = bs_rank_vec;
    end
end
