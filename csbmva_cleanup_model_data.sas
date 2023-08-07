/**********************************************************************************************
Copyright (c) 2014 by SAS Institute Inc., Cary, NC, USA.
Module         : csbmva_cleanup_model_data.sas
Function       : This macro cleans up model related data from business reports .
Authors        :  CSB Team
Date           :  02FEB2014
SAS            :  9.4
Called-by      :  User.
Logic          :  	1. Get the model_rk  for the input model and delete data from all the data marts.
					2. Cleanup data from required tables.
						> scoring data and tables
						> backtesting data and tables 
Parameters     :  model_id    -> model_id for which clean up needs to be executed .
                			  	
**********************************************************************************************/
%macro csbmva_cleanup_model_data(model_sk = , m_job_sk=,m_locale_nm=);
	%if %symexist(job_rc)=0 %then %do;
		%global job_rc;
	%end;
	%if %symexist(sqlrc)=0 %then %do;
		%global sqlrc;
	%end;
	%let lib_BACKTEST = &DABT_BACKTESTING_ABT_LIBREF.;
	%let lib_csbfact = &RM_MODELPERF_DATA_LIBREF.;
	%let lib_csmdl = &DABT_MODELING_ABT_LIBREF.;
	%let m_cas_mm_table=MM_MEASURE_STATS;
	%let m_cas_mip_table=MIP_MEASURE_STATS;
	%let lib_rm_bktsc=&DABT_BACKTESTING_SCR_LIBREF;
	%let trans_rc=0;
	%let job_rc=0;
	%let syscc=0;
	%let model_id = &model_sk;
	%let m_locale_nm=&m_locale_nm.;
	%local m_model_sk md_cl_pool_scr_count md_cl_pool_scr_list pool_scr_loop md_cl_pool_dev_list pool_dev_loop
	pool_apdm_loop Pool_apdm_count md_cl_scr_count md_cl_scr_loop md_cl_bck_loop md_cl_bck_count 
	m_scoring_model_id m_model_analysis_type_cd report_spec_sk_list scoring_template_sk scoring_model_sk etls_tableExist;
	%local m_delete_cas_data_source_flg;

	/* indb block - start */
	%if %kupcase(&DABT_INDB_PROCESSING_FLG) eq Y %then %do;
		%let m_delete_cas_data_source_flg=N;
	%end;
	%else %do; /* in-CAS processing */
		%let m_delete_cas_data_source_flg=Y;
	%end;
	/* indb block - end */
				
	*==================================================;
	* Getting MODEL_SK   ;
	*==================================================;
	%let m_model_sk=;
	%let m_externally_scored_flg=N;
	proc sql noprint;
		select model_sk,externally_scored_flg into :m_model_sk,:m_externally_scored_flg
		from &csb_apdm_libref..model_master
		where ktrim(kleft(model_id)) = "&model_id";		/* I18NOK:LINE */
	quit;
	%let m_model_sk=&m_model_sk;
	%let m_externally_scored_flg=&m_externally_scored_flg.;
	
	%if "&m_model_sk" ne "" %then %do; /* model exists */
	
		%dabt_initiate_cas_session(cas_session_ref=delete_mdl_scr_abt);
	*==================================================;
	* Getting version details   ;
	*==================================================;
		proc sql noprint;
			select report_specification_sk into :report_spec_sk_list separated by ','	/* I18NOK:LINE */
			from &csb_apdm_libref..mm_report_specification
			where model_sk = &m_model_sk ;
		quit;	
		%let report_spec_sk_list = &report_spec_sk_list;
		%let cnt_versions = %sysfunc(countw("&report_spec_sk_list"));					/* I18NOK:LINE */
		%if &cnt_versions > 1 %then %do;	/* At least one version in addition to MS */
				/*  Get m_model_analysis_type_cd */
				proc sql noprint;
					select 
						mat.model_analysis_type_cd 
						into 
							:m_model_analysis_type_cd
					from &csb_apdm_libref..model_master mm
					inner join &csb_apdm_libref..project_master pm
						on (mm.project_sk = pm.project_sk)
					inner join &csb_apdm_libref..purpose_master purp
						on (pm.purpose_sk = purp.purpose_sk)
					inner join &csb_apdm_libref..model_analysis_type_master mat
						on (mat.model_analysis_type_sk = purp.model_analysis_type_sk)
					where mm.model_sk = &m_model_sk.;
				quit;
				%let m_model_analysis_type_cd = &m_model_analysis_type_cd;
				
			
				/* Get scoring_model_id */
				proc sql noprint;
					select 
						scoring_model_id ,
						scoring_model_sk , 
						scoring_template_sk 
					into 
						:m_scoring_model_id ,
						:scoring_model_sk ,
						:scoring_template_sk
					from 
						&csb_apdm_libref..scoring_model
					where 
						model_sk = &m_model_sk.;
				quit;
				
				%let m_scoring_model_id = &m_scoring_model_id;
				%let scoring_model_sk = &scoring_model_sk;
				%let scoring_template_sk = &scoring_template_sk;
		
				*==================================================;
				* Begin Cleanup   ;
				*==================================================;
			
/* 				%if &m_scoring_model_id ne %then %do; 
					*==================================================;
					* Cleanup scoring data load for score based reports ;
					*==================================================;
					%let rpt_spec_scr_cnt=0;
					proc sql;
						create table report_spec_scr_time_lst as 
						select &m_model_sk. as m_model_id
						, scoring_control_detail_sk
						, put(datepart(scoring_as_of_dttm),mmddyy10.) as score_dt
						, report_specification_sk
						, scored_abt_nm
						, case when kupcase(kcompress("&m_model_analysis_type_cd.")) = "BINARY" then "BINARY"
						else "CONT" end as model_tgt_suffix											
						from 
							&csb_apdm_libref..scoring_control_detail
						where 
							report_specification_sk in (&report_spec_sk_list);
					quit;
					%let rpt_spec_scr_cnt = &sqlobs. ;
					%if &rpt_spec_scr_cnt gt 0 %then %do ;
					%do rpt_spec_scr_loop=1 %to &rpt_spec_scr_cnt; 
						data _null_;
							pointobs=&rpt_spec_scr_loop;
							set report_spec_scr_time_lst point=pointobs;
							call symputx('m_model_id',m_model_id); 
							call symputx('scr_scoring_dt',score_dt); 
							call symputx('scr_rpt_spec_sk',report_specification_sk); 
							call symputx('scr_model_tgt_suffix',model_tgt_suffix); 
							call symputx('scr_control_detail_sk',scoring_control_detail_sk); 
							call symputx('scr_abt_nm',scored_abt_nm); 
							stop;
						run;
						
						%csbmva_cleanup_scr_and_act_run (  m_model_id =&m_model_id 
															, scoring_dt = &scr_scoring_dt 
															, m_report_spec_sk = &scr_rpt_spec_sk
															, model_tgt_suffix = &scr_model_tgt_suffix
															, scoring_control_detail_sk = &scr_control_detail_sk
															, scored_abt_nm = &scr_abt_nm
															, called_from_delete_mdl_flg = Y 
															, m_scoring_model_id = &m_scoring_model_id
															, scoring_model_sk = &scoring_model_sk
															, scoring_template_sk = &scoring_template_sk
						);
					
					%end;
					proc sql noprint;
						delete from &csb_apdm_libref..scoring_template_detail
						where scoring_template_sk = &scoring_template_sk.;	
					quit;
				%end; 
				%else %do;
					%put NOTE: Model is not scored, proceeding to delete backtesting data ;
				%end; 
			%end; */
			/*
			%else %do;
				%put NOTE: Model is not deployed, proceeding to delete backtesting data ;
			%end; 
			*/
			/* S1471893 - This entry can exist if model is marked "ready for deployment" but not yet deployed/scored; hence executes outside if-block */
				proc sql;
					delete from &csb_apdm_libref..scoring_model
					where model_sk = &m_model_sk. ;
				quit; 
						
			*==================================================;
			* Cleanup data for back-tested reports ;
			*==================================================;
			
			proc sql;
				create table bck_dates as 
				select report_specification_sk, scoring_as_of_time_sk 
				from &csb_apdm_libref..mm_model_stats /* review */
				where report_specification_sk in (&report_spec_sk_list)
				and report_category_sk = (select report_category_sk from &csb_apdm_libref..mm_report_category_master where kupcase(kcompress(report_category_cd)) = 'BCK');		/* I18NOK:LINE */
			quit;
			%let bck_cnt = &sqlobs. ;
			%if &bck_cnt > 0 %then %do;	/* At least one Backtested report data exists */
				%do bck_loop = 1 %to &bck_cnt ;
			
					data _null_;
						pointobs=&bck_loop;
						set bck_dates point=pointobs;
						call symputx('m_report_specification_sk',report_specification_sk);		/* I18NOK:LINE */
						call symputx('bck_score_time_sk',scoring_as_of_time_sk);					/* I18NOK:LINE */
					stop;
					run;
			
					proc sql noprint;
						select put(datepart(period_last_dttm),mmddyy10.) into :scr_time /* I18NOK:LINE */
							from &csb_apdm_libref..time_dim where time_sk = &bck_score_time_sk;
					quit;
					
					%local model_tgt_suffix_str;
					%if %kupcase(&m_model_analysis_type_cd.) eq BINARY %then %do;
						%let model_tgt_suffix_str=BINARY;
					%end;
					%else %do;
						%let model_tgt_suffix_str=CONT;
					%end;
		
				%csbmva_scoring_load_cleanup( m_model_id =&m_model_sk
										, m_report_spec_sk = &m_report_specification_sk 
										, scoring_dt = &scr_time 
										, called_from_delete_mdl_flg=Y
										, model_tgt_suffix = &model_tgt_suffix_str
										, report_category_cd = BCK);  
												
				%end;/*end for bck_loop*/
			
				/* Get backtest table names */
		
				proc sql noprint;	
					select mdl_abt_ds, scr_abt_ds, kcompress(kstrcat(scr_abt_ds,"t")) 													/* I18NOK:LINE */
						into :mdl_abt_ds separated by ',' , :scr_abt_ds separated by ',' , :scr_abt_ds_temp separated by ','			/* I18NOK:LINE */
						from &csb_apdm_libref..build_backtest_abt_status 
						where report_specification_sk in (&report_spec_sk_list)
						;
				quit;
				
				
				/*Drop tables for mdl_abt_ds from rm_bktsc library*/

				%if %kupcase(&DABT_INDB_PROCESSING_FLG) ne Y %then %do;
					%dabt_initiate_cas_session(cas_session_ref=delete_mdl_abt_ds);
				%end;			
				
				%let mdl_abt_ds = &mdl_abt_ds;	 
				%let mdl_abt_ds_cnt = %eval(%sysfunc(countc(%quote(&mdl_abt_ds),","))+1); /* i18NOK:LINE */
				%do i = 1 %to &mdl_abt_ds_cnt;
					%let mdl_abt_ds_tmp = %scan(%quote(&mdl_abt_ds),&i,%str(,)); /* i18NOK:LINE */ 
					%dabt_drop_table(m_table_nm=&lib_rm_bktsc..&mdl_abt_ds_tmp.,m_cas_flg=&m_cas_flg., m_delete_cas_data_source_file=&m_delete_cas_data_source_flg.);
				%end;
				
				/*Drop tables for scr_abt_ds from rm_bkt library*/
				
				%let scr_abt_ds = &scr_abt_ds;
				%let scr_abt_ds_cnt = %eval(%sysfunc(countc(%quote(&scr_abt_ds),","))+1); /* i18NOK:LINE */
				%do i = 1 %to &scr_abt_ds_cnt;
					%let scr_abt_ds_tmp = %scan(%quote(&scr_abt_ds),&i,%str(,)); /* i18NOK:LINE */ 
					%dabt_drop_table(m_table_nm=&lib_BACKTEST..&scr_abt_ds_tmp.,m_cas_flg=&m_cas_flg., m_delete_cas_data_source_file=&m_delete_cas_data_source_flg.);
				%end;
				
				/*Drop tables for scr_abt_ds_temp from rm_bktsc library*/
				
				%let scr_abt_ds_temp = &scr_abt_ds_temp ;
				%let scr_abt_ds_temp_cnt = %eval(%sysfunc(countc(%quote(&scr_abt_ds_temp),","))+1); /* i18NOK:LINE */
				%do i = 1 %to &scr_abt_ds_temp_cnt;
					%let scr_abt_ds_temp_tmp = %scan(%quote(&scr_abt_ds_temp),&i,%str(,)); /* i18NOK:LINE */ 
					%dabt_drop_table(m_table_nm=&lib_rm_bktsc..&scr_abt_ds_temp_tmp.,m_cas_flg=&m_cas_flg., m_delete_cas_data_source_file=&m_delete_cas_data_source_flg.);
				%end;
				
				%if %kupcase(&DABT_INDB_PROCESSING_FLG) ne Y %then %do;
					%dabt_terminate_cas_session(cas_session_ref=delete_mdl_abt_ds);
				%end;
				*==================================================;
				* Perform cleanup ;
				*==================================================;
				
				/* Clean up run table */
				
				proc sql;
					delete from &csb_apdm_libref..BUILD_BACKTEST_ABT_STATUS 
						where model_rk = &m_model_sk 
					  ;
				quit;
		%end; /* At least one Backtested report data exists */
		%else %do;
			/* %put NOTE: No backtest data, proceeding to delete Model Data ; */
			%put  %sysfunc(sasmsg(SASHELP.dabt_error_messages, CSBMVA_CLEANUP_MODEL_DATA_NOTE1.1, noquote));				
		%end;
			
		%end;	/* At least one version in addition to MS */
		%else %do;
			/* %put NOTE: No versions found for model, proceeding to delete Model Specification Details ; */
			%put  %sysfunc(sasmsg(SASHELP.dabt_error_messages, CSBMVA_CLEANUP_MODEL_DATA_NOTE1.2, noquote));				
		%end;	
		/* if scoring and backtesting data deleted successfully, then proceed */
		/* THIS PART TO BE ADDED */ 
			*==================================================;
			* Deletion from other apdm extension tables ;
			*==================================================;
			
			/* Export Profiles */
			
			%let expt_profile_sk=-1;
			%let expt_temp_sk=-1;
	
			proc sql noprint;
				select distinct EXPORT_PROFILE_SK into :expt_profile_sk separated by ',' 	/* I18NOK:LINE */
				from &csb_apdm_libref..EXPORT_PROFILE_MASTER where MODEL_RK= &m_model_sk;
				
				delete from &csb_apdm_libref..EXPORT_PROFILE_MEASURE_LIST where EXPORT_PROFILE_SK in (&expt_profile_sk);
				
				delete from &csb_apdm_libref..EXPORT_PROFILE_MASTER where MODEL_RK=&m_model_sk;
			quit;
			*==================================================;
			* Deletion from apdm core tables ;
			*==================================================;
				
				proc sql noprint;
					select project_sk into :m_mdl_project_sk
					from &csb_apdm_libref..model_master
					where model_sk = &m_model_sk.;
				quit;
				%let m_mdl_project_sk = &m_mdl_project_sk;		
						
				/* Delete _DEV_FACT and _PROP_CALC if tables exist */
				
				proc sql;
					create table dev_fct_list as
					select model_sk, report_specification_sk 
					from &csb_apdm_libref..mm_report_specification
					where model_sk =  &m_model_sk.;
				quit;
				%let dev_fct_cnt = &sqlobs;
				%do dev_loop = 1 %to &dev_fct_cnt;
					data _null_;
						pointobs=&dev_loop;
								 set dev_fct_list point=pointobs;
								 call symputx('rpt_spec_sk',report_specification_sk); /* I18NOK:EMS */							 	
						stop;
					run;
					
					%if %sysfunc(exist(&lib_csbfact.._&m_model_sk._&rpt_spec_sk._DEV_FACT)) %then %do;
						
						%dabt_drop_table(m_table_nm=&lib_csbfact.._&m_model_sk._&rpt_spec_sk._DEV_FACT,m_cas_flg=&m_cas_flg., m_delete_cas_data_source_file=&m_delete_cas_data_source_flg.);
					%end;
					
					%if %sysfunc(exist(&lib_csmdl..prop_cal_scr_&rpt_spec_sk.)) %then %do;
						
						%dabt_drop_table(m_table_nm=&lib_csmdl..prop_cal_scr_&rpt_spec_sk.,m_cas_flg=&m_cas_flg., m_delete_cas_data_source_file=&m_delete_cas_data_source_flg.);
					%end;
				%end;/* end for dev_loop */
				%dabt_delete_mdl_wrapper(m_project_sk=&m_mdl_project_sk, m_model_sk=&m_model_sk., m_lst_prc_usr=&sysuserid) ; /* Deletes all apdm tables, need to delete &RM_MODELPERF_DATA_LIBREF.._<mdl>_<rpt_spec>_DEV_FACT */
				
				
					
	/*
			proc sql noprint;	
				select job_sk into :job_sk_lst separated by ','		
				from &csb_apdm_libref..job_master		
				where job_sk ne &m_job_sk. and
					(
						(entity_type_sk in 
							(select 
								entity_type_sk 
							from 
								&csb_apdm_libref..entity_type_master 
							where entity_type_cd in ('RPT_SPEC')) 
								and entity_sk in (&report_spec_sk_list.) 
						)		
					or
						(entity_type_sk in 
							(select 
								entity_type_sk 
							from 
								&csb_apdm_libref..entity_type_master 
							where entity_type_cd in ('MODEL')) 
								and entity_sk in (&m_model_sk.)
						)	
					)
				;
			quit;
			%if %symexist(job_sk_lst) %then %do;
				proc sql;
					delete from &csb_apdm_libref..job_master
					where job_sk in (&job_sk_lst);
				quit;				
			%end;
			*/
			
			/* Other tables */
			
			proc sql;
				delete from &csb_apdm_libref..model_actual_rslt_source_column
					where model_rk = &m_model_sk. ;
				
				delete from &csb_apdm_libref..model_predicted_rslt_src_column
					where model_rk = &m_model_sk. ;
			quit;
			proc sql;
				delete from &csb_apdm_libref..model_range_scheme
					where model_rk = &m_model_sk;
				delete from &csb_apdm_libref..model_x_measure_threshold
					where model_rk = &m_model_sk;
			quit;
			proc sql;
				delete from &csb_apdm_libref..model_master_extension
					where ktrim(kleft(kupcase(model_id))) = "&m_model_sk";		/* I18NOK:LINE */
			quit;
			
			/* Assigning CAS for deleting dev data */
			%dabt_initiate_cas_session(cas_session_ref=dev_delete);
			
			/*Deleting data from CAS tables where mm and mip stats has been synced during development data, backtesting and Ongoing stats*/
			
		*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
		* Delete dev data from mm_measure_stats and mip_measure_Stats;
		*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
		
			%let etls_tableExist = %eval(%sysfunc(exist(&rm_reporting_mart_libref..&m_cas_mm_table., DATA)));
			%if &etls_tableExist. ne 0 %then %do;
			
				proc cas;
					table.deleteRows/
					table={
					caslib="&rm_reporting_mart_libref", /* I18NOK:LINE */
					name="&m_cas_mm_table", /* I18NOK:LINE */
					where="model_sk=&model_sk" /* I18NOK:LINE */
					};
				quit;
			%end;	
			
			%let etls_tableExist = %eval(%sysfunc(exist(&rm_reporting_mart_libref..&m_cas_mip_table., DATA)));
			%if &etls_tableExist. ne 0 %then %do;
			
				proc cas;
					table.deleteRows/
					table={
					caslib="&rm_reporting_mart_libref", /* I18NOK:LINE */
					name="&m_cas_mip_table", /* I18NOK:LINE */
					where="model_sk=&model_sk" /* I18NOK:LINE */
					};
				quit;
			%end;	
			
			%dabt_terminate_cas_session(cas_session_ref=dev_delete);
			
		*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
		* Delete detail report data from rm_rptmr ;
		*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
		
			%dabt_initiate_cas_session(cas_session_ref=detail_delete);
			/*options minoperator mindelimiter=%str(,);*/
			proc sql;
			select report_category_sk into :_report_cat separated by ',' from &csb_apdm_libref..MM_REPORT_CATEGORY_MASTER  /* I18NOK:LINE */
				where kupcase(report_category_cd) in ('DD','BCK'); /* I18NOK:LINE */
			quit;
			%let _tab_names=;
			proc sql noprint;
			select memname into :_tab_names separated by '|' from dictionary.tables where  /* I18NOK:LINE */
				klowcase(libname)="&rm_reporting_mart_libref." and 
					(klowcase(memname) like 'mm!_%' escape '!' or klowcase(memname) like 'mip_%' escape '!'); /* I18NOK:LINE */
			quit;
			
			/* Deletion of data from rm_rptmr library */
			%let _in = %str('MM_BINARY_TGT_FEED','MIP_ATTR_FEED','MM_CONT_TGT_FEED');
			%do c = 1 %to %eval(%sysfunc(countw(&_tab_names.,%str(|))));
					
				%let _tab_n = %qscan(%quote(&_tab_names.),&c.,%str(|));
				/* %if not(%upcase(&_tab_n.) in &_in.) %then %do; */		
				data _null_;
					if strip("&_tab_n.") in (&_in.) then
						tb_flag="Y";
					else
						tb_flag="N";
					call symputx('tb_flag', tb_flag);
				run;
				
				%if &tb_flag. eq Y %then %do;				
					proc cas;
						simple.numrows result=count /
							table={
								caslib="&rm_reporting_mart_libref.",
								name="&_tab_n.",
								where="(model_rk=&m_model_sk. and report_category_sk in (&_report_cat.))"
								};
						run;
						x = count['numrows'];
						print "rowsToDelete = " x;
						
						if x > 0 then do;
							table.deleteRows /
								table={
									caslib="&rm_reporting_mart_libref.",
									name="&_tab_n.",
									where="(model_rk=&m_model_sk. and report_category_sk in (&_report_cat.))"
									};
						end;
					quit;				
				%end;
				
				%else %do;	
					proc cas;
						simple.numrows result=count /
							table={
								caslib="&rm_reporting_mart_libref.",
								name="&_tab_n.",
								where="(model_sk=&m_model_sk. and report_category_sk in (&_report_cat.))"
								};
						run;
						x = count['numrows'];
						print "rowsToDelete = " x;
						
						if x > 0 then do;
							table.deleteRows /
								table={
									caslib="&rm_reporting_mart_libref.",
									name="&_tab_n.",
									where="(model_sk=&m_model_sk. and report_category_sk in (&_report_cat.))"
									};
						end;
					quit;		
				%end;
			%end;
			
		*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
		* Delete detail report data from rm_rptmr CAS --- Model Interpretability ;
		*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
			%let _tab_names=;
				proc sql noprint;
					select memname into :_tab_names separated by '|' from dictionary.tables where  /* I18NOK:LINE */
					klowcase(libname)="&rm_reporting_mart_libref." and (klowcase(memname) like 'mi_svi%' escape '!' or klowcase(memname) like 'mi_pdp%' escape '!'); /* I18NOK:LINE */
				quit;	
			%do c = 1 %to %eval(%sysfunc(countw(&_tab_names.,%str(|))));
						%let _tab_n = %qscan(%quote(&_tab_names.),&c.,%str(|));

				proc cas;
					simple.numrows result=count /
						table={
							caslib="&rm_reporting_mart_libref.",
							name="&_tab_n.",
							where="(model_id=&m_model_sk.)"
							};
					run;
					x = count['numrows'];
					print "rowsToDelete = " x;
					
					if x > 0 then do;
						table.deleteRows /
							table={
								caslib="&rm_reporting_mart_libref.",
								name="&_tab_n.",
								where="(model_id=&m_model_sk. )"
								};
					end;
				quit;		
			%end;
		*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
		* Delete detail report data from CORE APDM --- Model Interpretability  ;
		*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
			/****Delete from UID MASTER WILL CASCADE EFFECT IN ALL TABLES******/
			%if %kupcase(&DABT_INDB_PROCESSING_FLG) eq N %then %do;
			%let m_intprtblty_uid_sks=.;
			proc sql noprint;
				select intprtblty_uid_sk into : m_intprtblty_uid_sks separated by ',' from &lib_apdm..MI_UID_MASTER where model_Sk=&m_model_sk.;
				%let m_intprtblty_uid_sks=&m_intprtblty_uid_sks.;

				delete from &lib_apdm..MI_UID_MASTER
				where model_Sk=&m_model_sk.;
				
				delete from &lib_apdm..MI_SVI_STATS where intprtblty_uid_sk in (&m_intprtblty_uid_sks.);
				delete from &lib_apdm..MI_FIDELITY_STATS where intprtblty_uid_sk in (&m_intprtblty_uid_sks.);
				delete from &lib_apdm..MI_PDP_STATS where intprtblty_uid_sk in (&m_intprtblty_uid_sks.);
				delete from &lib_apdm..MI_LIMESHAP_STATS where intprtblty_uid_sk in (&m_intprtblty_uid_sks.);

			quit;

				proc cas;
				table.deleterows/ table={caslib="rm_rptmr", name="MI_SVI_STATS", 
				where="intprtblty_uid_sk in (&m_intprtblty_uid_sks.)"};

				table.deleterows/ table={caslib="rm_rptmr", name="MI_FIDELITY_STATS", 
				where="intprtblty_uid_sk in (&m_intprtblty_uid_sks.)"};

				table.deleterows/ table={caslib="rm_rptmr", name="MI_PDP_STATS", 
				where="intprtblty_uid_sk in (&m_intprtblty_uid_sks.)"};

				table.deleterows/ table={caslib="rm_rptmr", name="MI_LIMESHAP_STATS", 
				where="intprtblty_uid_sk in (&m_intprtblty_uid_sks.)"};

					quit;
			%end;
			%dabt_terminate_cas_session(cas_session_ref=detail_delete);
			
			%dabt_terminate_cas_session(cas_session_ref=delete_mdl_scr_abt);
		
		/********* Check whether model is of externally scored and delete respective project as well****/
		%if &m_externally_scored_flg. eq Y %then %do;
			%let m_ext_mdl_exist_flg=N;
			proc sql noprint;
				select "Y" into :m_ext_mdl_exist_flg
			from &csb_apdm_libref..model_master where model_sk=&m_model_sk.;
			quit;
			
			%let m_ext_mdl_exist_flg=&m_ext_mdl_exist_flg.;
			
			%if &m_ext_mdl_exist_flg. eq N %then %do;
				%dabt_delete_project(m_project_id=&m_mdl_project_sk., m_job_sk=&m_job_sk.,m_locale_nm=&m_locale_nm.)  ;			
			%end;
			%else %do;
				/* %put WARNING: Externally scored model &m_model_sk. exists. Unable to delete the project associated with it.; */
				%put  %sysfunc(sasmsg(SASHELP.dabt_error_messages, CSBMVA_CLEANUP_MODEL_DATA_WARNING1.1, noquote,&m_model_sk.,&m_mdl_project_sk.));				
			%end;
			
		%end;
		%else %do;
			/* %put NOTE: The specified model is not externally scored.; */
			%put  %sysfunc(sasmsg(SASHELP.dabt_error_messages, CSBMVA_CLEANUP_MODEL_DATA_NOTE1.3, noquote));				
		%end;
		
	%end; /* model exists */
	%else %do;
		/* %put ERROR: The specified model is either unavailable or not found.; */
		%sysfunc(sasmsg(SASHELP.dabt_error_messages, CSBMVA_CLEANUP_MODEL_DATA_ERROR1.1, noquote));				
	%end;	
	
	/* Set job status in APDM.JOB_MASTER */
		%dabt_update_job_status( job_sk = &m_job_sk. , return_cd = &job_rc. );
	
%mend csbmva_cleanup_model_data;