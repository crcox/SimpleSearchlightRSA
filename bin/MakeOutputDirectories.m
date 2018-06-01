function [outdirs] = MakeOutputDirectories(output_root)
    if nargin < 1
        output_root = '.';
    end
    outdir_final_sem_vis = fullfile(output_root,'semantic','visual','final','solutionmaps','nifti');
    if ~exist(outdir_final_sem_vis, 'dir')
        mkdir(outdir_final_sem_vis);
    end
    outdir_final_sem_aud = fullfile(output_root,'semantic','audio','final','solutionmaps','nifti');
    if ~exist(outdir_final_sem_aud, 'dir')
        mkdir(outdir_final_sem_aud);
    end
    outdir_final_vis_vis = fullfile(output_root,'visual','visual','final','solutionmaps','nifti');
    if ~exist(outdir_final_vis_vis, 'dir')
        mkdir(outdir_final_vis_vis);
    end
    outdir_perms_sem_vis = fullfile(output_root,'semantic','visual','permutations','solutionmaps','nifti');
    if ~exist(outdir_perms_sem_vis, 'dir')
        mkdir(outdir_perms_sem_vis);
    end
    outdir_perms_sem_aud = fullfile(output_root,'semantic','audio','permutations','solutionmaps','nifti');
    if ~exist(outdir_perms_sem_aud, 'dir')
        mkdir(outdir_perms_sem_aud);
    end
    outdir_perms_vis_vis = fullfile(output_root,'visual','visual','permutations','solutionmaps','nifti');
    if ~exist(outdir_perms_vis_vis, 'dir')
        mkdir(outdir_perms_vis_vis);
    end

    outdirs = struct( ...
        'target', {'semantic';'semantic';'visual';'semantic';'semantic';'visual'}, ...
        'modality', {'visual';'audio';'visual';'visual';'audio';'visual'}, ...
        'condition', {'final';'final';'final';'permutations';'permutations';'permutations'}, ...
        'dirname', {
            outdir_final_sem_vis
            outdir_final_sem_aud
            outdir_final_vis_vis
            outdir_perms_sem_vis
            outdir_perms_sem_aud
            outdir_perms_vis_vis
        });
end
