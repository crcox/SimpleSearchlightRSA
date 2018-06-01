%% Load dependencies
addpath('C:\Users\mbmhscc4\MATLAB\Toolboxes\spm12');
addpath('C:\Users\mbmhscc4\GitHub\DARTEL_Support');

%% Setup
project_root = 'C:\Users\mbmhscc4\MATLAB\MRI\SoundPicture\SimpleSearchlightRSA';
results_root = fullfile(project_root, 'results');
data_root = 'D:\MRI\SoundPicture\data';
darteldata_root = 'D:\MRI\SoundPicture\data\DARTEL';

OriginalT1 =  fullfile(darteldata_root, {
    'MD106_050913_T1W_IR_1150_SENSE_3_1.img,1'
    'MD106_050913B_T1W_IR_1150_SENSE_3_1.img,1'
    'MRH026_201_T1W_IR_1150_SENSE_3_1.img,1'
    'MRH026_202_T1W_IR_1150_SENSE_3_1.img,1'
    'MRH026_203_T1W_IR_1150_SENSE_3_1.img,1'
    'MRH026_204_T1W_IR_1150_SENSE_3_1.img,1'
    'MRH026_205_T1W_IR_1150_SENSE_3_1.img,1'
    'MRH026_206_T1W_IR_1150_SENSE_3_1.img,1'
    'MRH026_207_T1W_IR_1150_SENSE_3_1.img,1'
    'MRH026_208_T1W_IR_1150_SENSE_3_1.img,1'
    'MRH026_209_T1W_IR_1150_SENSE_3_1.img,1'
    'MRH026_210_T1W_IR_1150_SENSE_3_1.img,1'
    'MRH026_211_T1W_IR_1150_SENSE_3_1.img,1'
    'MRH026_212_T1W_IR_1150_SENSE_3_1.img,1'
    'MRH026_213_T1W_IR_1150_SENSE_3_1.img,1'
    'MRH026_214_T1W_IR_1150_SENSE_3_1.img,1'
    'MRH026_215_T1W_IR_1150_SENSE_3_1.img,1'
    'MRH026_216_T1W_IR_1150_SENSE_3_1.img,1'
    'MRH026_217_T1W_IR_1150_SENSE_3_1.img,1'
    'MRH026_218_T1W_IR_1150_SENSE_3_1.img,1'
    'MRH026_219_T1W_IR_1150_SENSE_3_1.img,1'
    'MRH026_220_T1W_IR_1150_SENSE_3_1.img,1'
    'MRH026_221_T1W_IR_1150_SENSE_3_1.img,1'
});
Dartel_FlowFields  = spm_file( ...
    spm_file(OriginalT1, 'basename'), ...
    'prefix', 'u_rc1', ...
    'suffix', '_Template', ...
    'ext', '.nii');
if ~spm_existfile(Dartel_FlowFields{1})
    disp('Flowfields not found in results directory. Copying them into place...');
    unzip('D:\MRI\SoundPicture\data\SoundPicture_DartelFlowfields.zip', permdir_nifti);
end

C = struct( ...
    'target_label', {'semantic','semantic','visual','semantic','semantic','visual'}, ...
    'modality', {'audio','visual','visual','audio','visual','visual'}, ...
    'condition', {'final','final','final','permutations','permutations','permutations'});

cd(results_root)
for i = 1:numel(C)
    disp('Running alignment protocol on:');
    disp(C(i));
    condition_root = fullfile(target_label,modality,condition);
    nifti_dir = fullfile(condition_root,'solutionmaps','nifti');
    cd(nifti_dir);
    AlignWithDartel(Dartel_FlowFields, C(i).condition);
    cd(results_root);
end

%% Move back to the root dir

% %% Apply resampling without bluring
% jobs = ApplyResample(cat(1,WarpedResults{:}), 'VoxelSize', [3,3,3], 'fwhm', [0,0,0]);
% spm_jobman('run',jobs);
% 
% %% Apply resampling with a 4 mm FWHM Gaussian blur
% jobs = ApplyResample(cat(1,WarpedResults{:}), 'VoxelSize', [3,3,3], 'fwhm', [4,4,4]);
% spm_jobman('run',jobs);
% 
% %% Move back to the root dir
% cd(condition_root);
