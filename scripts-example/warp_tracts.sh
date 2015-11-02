#!/bin/bash

ls -d DELISI_HM_* | sed 's:.*HM_::g' | xargs -I % -P 0 /projects/schiz/software/ANTS-build/bin/WarpVTKPolyDataMultiTransform 3  /projects/lmi/people/petersv/for_demian/ioff/%-ioff-left.vtk IOFF-bundles-registered/DELISI_HM_%-left.vtk -R atlas_build/ants_atlasDELISI_HM_%_FA_slicerMask.nii.gz -i  atlas_build/ants_atlasDELISI_HM_%_FA_slicerMaskAffine.txt atlas_build/GR_iteration_3/ants_atlasDELISI_HM_%_FA_slicerMaskWarp.nii.gz

ls -d DELISI_HM_* | sed 's:.*HM_::g' | xargs -I % -P 0 /projects/schiz/software/ANTS-build/bin/WarpVTKPolyDataMultiTransform 3  /projects/lmi/people/petersv/for_demian/ioff/%-ioff-right.vtk IOFF-bundles-registered/DELISI_HM_%-left.vtk -R atlas_build/ants_atlasDELISI_HM_%_FA_slicerMask.nii.gz -i  atlas_build/ants_atlasDELISI_HM_%_FA_slicerMaskAffine.txt atlas_build/GR_iteration_3/ants_atlasDELISI_HM_%_FA_slicerMaskWarp.nii.gz

ls -d DELISI_HM_* | sed 's:.*HM_::g' | xargs -I % -P 0 /projects/schiz/software/ANTS-build/bin/WarpVTKPolyDataMultiTransform 3  /projects/lmi/people/petersv/for_demian/uncinate/%-unc-left.vtk UNC-bundles-registered/DELISI_HM_%-left.vtk -R atlas_build/ants_atlasDELISI_HM_%_FA_slicerMask.nii.gz -i  atlas_build/ants_atlasDELISI_HM_%_FA_slicerMaskAffine.txt atlas_build/GR_iteration_3/ants_atlasDELISI_HM_%_FA_slicerMaskWarp.nii.gz

ls -d DELISI_HM_* | sed 's:.*HM_::g' | xargs -I % -P 0 /projects/schiz/software/ANTS-build/bin/WarpVTKPolyDataMultiTransform 3  /projects/lmi/people/petersv/for_demian/uncinate/%-unc-right.vtk UNC-bundles-registered/DELISI_HM_%-left.vtk -R atlas_build/ants_atlasDELISI_HM_%_FA_slicerMask.nii.gz -i  atlas_build/ants_atlasDELISI_HM_%_FA_slicerMaskAffine.txt atlas_build/GR_iteration_3/ants_atlasDELISI_HM_%_FA_slicerMaskWarp.nii.gz



