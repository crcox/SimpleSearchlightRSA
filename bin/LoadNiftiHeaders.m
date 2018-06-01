function [ MASK_ORIG_O ] = LoadNiftiHeaders( datadir_nii )
    nsubjects = 23;
    MASK_ORIG_O = struct('subject',num2cell(1:nsubjects)', 'filename', {
        fullfile(datadir_nii,'s02_rightyes','mask','nS_c1_mask_nocerebellum_O.nii')
        fullfile(datadir_nii,'s03_leftyes','mask','nS_c1_mask_nocerebellum_O.nii')
        fullfile(datadir_nii,'s04_rightyes','mask','nS_c1_mask_nocerebellum_O.nii')
        fullfile(datadir_nii,'s05_leftyes','mask','nS_c1_mask_nocerebellum_O.nii')
        fullfile(datadir_nii,'s06_rightyes','mask','nS_c1_mask_nocerebellum_O.nii')
        fullfile(datadir_nii,'s07_leftyes','mask','nS_c1_mask_nocerebellum_O.nii')
        fullfile(datadir_nii,'s08_rightyes','mask','nS_c1_mask_nocerebellum_O.nii')
        fullfile(datadir_nii,'s09_leftyes','mask','nS_c1_mask_nocerebellum_O.nii')
        fullfile(datadir_nii,'s10_rightyes','mask','nS_c1_mask_nocerebellum_O.nii')
        fullfile(datadir_nii,'s11_leftyes','mask','nS_c1_mask_nocerebellum_O.nii')
        fullfile(datadir_nii,'s12_rightyes','mask','nS_c1_mask_nocerebellum_O.nii')
        fullfile(datadir_nii,'s13_leftyes','mask','nS_c1_mask_nocerebellum_O.nii')
        fullfile(datadir_nii,'s14_rightyes','mask','nS_c1_mask_nocerebellum_O.nii')
        fullfile(datadir_nii,'s15_leftyes','mask','nS_c1_mask_nocerebellum_O.nii')
        fullfile(datadir_nii,'s16_rightyes','mask','nS_c1_mask_nocerebellum_O.nii')
        fullfile(datadir_nii,'s17_leftyes','mask','nS_c1_mask_nocerebellum_O.nii')
        fullfile(datadir_nii,'s18_rightyes','mask','nS_c1_mask_nocerebellum_O.nii')
        fullfile(datadir_nii,'s19_leftyes','mask','nS_c1_mask_nocerebellum_O.nii')
        fullfile(datadir_nii,'s20_rightyes','mask','nS_c1_mask_nocerebellum_O.nii')
        fullfile(datadir_nii,'s21_leftyes','mask','nS_c1_mask_nocerebellum_O.nii')
        fullfile(datadir_nii,'s22_rightyes','mask','nS_c1_mask_nocerebellum_O.nii')
        fullfile(datadir_nii,'s23_leftyes','mask','nS_c1_mask_nocerebellum_O.nii')
        fullfile(datadir_nii,'s24_rightyes','mask','nS_c1_mask_nocerebellum_O.nii')
    }, 'hdr', []);
    for i = 1:numel(MASK_ORIG_O)
        MASK_ORIG_O(i).hdr = load_nii_hdr(MASK_ORIG_O(i).filename);
    end
end

