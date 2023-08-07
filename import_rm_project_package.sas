%macro import_rm_project_package(project_package_location=);
	%let rm_import_package_path = &project_package_location.;
	%dabt_cprm_import_wrapper (import_package_path=&rm_import_package_path., 
		mode=Analyse);
	filename imp_file filesrvc 
		folderpath="/SAS Risk Modeling/Application Data/Jobs/&m_job_sk./" 
		filename="cprm_pre_import_analysis_report.csv" debug=http 
		CD="attachment; filename=cprm_pre_import_analysis_report.csv";

	PROC IMPORT OUT=work.prj_pre_imprt_analysis DATAFILE=imp_file DBMS=csv REPLACE;
		GETNAMES=YES;
		guessingrows=32767;
	RUN;

	filename imp_file clear;

	proc sql;
		select count(*) into :m_total_count from WORK.PRJ_PRE_IMPRT_ANALYSIS;
		select count(*) into :m_success_count from WORK.PRJ_PRE_IMPRT_ANALYSIS where 
			upcase(ASS_ENT_IMPORT_ACTION_CD) eq "PRE_IMPORT_ANALYSIS_SUCCESS";
	quit;

	%let  m_total_count = &m_total_count.;
	%let  m_success_count = &m_success_count.;

	%if &m_success_count eq &m_total_count. %then
		%do;
			%dabt_cprm_import_wrapper (import_package_path=&rm_import_package_path., 
				mode=Execute);
		%end;
	%else
		%do;
			%put "Error: There are few warning in pre-import analysis. Fix those warning and re-run the code.";
			%return;
		%end;
%mend import_rm_project_package;
