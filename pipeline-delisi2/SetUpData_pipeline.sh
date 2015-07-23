base=$(readlink -m ${BASH_SOURCE[0]})    # absolute path of this file
base=${base%/*}    # delete strings minimal identical from the last 

caselist=$base/caselist
strct=$base/$case/strct
# t1align=$base/$case/raw/$case-t1w.nrrd
t1align=/rfanfs/pnl-a/pnl/Collaborators/Delisi/$case/align-space/$case-t1w-realign.nrrd
t2=/rfanfs/pnl-a/pnl/Collaborators/Delisi/dicom_to_nifti/data/$case/T2/$case-T2.nrrd

# ==========================================================
# MABS (atlas) mask
# Input
# Output
t2atlasmask=/rfanfs/pnl-a/pnl/Collaborators/Delisi/masks-fromcluster/$case.atlasmask.thresh50-edr.nrrd
# ==========================================================

xfm=$strct/$case.xfm
maskalign=$strct/$case.mask-realign.nrrd

# ==========================================================
# Freesurfer
FREESURFER_HOME=/projects/schiz/ra/eli/freesurfer5.3
# Inputs
fs_mask=$t2atlasmask
fs_t1=$strct/$case.t1-realign-masked.nrrd
# Output
fs=$strct/$case.freesurfer
# ==========================================================
