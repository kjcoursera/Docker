function example()

nii = spm_select('FPList', './execute/','^T_boldrest.nii');
nvol = spm_vol(nii);

nvols=spm_read_vols(nvol);

meanvols = mean(nvols,4);

vo=nvol(1);
vo.fname = fullfile(fileparts(nii),['mean_' spm_str_manip(nvol(1).fname,'t')]);
vo.dt = [16 0];

spm_write_vol(vo,meanvols);

end

 