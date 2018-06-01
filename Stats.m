addpath('C:\Users\mbmhscc4\MATLAB\Toolboxes\textprogressbar');
addpath('C:\Users\mbmhscc4\MATLAB\src\WholeBrain_MVPA\dependencies\nifti');
addpath('C:\Users\mbmhscc4\MATLAB\MRI\SoundPicture\SimpleSearchlightRSA\bin');

%% Setup
ReferenceShouldBeHigher = true;
BLUR = 0;
subject_set = 1:23;
nBSPermutations = 10000;
pth_voxel_level = 0.01;
pth_fwer = 0.05;

project_root = 'C:\Users\mbmhscc4\MATLAB\MRI\SoundPicture\SimpleSearchlightRSA';
results_root = 'D:\MRI\SoundPicture\results\SimpleSearchlightRSA\LowRankStructure';

C = struct( ...
    'target_label', {'semantic','semantic','visual'}, ...
    'modality', {'audio','visual','visual'});

%% Run Stats
for i = 1:numel(C)
    condition_dir = fullfile(results_root, C(i).target_label, C(i).modality);
    RunAllStats(condition_dir, subject_set, BLUR, ...
        'pth_voxel_level', pth_voxel_level, ...
        'pth_fwer', pth_fwer, ...
        'nBSPermutations', nBSPermutations, ...
        'RealShouldBeHigher', true);
end
