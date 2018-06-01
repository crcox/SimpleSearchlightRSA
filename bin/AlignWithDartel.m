function [] = AlignWithDartel( Dartel_FlowFields, condition, results_dir)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
    %% Setup
    subject_set = 1:23;
    seed_set = 1:100;
    if nargin < 3
        results_dir = '.';
    end

    %% Apply DARTEL Flow Fields
    switch condition
        case 'final'
            Results = cell(1);
            WarpedResults = cell(1);
            Results{1} = fullfile(results_dir, arrayfun(@(x) sprintf('%02d_O+orig.nii', x), (1:23)', 'Unif', 0));
            WarpedResults{1}  = spm_file(Results{1}, 'prefix', 'w', 'path', results_dir);

        case 'permutations'
            Results = cell(numel(seed_set), 1);
            WarpedResults = cell(numel(seed_set), 1);
            for i = 1:numel(seed_set)
                r = seed_set(i);
                Results{r} = fullfile(results_dir, arrayfun(@(x) sprintf('%02d_%03d_O+orig.nii', x, r), subject_set', 'Unif', 0));
                WarpedResults{r}  = spm_file(Results{r}, 'prefix', 'w', 'path', results_dir);
            end

    end
    jobs = ApplyDartel(Dartel_FlowFields, Results);
    spm_jobman('run',jobs);


    %% CONCATENATE
    switch condition
        case 'final'
            % No concatenation, but reformat the results list
            WarpedResultsBySubject = cat(1,WarpedResults{:});

        case 'permutations'
            nsubjects = numel(subject_set);
            npermutations = numel(seed_set);
            WarpedResultsM = cell(npermutations,nsubjects);
            for i = 1:npermutations
                for j = 1:nsubjects
                    WarpedResultsM{i,j} = sprintf('w%02d_%03d_O+orig.nii', j, i);
                end
            end

            WarpedResultsBySubject = cell(nsubjects,1);
            jobs = cell(nsubjects, 1);
            for s = 1:nsubjects
                WarpedResultsBySubject{s} = sprintf('w%02d.nii', s);
                jobs{s}.spm.util.cat.vols = WarpedResultsM(:,s);
                jobs{s}.spm.util.cat.name = WarpedResultsBySubject{s};
                jobs{s}.spm.util.cat.dtype = 0;
            end
            spm_jobman('run', jobs)
    end

    %% Apply resampling without bluring
    jobs = ApplyResample(WarpedResultsBySubject, 'VoxelSize', [3,3,3], 'fwhm', [0,0,0]);
    spm_jobman('run',jobs);

    %% Apply resampling with a 4 mm FWHM Gaussian blur
    jobs = ApplyResample(WarpedResultsBySubject, 'VoxelSize', [3,3,3], 'fwhm', [4,4,4]);
    spm_jobman('run',jobs);

end

