/************************************************************************************************
       Module:  dabt_scorecard_register_wrapper

     Function:  This is a wrapper macro which
					1.) Calls the macro dabt_scorecard_gen_scoring_code to generate scoring
						code for the judgemental scorecards.
					2.) Calls the macro dabt_scorecard_register_model to register the 
						scoring code generated above with SAS metadata.
					3.) Populates the corresponding APDM tables, Model_x_scr_input_variable
						and model_output_column which will be used for scoring run.

         Date:  23 July 2013
          SAS:  9.4
		  
	Sample call: 
		%csbinit();
		%let m_file_srvr_mdl_folder_path = &m_file_srvr_root_folder_nm/Model;
		%let projectSk = 9 ;
		%let  modelSk = 454; 
		%let createdByUser = fsdrisk; 
		%let jobSk = 120 ; 
		%let JOB_RC = 0 ; 
		%dabt_scorecard_register_wrapper(m_project_sk=&projectSk,m_model_sk=&modelSk,m_crt_by_usr=&createdByUser,m_job_sk=&jobSk)
		
		For modifying score.sas and opting for scr_ variables. Execute the below code.
		m_called_for_scr_var is added to delete the values from model_output_column.
		This macro is called to change the score.sas file and re-register user defined scorecard models
		to model repo.(CSB-38326)
		
		%dabt_scorecard_register_wrapper(m_model_sk=51,m_job_sk=&jobSk, m_locale_nm=&locale,m_called_for_scr_var=Y);
************************************************************************************************/
%macro dabt_scorecard_register_wrapper(m_project_sk=, m_model_sk=,m_folder_path=, m_crt_by_usr=, m_job_sk=,m_locale_nm=,m_called_for_scr_var=N);
	%let m_project_sk = &m_project_sk.;
	%let m_model_sk = &m_model_sk.;
	%let m_folder_path = &m_folder_path.;
	%let m_locale_nm=&m_locale_nm.;
	%let m_called_for_scr_var=&m_called_for_scr_var.;
	/****************************************************************
	To check null parameter passing in m_crt_by_usr and assign value to it
	*****************************************************************/
	%if &m_called_for_scr_var eq Y %then %do;
		proc sql noprint;
			select project_sk into :m_project_sk
				from &lib_apdm..model_master where model_sk=&m_model_sk.;
		quit;
		%let m_project_sk = &m_project_sk.;
	%end;
	
	%if "&m_crt_by_usr" eq "" %then %do;/* i18nOK:Line */
		%let exec_user=;
		%dabt_get_job_execution_user(job_sk=&m_job_sk.,execution_user=exec_user);
		%let m_crt_by_usr = &exec_user.;
	%end;
	%else %do;
		%let m_crt_by_usr = &m_crt_by_usr;
	%end;
	
	%let m_job_sk = &m_job_sk.;
	
	%if %symexist(job_rc)=0 %then %do;
		%global job_rc;
	%end;
	
	
		/*** CSB-31417 Supporting lockscore card API from sync to Async  ****/
		/*** Setting lock_scorecard_status_sk status as running         ****/
			proc sql noprint;
				update &lib_apdm..model_master set
				lock_scorecard_status_sk = (select status_sk from &lib_apdm..status_master
								where kupcase(strip(status_cd)) = "RUNNING")  /*i18NOK:LINE*/
				where model_sk=&m_model_sk.;
			quit;
			

	

	%dabt_scorecard_gen_scoring_code(m_project_sk=&m_project_sk.,m_model_sk=&m_model_sk.);
	
	/*%dabt_scorecard_register_model(m_project_sk=&m_project_sk., m_model_sk=&m_model_sk.,m_folder_path=%nrbquote(&m_folder_path.));*/
	

	
	%let m_tmp_lib = ;
	%let m_scr_path = ;
	%let m_tmp_lib = ;
	%let m_log_path = ;
	%let m_scoring_code_path = ;
	%let m_src_lib = ;
	
	/* obtain the apdm library and log and scratch path and library */ 
	%dabt_assign_libs(tmp_lib=m_tmp_lib,src_lib=m_src_lib, m_workspace_type=ADM, log_path=m_log_path);

	%let m_scr_path = &m_log_path.;
	%let m_src_lib = &m_src_lib.;
	%let m_tmp_lib = &m_tmp_lib.;
	%let m_log_path = &m_log_path.;
	%let m_scoring_code_path = &m_log_path.;
	
	%let m_crt_dt = %sysfunc(datetime());
	
		/* Start of part of code which was done by %dabt_scorecard_register_model() earlier*/
		proc sql noprint;
		select model_id, model_short_nm, model_desc
				into :m_model_id,:m_mdl_shrt_nm, :m_mdl_desc
			from &m_src_lib..model_master
			where model_sk = &m_model_sk.;
		quit;
		
		%let m_model_id = &m_model_id.;
		%let m_mdl_shrt_nm = %nrbquote(&m_mdl_shrt_nm.);
		%let m_mdl_desc = %nrbquote(&m_mdl_desc.);
		%let m_mdl_shrt_nm = &m_mdl_shrt_nm.;
		%let m_mdl_desc = &m_mdl_desc.;
		
		proc sql noprint;
			update &m_src_lib..Model_master
				set last_registered_model_id="&m_model_id.",/* i18nOK:Line */ 
					last_registered_model_nm="&m_mdl_shrt_nm.",/* i18nOK:Line */ 
					last_registered_dttm= datetime()
				where model_sk = &m_model_sk.;
		quit;
		
		/*Start of Update tgt var sk*/
			
		%let m_bin_chrstc_sk_lst=.;
		proc sql;

		select 
			bin_chrstc_sk into  :m_bin_chrstc_sk_lst
					separated by ','     /* i18nOK:Line */	
		from 
			&m_src_lib..mm_report_specification 
			inner join &m_src_lib..report_spec_x_bin_scheme 
				on ( mm_report_specification.report_specification_sk = report_spec_x_bin_scheme.report_specification_sk )
			inner join  &m_src_lib..bin_scheme_bin_chrstc_defn
				on (report_spec_x_bin_scheme.bin_analysis_scheme_sk = bin_scheme_bin_chrstc_defn.bin_analysis_scheme_sk)

		where mm_report_specification.model_sk=&m_model_sk. and report_specification_type_sk=1;

		quit;

		%let m_bin_chrstc_sk_lst = &m_bin_chrstc_sk_lst.;


		%let m_tgt_var_sk= .;
		proc sql;

		select 
			 variable_sk into :m_tgt_var_sk
		from 
			&m_src_lib..model_x_act_outcome_var
		where 
			model_x_act_outcome_var.model_sk=&m_model_sk.  and target_variable_flg="Y";  /* i18nOK:Line */	

		quit;

		%let m_tgt_var_sk = &m_tgt_var_sk.;

		proc sql;

		update &m_src_lib..bin_chrstc_filter_dtl
		set filter_operand_variable_sk = &m_tgt_var_sk.

		where bin_chrstc_sk in (&m_bin_chrstc_sk_lst.)

		;
		quit;
		
		
		%let m_bin_chrstc_sk_lst2=.;
		proc sql;

		select 
			bin_chrstc_sk into  :m_bin_chrstc_sk_lst2 separated by ',' /* i18nOK:Line */	
		from 
			&m_src_lib..model_x_scorecard_chrstc
			
		where model_sk=&m_model_sk. ;

		quit;

		%let m_bin_chrstc_sk_lst2 = &m_bin_chrstc_sk_lst2.;
		
		proc sql;

		update &m_src_lib..bin_chrstc_filter_dtl
		set filter_operand_variable_sk = &m_tgt_var_sk.

		where bin_chrstc_sk in (&m_bin_chrstc_sk_lst2.)

		;
		quit;
	
		/*End of Update tgt var sk*/
	
	
	/* End of part of code which was done by %dabt_scorecard_register_model() earlier*/
	
	/*All variables used to define scorecard are considered as significant*/
	proc sql noprint;
		create table &m_tmp_lib..mdl_significant_var as 
		select distinct sbg.SCRCRD_BIN_GRP_VARIABLE_SK as variable_sk, sbg.model_sk,
			&m_crt_dt. as created_dttm, "&m_crt_by_usr." as created_by_user length=32 format=$32. informat=$32.,/* i18nOK:Line */ 
			vm.variable_column_nm
		from &m_src_lib..scorecard_bin_group sbg inner join
			&m_src_lib..variable_master vm
			on (sbg.SCRCRD_BIN_GRP_VARIABLE_SK = vm.VARIABLE_SK)
		where model_sk = &m_model_sk.;
	quit;
	%dabt_err_chk(type=SQL);

	%let scoring_column_type = ;
	proc sql noprint;
		select put(scoring_output_type_sk,12.) into :scoring_column_type
			from &m_src_lib..scoring_output_type_master
			where kupcase(scoring_output_type_cd) = 'SCR_POINT';/* i18nOK:Line */ 
	quit;
	%dabt_err_chk(type=SQL);
	%let scoring_column_type = &scoring_column_type.;
	
	/* Prepare temp tabel with list of model scoring output for given scorecard model*/
	data &m_tmp_lib..mdl_outcome_var;
		length SCORING_OUTPUT_COLUMN_NM $32.  SCORING_OUTPUT_COLUMN_SHORT_NM $120. SCORING_OUTPUT_COLUMN_DESC $600. created_by_user $32. LAST_PROCESSED_BY_USER $32.;
		set &m_tmp_lib..mdl_significant_var;
		CREATED_DTTM=&m_crt_dt.;
		created_by_user="&m_crt_by_usr.";/* i18nOK:Line */ 
		LAST_PROCESSED_DTTM=&m_crt_dt.;
		LAST_PROCESSED_BY_USER="&m_crt_by_usr.";/* i18nOK:Line */ 
		MODEL_SK=&m_model_sk.;
		/* one scoring output of scorecard points for every model*/
		if _N_ = 1 then do;
			TMP_VARIABLE_SK=VARIABLE_SK;
			SCORING_OUTPUT_COLUMN_NM='SCORECARD_POINTS';/* i18nOK:Line */ 
			/*
			SCORING_OUTPUT_COLUMN_SHORT_NM="%sysfunc(sasmsg(SASHELP.dabt_scoring_output_type,SCORING_OUTPUT_TYPE_MASTER.SCR_OUTPUT_TYPE_SM3.1, noquote))";
			SCORING_OUTPUT_COLUMN_DESC="%sysfunc(sasmsg(SASHELP.dabt_scoring_output_type,SCORING_OUTPUT_TYPE_MASTER.SCR_OUTPUT_TYPE_DS3.1, noquote))";
			*/
			SCORING_OUTPUT_COLUMN_SHORT_NM="Score"; /* i18nOK:Line */
			SCORING_OUTPUT_COLUMN_DESC="Score points"; /* i18nOK:Line */
			scoring_output_type_sk=&scoring_column_type.;
			VARIABLE_SK=.;
			output;
			VARIABLE_SK=TMP_VARIABLE_SK;
		end;
		/* One group and one scoring variable. So this loop is added. */
		do i=1 to 2;
			prefix=ifc(i=1,"GRP_","SCR_");				/* i18nOK:Line */ 
			/*One group scoring output variable for every significant variable*/
			SCORING_OUTPUT_COLUMN_NM= cats(prefix,variable_column_nm);
			SCORING_OUTPUT_COLUMN_SHORT_NM= cats(prefix,variable_column_nm);/* i18nOK:Line */ 
			SCORING_OUTPUT_COLUMN_DESC= cats(prefix,variable_column_nm);/* i18nOK:Line */ 
			scoring_output_type_sk=.;
			output;
		end;
	drop prefix;
	run;
	%dabt_err_chk(type=DATA);
	
	%let m_column_data_type = ;
	proc sql noprint;
		select put(column_data_type_sk,12.) into :m_column_data_type
			from &m_src_lib..column_data_type_master
			where kupcase(column_data_type_cd) = 'NUM';/* i18nOK:Line */ 
	quit;
	%dabt_err_chk(type=SQL);
	%let m_column_data_type = &m_column_data_type.;
	
	%let m_out_src_type_sk = ;
	proc sql noprint;
		select put(mdl_output_src_type_sk,12.) into :m_out_src_type_sk
		from &m_src_lib..mdl_output_src_type_master
		where upcase(mdl_output_src_type_cd) = "SCORING_CODE"; /* i18NOK:LINE */
	quit;
	%let m_out_src_type_sk = &m_out_src_type_sk;
	
	/* Deleting the older output columns from the model output column for CSB-38326 */
	%if &m_called_for_scr_var eq Y %then %do;
		proc sql noprint;
			update &m_src_lib..scorecard_bin_group sbg
				set model_output_column_sk=.
					where model_sk=&m_model_sk.;
		quit;
		
		proc sql noprint;
			delete from &m_src_lib..model_output_column 
				where model_sk=&m_model_sk.;
		quit;
	%end;
	
	proc sql noprint;
		insert into &m_src_lib..model_output_column(SCORING_OUTPUT_COLUMN_NM, MODEL_SK, SCORING_OUTPUT_COLUMN_SHORT_NM,COLUMN_DATA_TYPE_SK,
					SCORING_OUTPUT_COLUMN_DESC, scoring_output_type_sk, MDL_OUTPUT_SRC_TYPE_SK, CREATED_DTTM, created_by_user,LAST_PROCESSED_DTTM, LAST_PROCESSED_BY_USER) 
			select SCORING_OUTPUT_COLUMN_NM, MODEL_SK, SCORING_OUTPUT_COLUMN_SHORT_NM,&m_column_data_type.,
					SCORING_OUTPUT_COLUMN_DESC, scoring_output_type_sk, &m_out_src_type_sk, CREATED_DTTM, created_by_user, LAST_PROCESSED_DTTM, LAST_PROCESSED_BY_USER  
			from &m_tmp_lib..mdl_outcome_var;
	quit;
	%dabt_err_chk(type=SQL);

	proc sql noprint;
		create table &m_tmp_lib..get_model_output_sk as
		select distinct moc.model_output_column_sk, t1.variable_sk, moc.model_sk
		from &m_src_lib..model_output_column moc inner join &m_tmp_lib..mdl_outcome_var t1
			on (moc.SCORING_OUTPUT_COLUMN_NM = t1.SCORING_OUTPUT_COLUMN_NM and
				moc.model_sk = t1.model_sk)
		where upcase(strip(t1.SCORING_OUTPUT_COLUMN_NM)) ne "EM_SCORECARD_POINTS" and substr(t1.SCORING_OUTPUT_COLUMN_NM,1,4) ne "SCR_";/* i18nOK:Line */ 
	quit;
	%dabt_err_chk(type=SQL);
	
	proc sql noprint;
		update &m_src_lib..scorecard_bin_group sbg
		set model_output_column_sk = (select b.model_output_column_sk from &m_tmp_lib..get_model_output_sk b
					where b.model_sk = sbg.model_sk and b.variable_sk = sbg.SCRCRD_BIN_GRP_VARIABLE_SK )
		where exists (select 1 from &m_tmp_lib..get_model_output_sk c
					where c.model_sk = sbg.model_sk and c.variable_sk = sbg.SCRCRD_BIN_GRP_VARIABLE_SK );
	quit;
	%dabt_err_chk(type=SQL);
	
	
	proc sql noprint;
		/*Update as significant if any existing implict variable in Model_x_scr_input_variable*/
		update &m_src_lib..model_x_scr_input_variable
			set significant_variable_flg='Y'/* i18nOK:Line */ 
			where model_sk = &m_model_sk. and 
				variable_sk in (select variable_sk from &m_tmp_lib..mdl_significant_var);
		/* If any of the scorecard variable is already present in Model_x_scr_input_variable*/
		delete from &m_tmp_lib..mdl_significant_var msv
			where msv.variable_sk in (select miv.variable_sk from &m_src_lib..Model_x_scr_input_variable miv where miv.model_sk = &m_model_sk.);
	quit;
	%dabt_err_chk(type=SQL);

	/*Insert record for non-implicit but significant variable*/
	proc sql noprint;
		insert into &m_src_lib..Model_x_scr_input_variable(model_sk, variable_sk, significant_variable_flg,
					implicit_variable_flg,CREATED_DTTM,created_by_user) 
			select MODEL_SK, variable_sk,
					'Y', 'N', &m_crt_dt.,"&m_crt_by_usr." /* i18nOK:Line */ 
			from &m_tmp_lib..mdl_significant_var;
	quit;
	%dabt_err_chk(type=SQL);

	/* If the debug flag is off then delete the temporary files */
	%if %kupcase("&DABT_RETAIN_APPL_SCRATCH_FLG") eq "N" %then %do;/* i18nOK:Line */ 
		proc sql noprint;
			drop table &m_tmp_lib..mdl_significant_var;
			drop table &m_tmp_lib..mdl_outcome_var;
			drop table &m_tmp_lib..get_model_output_sk;
		quit;
		%dabt_err_chk(type=SQL);
	%end; 
	
	%if &job_rc = 0 %then %do;
		%dabt_register_judgemental_model(m_project_sk=&m_project_sk,m_model_sk=&m_model_sk.,m_mdl_shrt_nm=&m_mdl_shrt_nm.);
	%end;
	
	/* Common code to be called after capture and register model, this contains the call to update result column macro and post action macro*/
	%dabt_post_captr_reg_comn_code(m_project_sk=&m_project_sk, m_model_sk=&m_model_sk, m_called_by_user=&m_crt_by_usr., m_called_frm_cd=REGISTER);
	
	
		/*** CSB-31417 Supporting lockscore card API from sync to Async  ****/
		/*** Setting lock_scorecard_status_sk status fail/success        ****/
		%if &job_rc LE 4 %then %do;
			proc sql noprint;
				update &lib_apdm..model_master set
				lock_scorecard_status_sk = (select status_sk from &lib_apdm..status_master
								where kupcase(strip(status_cd)) = "SUCCESS")  /*i18NOK:LINE*/
				where model_sk=&m_model_sk.;
			quit;
			
		%end;
		%else %do;
			proc sql noprint;
				update &lib_apdm..model_master set
				lock_scorecard_status_sk = (select status_sk from &lib_apdm..status_master
								where kupcase(strip(status_cd)) = "FAIL")  /*i18NOK:LINE*/
				where model_sk=&m_model_sk.;
			quit;
		%end;
	
	
	/* Set job status in APDM.JOB_MASTER */
	%dabt_update_job_status( job_sk = &m_job_sk. , return_cd = &job_rc. );
	
%mend dabt_scorecard_register_wrapper;
