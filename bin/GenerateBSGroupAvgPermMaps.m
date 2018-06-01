function P = GenerateBSGroupAvgPermMaps(permutation_maps, mask_group_cortex, bs_selections)
    nperm = size(bs_selections, 2);
    nsubj = numel(permutation_maps);
    bs_perm_set = zeros([size(mask_group_cortex), nsubj]);
    P = zeros(nnz(mask_group_cortex), nperm);
    nchar = 0;
    for i = 1:nperm
        fprintf(repmat('\b',1,nchar));
        nchar = fprintf('%d',i);
        ix = bs_selections(:,i);
        for j = 1:nsubj
            bs_perm_set(:,:,:,j) = permutation_maps{j}(:,:,:,ix(j));
        end
        bs_perm_mean = mean(bs_perm_set, 4);
        P(:,i) = bs_perm_mean(mask_group_cortex);
    end
    fprintf('Done.\n');
end
