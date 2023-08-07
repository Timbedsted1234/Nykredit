/*******************************************************
	NAME:	stamopl_hist_data_type_fix.sas
	DESC:	
********************************************************/
*  APDM -> WORK *;
filename apdmxpt filesrvc folderpath="/Public" filename= "apdm.xpt" debug=http recfm=n;
proc cimport library=work file=apdmxpt;
run;


proc sql;
	update source_column_master
set column_data_type_sk=4

where source_column_sk in (1000700,1000701)
;
quit;
