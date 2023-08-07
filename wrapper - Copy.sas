%macro wrapper;

options nomprint nomlogic nosymbolgen;

%let _files=
dabt_cprm_import_mdl_param
dabt_cprm_import_project_master
csbmva_cleanup_model_data
csbmva_distance_stats
csbmva_ds
dabt_scorecard_gen_scoring_code
dabt_scorecard_register_wrapper
csbmva_interpolation
;

%let _count=%sysfunc(countw(&_files.));
%Do i=1 %to &_count.;
%let _fname=%qscan(&_files,&i.);
filename cd_ref filesrvc folderpath="/Public" filename="&_fname..sas" debug= http;
%include cd_ref;
%end;

options mprint mlogic symbolgen;

%mend;

%wrapper;