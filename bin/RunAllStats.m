function [] = RunAllStats(condition_dir, subject_set, blur, varargin)
    p = inputParser();
    addRequired(p, 'condition_dir', @ischar);
    addRequired(p, 'subject_set', @isnumeric);
    addRequired(p, 'blur', @isscalar);
    addParameter(p, 'pth_voxel_level', 0.01, @isscalar);
    addParameter(p, 'pth_fwer', 0.05, @isscalar);
    addParameter(p, 'RealShouldBeHigher', false, @islogical);
    addParameter(p, 'nBSPermutations', 10000, @isscalar);
    parse(p, condition_dir, subject_set, blur, varargin{:});

    RealShouldBeHigher = p.Results.RealShouldBeHigher;
    nperm = p.Results.nBSPermutations;
    pth_voxel_level = p.Results.pth_voxel_level;
    pth_fwer = p.Results.pth_fwer;

    %% Setup
    mask_path = fullfile('data','xb0_mask_group_cortex.nii');
    final_dir = fullfile(condition_dir,'final','solutionmaps','nifti');
    permutations_dir = fullfile(condition_dir,'permutations','solutionmaps','nifti');
    stats_dir = fullfile(condition_dir,'stats');
    rank_dir = fullfile(stats_dir, 'rank', sprintf('b%d',blur));
    if ~exist(rank_dir, 'dir')
        mkdir(rank_dir);
    end
    bootstrap_dir = fullfile(stats_dir, 'bootstrap', sprintf('b%d',blur));
    if ~exist(bootstrap_dir, 'dir')
        mkdir(bootstrap_dir);
    end
    % Pre-specify the selections for each of `nperm` samples
    % -------
    fname = 'BS_SELECTIONS.mat';
    fpath = fullfile(bootstrap_dir, fname);
    if exist(fpath, 'file')
        load(fpath);
    else
        BS_SELECTIONS = randi(100, numel(subject_set), nperm);
        save(fpath, 'BS_SELECTIONS');
    end

    %% Load Group Cortical Mask
    tmp = load_nii(mask_path);
    mask_group_cortex = tmp.img > 0;

    %% Load NIFTI headers for results
    NiftiHeaders = struct('subject', num2cell(subject_set), 'filename', [], 'hdr', []);
    for i = 1:numel(subject_set)
        s = subject_set(i);
        fname = sprintf('xb%d_w%02d_O+orig.nii', blur, s);
        fpath = fullfile(final_dir, fname);
        NiftiHeaders(i).filename = fpath;
        NiftiHeaders(i).hdr = load_nii_hdr(fpath);
    end

    %% Load Real and Permuted solutions
    [real_maps, permutation_maps] = LoadRealAndPermuted(final_dir,permutations_dir,subject_set,blur);
    rank_maps = zeros(size(real_maps));
    if p.Results.RealShouldBeHigher
        rank_maps(:,:,:,i) = sum(bsxfun(@gt, real_maps(:,:,:,i), permutation_maps{i}),4);
    else
        rank_maps(:,:,:,i) = sum(bsxfun(@lt, real_maps(:,:,:,i), permutation_maps{i}),4);
    end

    %% Write the mean data to NIFTI
    real_mean = mean(real_maps, 4);
    fname = sprintf('xb%d_mean.nii', blur);
    fpath = fullfile(final_dir, fname);
    hdr = NiftiHeaders(1).hdr;
    WriteToNifti( hdr, fpath, real_mean, [], 'float');

    %% Write the rank data to NIFTI
    for i = 1:numel(subject_set)
        s = subject_set(i);
        fname = sprintf('xb%d_w%02d_rank.nii', blur, s);
        fpath =  fullfile(rank_dir, fname);
        z = [NiftiHeaders.subject] == s;
        hdr = NiftiHeaders(z).hdr;
        WriteToNifti( hdr, fpath, rank_maps(:,:,:,i) - 50, [], 'int');
    end

    %% Generate the bootstrapped group-averaged permutation maps
    fprintf('Generate %d group-averaged permutation maps... \n', nperm);
    P = GenerateBSGroupAvgPermMaps(permutation_maps, mask_group_cortex, BS_SELECTIONS);

    % This will be a large matrix, so it needs to be saved in a special format
    fpath = fullfile(stats_dir,'bootstrap',sprintf('b%d',blur),'P.mat');
    save(fpath,'P','-v7.3');

    %% Rank the true mean value at each voxel against the permutation distribution.
    % -------
    % Because the value corresponds to error, lower is better. I am counting
    % the evidence in favor of the alternative hypothesis (higher values will
    % correspond with lower p-values).
    bs_rank_map = RankTransformWithPermDist(real_mean, P, mask_group_cortex, 'RealShouldBeHigher', RealShouldBeHigher);

    % Write the bootstrapped data to NIFTI
    % -------
    fname = sprintf('xb%d_bs10000.nii', blur);
    fpath = fullfile(bootstrap_dir, fname);
    hdr = NiftiHeaders(1).hdr;
    WriteToNifti( hdr, fpath, bs_rank_map .* mask_group_cortex, [], 'int');
    save(fullfile(bootstrap_dir, 'bs_rank_map.mat'),'bs_rank_map');
    save(fullfile(bootstrap_dir, 'mask_group_cortex.mat'),'mask_group_cortex');

    %% Determine cluster size to achieve FWER p < 0.05
    % -------
    disp('Cluster size simulation ... ');
    [k, ClustSizeStats] = ClusterSizeSimulation(P, mask_group_cortex, pth_voxel_level, pth_fwer, p.Results.RealShouldBeHigher);
    save(fullfile(bootstrap_dir, 'ClustSizeStats.mat'),'-struct','ClustSizeStats');
    textprogressbar(' Done.');

    plot(ClustSizeStats.ReverseCumulative(1:max(k+5,20)));
    a = gca();
    line(a.XLim, [0.05, 0.05], 'LineStyle','--');
    line([k,k], a.YLim, 'Color', 'red');
    text(k+0.5,0.5,num2str(k));
    title({'Cluster size reverse cumulative probability distribution';sprintf('voxel p < %.3f', pth_voxel_level)});

    %% Write the thresholded bootstrapped ranks to NIFTI
    bs_rank_map_fwer = ApplyClusterThreshold(bs_rank_map, mask_group_cortex, k, pth_voxel_level);

    if pth_voxel_level == 0.01
        fname = sprintf('xb%d_bs10000_p01_c%d.nii', blur, k);
    else
        fname = sprintf('xb%d_bs10000_p05_c%d.nii', blur, k);
    end
    fpath = fullfile(bootstrap_dir, fname);
    hdr = NiftiHeaders(1).hdr;
    WriteToNifti( hdr, fpath, bs_rank_map_fwer, [], 'int');
end
