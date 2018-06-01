function [ ] = RunSearchlightAnalysis( metadata, permutations, niftiheaders, target_label, modality, spearman, radius, outdirs)
    nsubjects = numel(metadata);
    if strncmpi(modality, 'audio', numel(modality))
        modality = 'audio';
        modality_abrev = 'aud';
    elseif strncmpi(modality, 'visual', numel(modality))
        modality = 'visual';
        modality_abrev = 'vis';
    end
    
    for i = 1:nsubjects
        disp(i);
        M = selectbyfield(metadata, 'subject', i);
        P = selectbyfield(permutations, 'subject', i);
        P = P.permutation_index;
        C = selectbyfield(M.coords, 'orientation', 'orig');
        CF = selectbyfield(M.filters, 'label', sprintf('colfilter_%s', modality_abrev));
        RF = selectbyfield(M.filters, 'label', sprintf('rowfilter_%s', modality_abrev));
        NR = selectbyfield(M.filters, 'label', 'NOT_rain');
        rf = RF.filter(:) & NR.filter(:);
        cf = CF.filter;
        
        datapath = fullfile(M.datadir, sprintf('s%02d_avg.mat', i));
        tmp = load(datapath, modality);
        X = tmp.(modality)(rf, cf);
        xyz = C.xyz(cf, :);
        ind = C.ind(cf);
        hdr = niftiheaders(i).hdr;
        nrow = nnz(rf);
        ndist = (nrow^2 - nrow) / 2;

        switch target_label
            case 'semantic'
                T = selectbyfield(M.targets, ...
                    'label', target_label, ...
                    'type', 'similarity', ...
                    'sim_source', 'featurenorms', ...
                    'sim_metric', 'cosine');
            case 'visual'
                T = selectbyfield(M.targets, ...
                    'label', target_label, ...
                    'type', 'similarity', ...
                    'sim_source', 'chamfer', ...
                    'sim_metric', 'chamfer');
            case 'semantic_lowrank'
                T = selectbyfield(M.targets, ...
                    'label', target_label, ...
                    'type', 'similarity', ...
                    'sim_source', 'featurenorms', ...
                    'sim_metric', 'cosine');
            case 'visual_lowrank'
                T = selectbyfield(M.targets, ...
                    'label', target_label, ...
                    'type', 'similarity', ...
                    'sim_source', 'chamfer', ...
                    'sim_metric', 'cosine');
        end

        Y = SetupTargetAndPermutedRDMs( T, P, rf, 'rank', spearman );
        SL = GenerateSearchlights(xyz, radius);
        sldata = GenerateRDMsFromMRI( X, SL, 'rank', spearman );

        informationMaps = (sldata' * Y) ./ ndist;

        % Write final
        OD = selectbyfield(outdirs, 'target',target_label,'modality',modality,'condition','final');
        fname = sprintf('%02d_O+orig.nii', i);
        fpath = fullfile(OD.dirname, fname);
        WriteToNifti(hdr, fpath, informationMaps(:,1), ind);

        % Write permutations
        OD = selectbyfield(outdirs, 'target',target_label,'modality',modality,'condition','permutations');
        for j = 1:size(P,2);
            fname = sprintf('%02d_%03d_O+orig.nii', i, j);
            fpath = fullfile(OD.dirname, fname);
            WriteToNifti(hdr, fpath, informationMaps(:,j+1), ind, fpath);
        end
    end
end

