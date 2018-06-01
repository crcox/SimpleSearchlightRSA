function [real_maps, permutation_maps] = LoadRealAndPermuted(final_dir,permutations_dir,subject_set,blur)
    %% Load Real and Permuted solutions
    % Rank real data relative to the permutations
    permutation_maps = cell(numel(subject_set),1);
    for i = 1:numel(subject_set)
        s = subject_set(i);
        disp(s);
        fname = sprintf('xb%d_w%02d_O+orig.nii', blur, s);
        fpath = fullfile(final_dir, fname);
        tmp = load_nii(fpath);
        real_solution = tmp.img;
        if i == 1
            real_maps = zeros([size(real_solution), numel(subject_set)]);
        end
        %permutation_maps{i} = zeros([size(real_solution),100]);
        fname = sprintf('xb%d_w%02d.nii', blur, s);
        fpath = fullfile(permutations_dir, fname);
        tmp = load_nii(fpath);
        %permutation_maps{i}(:,:,:,:) = tmp.img;
        permutation_maps{i} = tmp.img;
        real_maps(:,:,:,i) = real_solution;
    end
end         
