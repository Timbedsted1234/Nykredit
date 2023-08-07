%macro clone_rm_project(project_id=, clonned_projet_nm=);
	%let project_id = &project_id.;
	%let clonned_projet_nm = &clonned_projet_nm;
	%dabt_cprm_prj_export_wrapper (project_id_lst=&project_id.);

	proc sql;
		update apdm.project_master set project_short_nm="&clonned_projet_nm." where 
			project_sk=&project_id.;
	quit;

	proc sql;
		update APDM.MODELING_ABT_MASTER set abt_table_nm=catt(abt_table_nm, '_v1') 
			where project_sk=&project_id.;
	quit;

	filename imp_file filesrvc 
		folderpath="/SAS Risk Modeling/Application Data/Jobs/&m_job_sk." 
		filename="cprm_import_specification_file.csv" debug=http 
		CD="attachment; filename=cprm_import_specification_file.csv";

	PROC IMPORT OUT=work.prj_imprt_specification_tmp DATAFILE=imp_file DBMS=csv 
			REPLACE;
		GETNAMES=NO;
		guessingrows=32767;
		DATAROW=2;
	RUN;

	filename imp_file clear;

	data work.prj_import_specification;
		set work.prj_imprt_specification_tmp;
		rename var1=ENTITY_TYPE_CD;
		rename var2=ENTITY_TYPE_NM;
		rename var3=ENTITY_KEY;
		rename var4=ENTITY_NM;
		rename var5=ENTITY_DESC;
		rename var6=PROMOTE_FLG;
		rename var7=USER;
	run;

	%dabt_cprm_import_wrapper (import_package_path=%str(/SAS Risk Modeling/Application Data/Jobs/&m_job_sk.), 
		mode=Analyze);
	filename imp_file filesrvc 
		folderpath="/SAS Risk Modeling/Application Data/Jobs/&m_job_sk." 
		filename="cprm_pre_import_analysis_report.csv" debug=http 
		CD="attachment; filename=cprm_pre_import_analysis_report.csv";

	PROC IMPORT OUT=work.cprm_pre_import_analysis DATAFILE=imp_file DBMS=csv 
			REPLACE;
		GETNAMES=YES;
		guessingrows=32767;
	RUN;

	filename imp_file clear;

	/* 	*==================================================; */
	/* 	* Check if there are errors in PreValidation ; */
	/* 	*==================================================; */
	/* 	 */
	/* 	Check for errors */
	%let m_imp_error = 0;

	proc sql noprint;
		select count(*) into :m_imp_error from cprm_ctl.CPRM_IMPORT_PARAMETER_LIST 
			where import_analysis_return_cd is NULL or import_analysis_return_cd > 4;
	quit;

	%if &m_imp_error gt 0 %then
		%do;

			proc sql;
				create table not_to_be_promoted as select PROMOTION_ENTITY_NM from 
					cprm_pre_import_analysis where ASS_ENT_IMPORT_ACTION_CD IN 
					("ERROR_ASSOC_ENTITY_REPRMTN_NOT_SUPPORTED_OF_USED_ENTITY",
					"ERROR_ASSOC_ENTITY_DIFF_DEFN_OF_USED_ENTITY");
			quit;


			proc sql;
				update prj_import_specification set PROMOTE_FLG=&CHECK_FLAG_FALSE where 
					ENTITY_NM in(select PROMOTION_ENTITY_NM from not_to_be_promoted);
			quit;

		%end;
	filename exp_file filesrvc 
		folderpath="/SAS Risk Modeling/Application Data/Jobs/&m_job_sk./" 
		filename="cprm_import_specification_file.csv" encoding='utf-8' debug=http;

	proc export data=work.prj_import_specification outfile=exp_file DBMS=csv 
			replace label;
	run;

	%dabt_cprm_import_wrapper (import_package_path=%str(/SAS Risk Modeling/Application Data/Jobs/&m_job_sk.), 
		mode=EXECUTE);
%mend clone_rm_project;