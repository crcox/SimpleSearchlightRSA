addpath('C:\Users\mbmhscc4\MATLAB\src\WholeBrain_MVPA\dependencies\nifti\');
addpath('C:\Users\mbmhscc4\MATLAB\MRI\SoundPicture\SimpleSearchlightRSA\bin');

datadir = 'D:\MRI\SoundPicture\data\MAT\avg\bystudy';
metapath = fullfile(datadir, 'metadata_avg_wLowRank.mat');
tmp = load(metapath, 'metadata');
metadata = tmp.metadata;
[metadata.datadir] = deal(datadir);

permpath = fullfile(datadir, 'PERMUTATION_STRUCTURE.mat');
tmp = load(permpath, 'PERMUTATION_INDEX');
permutations = tmp.PERMUTATION_INDEX;

datadir_nii = 'D:\MRI\SoundPicture\data\raw';
niftiheaders = LoadNiftiHeaders( datadir_nii );

outdirs = MakeOutputDirectories(fullfile('D:\MRI\SoundPicture\','results','SimpleSearchlightRSA','LowRankStructure'));
for i = 1:numel(outdirs);
    outdirs(i).target = sprintf('%s_lowrank', outdirs(i).target);
end

%% Semantic structure, visual stimuli
target_label = 'semantic_lowrank';
modality = 'visual';
radius = 6;
spearman = true; % rank transform RMDs before correlating
fprintf('Running searchlights (r=%d) for %s targets on %s data (Spearman=%d) ...\n', radius, target_label, modality, spearman);
RunSearchlightAnalysis( metadata, permutations, niftiheaders, target_label, modality, spearman, radius, outdirs );
fprintf('Done.');

%% Semantic structure, audio stimuli
target_label = 'semantic_lowrank';
modality = 'audio';
radius = 6;
spearman = true; % rank transform RMDs before correlating
fprintf('Running searchlights (r=%d) for %s targets on %s data (Spearman=%d) ...\n', radius, target_label, modality, spearman);
RunSearchlightAnalysis( metadata, permutations, niftiheaders, target_label, modality, spearman, radius, outdirs );
fprintf('Done.');

%% visual structure, visual stimuli
target_label = 'visual_lowrank';
modality = 'visual';
radius = 6;
spearman = true; % rank transform RMDs before correlating
fprintf('Running searchlights (r=%d) for %s targets on %s data (Spearman=%d) ...\n', radius, target_label, modality, spearman);
RunSearchlightAnalysis( metadata, permutations, niftiheaders, target_label, modality, spearman, radius, outdirs );
fprintf('Done.');
