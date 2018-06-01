%% Load dependencies
addpath('C:\Users\mbmhscc4\MATLAB\Toolboxes\spm12');
addpath('C:\Users\mbmhscc4\GitHub\DARTEL_Support');

%% Setup
data_root = 'D:\MRI\SoundPicture\data';
darteldata_root = fullfile(data_root, 'DARTEL');
analysis_root = 'C:\Users\mbmhscc4\MATLAB\MRI\SoundPicture\SimpleSearchlightRSA';
condition_root = fullfile( ...
    analysis_root, ...
    'avg\visual\similarity\ECoG_SoundPicture_Merge\cosine\centeredc\visual\bysession\GLMNET\visualization');
finaldir_nifti = fullfile(condition_root,'final','solutionmaps','nifti');
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
    unzip('D:\MRI\SoundPicture\data\SoundPicture_DartelFlowfields.zip', finaldir_nifti);
end

%% Move to final nifti dir
cd(finaldir_nifti);

%% Apply DARTEL Flow Fields
subject_set = 1:23;
seed_set = 1:100;
Results = cell(1);
WarpedResults = cell(1);
Results{1} = fullfile(finaldir_nifti, arrayfun(@(x) sprintf('%02d_O+orig.nii', x), (1:23)', 'Unif', 0));
WarpedResults{1}  = spm_file(Results{1}, 'prefix', 'w', 'path', finaldir_nifti);
jobs = ApplyDartel(Dartel_FlowFields, Results);
spm_jobman('run',jobs);

%% Apply resampling without bluring
jobs = ApplyResample(cat(1,WarpedResults{:}), 'VoxelSize', [3,3,3], 'fwhm', [0,0,0]);
spm_jobman('run',jobs);

%% Apply resampling with a 4 mm FWHM Gaussian blur
jobs = ApplyResample(cat(1,WarpedResults{:}), 'VoxelSize', [3,3,3], 'fwhm', [4,4,4]);
spm_jobman('run',jobs);

%% Move back to the root dir
cd(condition_root);
