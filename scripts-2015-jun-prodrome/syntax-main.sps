
* set default directory as you like
* for example 
* cd 'C:\Users\jun\Documents\SPSS'

* import table

GET DATA /TYPE=XLSX 
  /FILE='Caselist_CC_prodromes.xlsx' 
  /SHEET=name 'Full' 
  /CELLRANGE=full 
  /READNAMES=on 
  /ASSUMEDSTRWIDTH=32767. 
EXECUTE. 
DATASET NAME demographic WINDOW=FRONT.

STRING caseid2 (A9).
COMPUTE caseid2 = substr(Case#,1,9).
EXECUTE.

* sort for merging

SORT CASES BY caseid2.  
SAVE OUTFILE="demographic.sorted.sav".

* import aseg table

GET TRANSLATE FILE="edited.aseg_stats.txt"
   /TYPE=TAB 
   /FIELDNAMES.
EXECUTE. 
DATASET NAME aseg WINDOW=FRONT.

COMPUTE ICV = EstimatedTotalIntraCranialVol. 
EXECUTE.

STRING caseid2 (A9).
COMPUTE caseid2 = substr(Measurevolume,1,9).
EXECUTE. 

* sort for merging

SORT CASES BY caseid2.  
SAVE OUTFILE="aseg.sorted.sav".

* volume table rh

GET TRANSLATE FILE="edited.aparc_stats_rh_volume.txt"
   /TYPE=TAB 
   /FIELDNAMES.
EXECUTE. 
DATASET NAME volrh WINDOW=FRONT.

STRING caseid2 (A9).
COMPUTE caseid2 = substr(rh.aparc.volume,1,9).
EXECUTE. 

* sort for merging

SORT CASES BY caseid2.  
SAVE OUTFILE="volrh.sorted.sav".

* volume table lh

GET TRANSLATE FILE="edited.aparc_stats_lh_volume.txt"
   /TYPE=TAB 
   /FIELDNAMES.
EXECUTE. 
DATASET NAME vollh WINDOW=FRONT.

STRING caseid2 (A9).
COMPUTE caseid2 = substr(lh.aparc.volume,1,9).
EXECUTE. 

* sort for merging

SORT CASES BY caseid2.  
SAVE OUTFILE="vollh.sorted.sav".

* merge 

MATCH FILES FILE="demographic.sorted.sav" /IN=fromdmg 
  /FILE="aseg.sorted.sav" /IN=fromaseg
  /FILE="volrh.sorted.sav" /IN=fromvolrh 
  /FILE="vollh.sorted.sav" /IN=fromvollh
  /BY caseid2.
EXECUTE.
DATASET NAME datay WINDOW=FRONT.

* caluclate relative volume (divided by ICV)

DO REPEAT x = r.LeftLateralVettricle	r.LeftItfLatVett	r.LeftCerebellumWhiteMatter	r.LeftCerebellumCortex	r.LeftThalamusProper	r.LeftCaudate	r.LeftPutamen	r.LeftPallidum	r.3rdVettricle	r.4thVettricle	r.BraitStem	r.LeftHippocampus	r.LeftAmygdala	r.CSF	r.LeftAccumbetsarea	r.LeftVettralDC	r.Leftvessel	r.Leftchoroidplexus	r.RightLateralVettricle	r.RightItfLatVett	r.RightCerebellumWhiteMatter	r.RightCerebellumCortex	r.RightThalamusProper	r.RightCaudate	r.RightPutamet	r.RightPallidum	r.RightHippocampus	r.RightAmygdala	r.RightAccumbetsarea	r.RightVettralDC	r.Rightvessel	r.Rightchoroidplexus	r.5thVettricle	r.WMhypoittetsities	r.LeftWMhypoittetsities	r.RightWMhypoittetsities	r.totWMhypoittetsities	r.LefttotWMhypoittetsities	r.RighttotWMhypoittetsities	r.OpticChiasm	r.CC_Posterior	r.CC_Mid_Posterior	r.CC_Cettral	r.CC_Mid_Atterior	r.CC_Atterior	r.BraitSegVol	r.BraitSegVolNotVett	r.BraitSegVolNotVettSurf	r.lhCortexVol	r.rhCortexVol	r.CortexVol	r.lhCorticalWhiteMatterVol	r.rhCorticalWhiteMatterVol	r.CorticalWhiteMatterVol	r.SubCortGrayVol	r.TotalGrayVol	r.SupraTettorialVol	r.SupraTettorialVolNotVett	r.SupraTettorialVolNotVettVox	r.MaskVol	r.BraitSegVoltoeTIV	r.MaskVoltoeTIV
    / y = LeftLateralVentricle	LeftInfLatVent	LeftCerebellumWhiteMatter	LeftCerebellumCortex	LeftThalamusProper	LeftCaudate	LeftPutamen	LeftPallidum	@3rdVentricle	@4thVentricle	BrainStem	LeftHippocampus	LeftAmygdala	CSF	LeftAccumbensarea	LeftVentralDC	Leftvessel	Leftchoroidplexus	RightLateralVentricle	RightInfLatVent	RightCerebellumWhiteMatter	RightCerebellumCortex	RightThalamusProper	RightCaudate	RightPutamen	RightPallidum	RightHippocampus	RightAmygdala	RightAccumbensarea	RightVentralDC	Rightvessel	Rightchoroidplexus	@5thVentricle	WMhypointensities	LeftWMhypointensities	RightWMhypointensities	nonWMhypointensities	LeftnonWMhypointensities	RightnonWMhypointensities	OpticChiasm	CC_Posterior	CC_Mid_Posterior	CC_Central	CC_Mid_Anterior	CC_Anterior	BrainSegVol	BrainSegVolNotVent	BrainSegVolNotVentSurf	lhCortexVol	rhCortexVol	CortexVol	lhCorticalWhiteMatterVol	rhCorticalWhiteMatterVol	CorticalWhiteMatterVol	SubCortGrayVol	TotalGrayVol	SupraTentorialVol	SupraTentorialVolNotVent	SupraTentorialVolNotVentVox	MaskVol	BrainSegVoltoeTIV	MaskVoltoeTIV.
COMPUTE x = y / ICV.
END REPEAT PRINT.
EXE. 

DO REPEAT x = r.rh_bankssts_volume	r.rh_caudalanteriorcingulate_volume	r.rh_caudalmiddlefrontal_volume	r.rh_cuneus_volume	r.rh_entorhinal_volume	r.rh_fusiform_volume	r.rh_inferiorparietal_volume	r.rh_inferiortemporal_volume	r.rh_isthmuscingulate_volume	r.rh_lateraloccipital_volume	r.rh_lateralorbitofrontal_volume	r.rh_lingual_volume	r.rh_medialorbitofrontal_volume	r.rh_middletemporal_volume	r.rh_parahippocampal_volume	r.rh_paracentral_volume	r.rh_parsopercularis_volume	r.rh_parsorbitalis_volume	r.rh_parstriangularis_volume	r.rh_pericalcarine_volume	r.rh_postcentral_volume	r.rh_posteriorcingulate_volume	r.rh_precentral_volume	r.rh_precuneus_volume	r.rh_rostralanteriorcingulate_volume	r.rh_rostralmiddlefrontal_volume	r.rh_superiorfrontal_volume	r.rh_superiorparietal_volume	r.rh_superiortemporal_volume	r.rh_supramarginal_volume	r.rh_frontalpole_volume	r.rh_temporalpole_volume	r.rh_transversetemporal_volume	r.rh_insula_volume
    / y = rh_bankssts_volume	rh_caudalanteriorcingulate_volume	rh_caudalmiddlefrontal_volume	rh_cuneus_volume	rh_entorhinal_volume	rh_fusiform_volume	rh_inferiorparietal_volume	rh_inferiortemporal_volume	rh_isthmuscingulate_volume	rh_lateraloccipital_volume	rh_lateralorbitofrontal_volume	rh_lingual_volume	rh_medialorbitofrontal_volume	rh_middletemporal_volume	rh_parahippocampal_volume	rh_paracentral_volume	rh_parsopercularis_volume	rh_parsorbitalis_volume	rh_parstriangularis_volume	rh_pericalcarine_volume	rh_postcentral_volume	rh_posteriorcingulate_volume	rh_precentral_volume	rh_precuneus_volume	rh_rostralanteriorcingulate_volume	rh_rostralmiddlefrontal_volume	rh_superiorfrontal_volume	rh_superiorparietal_volume	rh_superiortemporal_volume	rh_supramarginal_volume	rh_frontalpole_volume	rh_temporalpole_volume	rh_transversetemporal_volume	rh_insula_volume.
COMPUTE x = y / ICV.
END REPEAT PRINT.
EXE. 

DO REPEAT x = r.lh_bankssts_volume	r.lh_caudalanteriorcingulate_volume	r.lh_caudalmiddlefrontal_volume	r.lh_cuneus_volume	r.lh_entorhinal_volume	r.lh_fusiform_volume	r.lh_inferiorparietal_volume	r.lh_inferiortemporal_volume	r.lh_isthmuscingulate_volume	r.lh_lateraloccipital_volume	r.lh_lateralorbitofrontal_volume	r.lh_lingual_volume	r.lh_medialorbitofrontal_volume	r.lh_middletemporal_volume	r.lh_parahippocampal_volume	r.lh_paracentral_volume	r.lh_parsopercularis_volume	r.lh_parsorbitalis_volume	r.lh_parstriangularis_volume	r.lh_pericalcarine_volume	r.lh_postcentral_volume	r.lh_posteriorcingulate_volume	r.lh_precentral_volume	r.lh_precuneus_volume	r.lh_rostralanteriorcingulate_volume	r.lh_rostralmiddlefrontal_volume	r.lh_superiorfrontal_volume	r.lh_superiorparietal_volume	r.lh_superiortemporal_volume	r.lh_supramarginal_volume	r.lh_frontalpole_volume	r.lh_temporalpole_volume	r.lh_transversetemporal_volume	r.lh_insula_volume
    / y = lh_bankssts_volume	lh_caudalanteriorcingulate_volume	lh_caudalmiddlefrontal_volume	lh_cuneus_volume	lh_entorhinal_volume	lh_fusiform_volume	lh_inferiorparietal_volume	lh_inferiortemporal_volume	lh_isthmuscingulate_volume	lh_lateraloccipital_volume	lh_lateralorbitofrontal_volume	lh_lingual_volume	lh_medialorbitofrontal_volume	lh_middletemporal_volume	lh_parahippocampal_volume	lh_paracentral_volume	lh_parsopercularis_volume	lh_parsorbitalis_volume	lh_parstriangularis_volume	lh_pericalcarine_volume	lh_postcentral_volume	lh_posteriorcingulate_volume	lh_precentral_volume	lh_precuneus_volume	lh_rostralanteriorcingulate_volume	lh_rostralmiddlefrontal_volume	lh_superiorfrontal_volume	lh_superiorparietal_volume	lh_superiortemporal_volume	lh_supramarginal_volume	lh_frontalpole_volume	lh_temporalpole_volume	lh_transversetemporal_volume	lh_insula_volume.
COMPUTE x = y / ICV.
END REPEAT PRINT.
EXE. 

* exclude cases which are not listed on the Jenny's table

FILTER BY AGE.

