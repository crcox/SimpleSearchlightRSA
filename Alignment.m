%% Load dependencies
addpath('C:\Users\mbmhscc4\MATLAB\Toolboxes\spm12');
addpath('C:\Users\mbmhscc4\GitHub\DARTEL_Support');
addpath('C:\Users\mbmhscc4\MATLAB\MRI\SoundPicture\SimpleSearchlightRSA\bin');

%% Setup
project_root = 'C:\Users\mbmhscc4\MATLAB\MRI\SoundPicture\SimpleSearchlightRSA';
results_root = fullfile('D:\MRI\SoundPicture','results', 'SimpleSearchlightRSA', 'LowRankStructure');
data_root = 'D:\MRI\SoundPicture\data';
darteldata_root = 'D:\MRI\SoundPicture\data\DARTEL';

C = struct( ...
    'target_label', {'semantic','semantic','visual','semantic','semantic','visual'}, ...
    'modality', {'audio','visual','visual','audio','visual','visual'}, ...
    'condition', {'final','final','final','permutations','permutations','permutations'});

%% Perform alignment
cd(results_root)
for i = 3:numel(C)
    disp('Running alignment protocol on:');
    disp(C(i));
    condition_root = fullfile(C(i).target_label,C(i).modality,C(i).condition);
    nifti_dir = fullfile(pwd,condition_root,'solutionmaps','nifti');
    
    cd(nifti_dir);
    Dartel_FlowFields = InstallFlowFields( darteldata_root, nifti_dir );
    AlignWithDartel(Dartel_FlowFields, C(i).condition);
    cd(results_root);
end
