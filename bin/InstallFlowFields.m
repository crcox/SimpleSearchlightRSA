function [ Dartel_FlowFields ] = InstallFlowFields( darteldata_src, darteldata_dest )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    OriginalT1 =  fullfile(darteldata_src, {
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
        unzip(fullfile(darteldata_src, '..', 'SoundPicture_DartelFlowfields.zip'), darteldata_dest);
    end
end

