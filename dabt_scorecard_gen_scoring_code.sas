/************************************************************************************************
       Module:  dabt_scorecard_gen_scoring_code

     Function:  This macro creates the SAS Scoring code for judgemental scoring.

         Date:  23 July 2013
          SAS:  9.4

************************************************************************************************/

%macro dabt_scorecard_gen_scoring_code(m_project_sk=,m_model_sk=);

	%if %symexist(job_rc)=0 %then %do;
		%global job_rc;
	%end;
	%if %symexist(sqlrc)=0 %then %do;
		%global sqlrc;
	%end;

	/* assigns the temporary library and ADM library */
	/* the workspace type to be passed to the below macro can be either BCK or PLG */

	%let m_scr_path = ;
	%let m_tmp_lib = ;
	%let m_log_path = ;
	%let m_scoring_code_path = ;
	%let m_src_lib = ;
		
	/* obtain the apdm library and log and scratch path and library */

	%dabt_assign_libs(tmp_lib=m_tmp_lib,src_lib=m_src_lib, m_workspace_type=ADM, log_path=m_log_path);

	%let m_scr_path = &m_log_path.;
	%let m_tmp_lib = &m_tmp_lib.;
	%let m_log_path = &m_log_path.;
	%let m_scoring_code_path = &m_log_path.;
	%let m_src_lib = &m_src_lib.;

	/*Get the model ID corresponding to the model SK*/
	proc sql noprint;
		select model_id into :m_model_id
			from &m_src_lib..model_master
			where model_sk = &m_model_sk.;
	quit;
	%dabt_err_chk(type=SQL);
	%let m_model_id = &m_model_id.;

	/* path where the portable files will be exported */
	%let m_scoring_code_file_nm=scoring_code_&m_model_id..sas;
	%let m_port_path = &m_scoring_code_path.;

	/*Creating a flat table containing all the details required for constructing the if-else-if expression*/
	proc sql noprint;
		create table &m_tmp_lib..SCORECARD_BIN_TMP as
		select scb.*, sbg.scrcrd_bin_grp_variable_sk as scorecard_variable_sk, 
			sbg.scrcrd_bin_grp_score_point as bin_score_point,sbg.model_sk,
			sbg.scrcrd_bin_grp_id, vm.variable_column_nm, btm.bin_type_cd
		from &m_src_lib..SCORECARD_BIN scb 
			inner join &m_src_lib..Scorecard_bin_group sbg
				on scb.scrcrd_bin_grp_sk = sbg.scrcrd_bin_grp_sk
			inner join &m_src_lib..variable_master vm
				on (sbg.scrcrd_bin_grp_variable_sk=vm.variable_sk)
			inner join &m_src_lib..bin_type_master btm
				on (btm.bin_type_sk=scb.bin_type_sk)
		where sbg.model_sk=&m_model_sk.;
	quit;
	%dabt_err_chk(type=SQL);
	
	%let m_separator=;
	data _null_;
		x= compress("&SEPARATOR_FOR_BIN_NOTATION.",''''); /* i18nOK:Line */
		call symput("m_separator",strip(x)); /* i18nOK:Line */
	run;
	%dabt_err_chk(type=DATA);

	/*Dataset that contains the actual expressions*/
	data &m_tmp_lib..score_code_exp;
		set &m_tmp_lib..SCORECARD_BIN_TMP;
		length expression $300;
		if not missing(bin_variable_value)then do;
			/*Creating scorecard expression for only those values which are character/numeric type. 
			  But the numeric type should not contain any expression like <, >, = etc. 
			  Eg. of character type - 'IND','CHINA'
			  Eg. of numeric type - 10,20,30*/
			if kindex(bin_variable_value,"'") or kindex(bin_variable_value,"""") 
				or kindexc(bin_variable_value, "<",">","=") eq 0 then do; 
				trnwr = ktranslate(bin_variable_value, ",", "&m_separator.");
				expression = kstrcat(kstrip(variable_column_nm), ' in (',kstrip(trnwr),')'); /* i18nOK:Line */
			end;
			/*Creating scorecard expression for only those values which are numeric type and
			  contain any expression like <, >, = etc. */
			else do;
				/*If the scorecard value contains expression like >=30;<50*/
				if kindexc(bin_variable_value, "<",">","=") and kindex(bin_variable_value, "&m_separator.")then do; /* i18nOK:Line */
					left = kscan(bin_variable_value, 1, "&m_separator."); /* i18nOK:Line */
					right = kscan(bin_variable_value, -1, "&m_separator."); /* i18nOK:Line */
					expression = kstrcat(kstrip(variable_column_nm), kstrip(left),' and ',kstrip(variable_column_nm), kstrip(right)); /* i18nOK:Line */
				end;
				/*If the scorecard value contains expression like >=30*/
				else do;
					trnwr = ktranslate(bin_variable_value, ",", "&m_separator."); /* i18nOK:Line */
					expression = kstrcat(kstrip(variable_column_nm),' ',kstrip(bin_variable_value)); /* i18nOK:Line */
				end;
			end;
		end;
		keep model_sk seq_no_per_var variable_column_nm bin_variable_value expression scorecard_variable_sk bin_score_point bin_type_sk scrcrd_bin_grp_id bin_type_cd;
	run;
	%dabt_err_chk(type=DATA);

	data _null_;
		file  "&m_scr_path/&m_scoring_code_file_nm"  lrecl=64000;/* i18nOK:Line */ 
		length stmt_str $32767.;
		put ;
		put '*------------------------------------------------------------*;';/* i18nOK:Line */ 
		put '* DABT JUDGEMENTAL SCORE CODE;';/* i18nOK:Line */ 
		put '*------------------------------------------------------------*;';/* i18nOK:Line */ 
		put ;
		stmt_str = 'EM_SCORECARD_POINTS = 0;';/* i18nOK:Line */ 
		put stmt_str;
	run;
	%dabt_err_chk(type=DATA);

	proc sort data = &m_tmp_lib..score_code_exp;
		by scorecard_variable_sk seq_no_per_var;
	quit;
	%dabt_err_chk(type=DATA);

	/*Logic to craete the score.sas file*/
	data _null_;
		set &m_tmp_lib..score_code_exp;
		/*Below retain statements will be used to get the expressions in proper order in the scoring code.*/
		retain count_user count_miss stmt_str_none stmt_str_miss column_nm_miss stmt_str_miss_grp stmt_str_miss_scr stmt_str_none_grp stmt_str_none_scr;
		by scorecard_variable_sk seq_no_per_var;
		file  "&m_scr_path/&m_scoring_code_file_nm"  lrecl=64000 mod;/* i18nOK:Line */ 
		length stmt_str $32767. stmt_str_none stmt_str_miss stmt_str_miss_grp stmt_str_miss_scr stmt_str_none_grp stmt_str_none_scr $200 column_nm_miss $40;
		if first.scorecard_variable_sk then do;
			put ;
			stmt_str = '* Variable: '||kstrip(variable_column_nm)||';';/* i18nOK:Line */ 
			put '*------------------------------------------------------------*;';/* i18nOK:Line */ 
			put stmt_str;
			put '*------------------------------------------------------------*;';/* i18nOK:Line */ 
			count_user=0;
			count_miss=0;
			stmt_str_none='';/* i18nOK:Line */ 
			stmt_str_miss='';/* i18nOK:Line */ 
			stmt_str_miss_grp='';/* i18nOK:Line */ 
			stmt_str_miss_scr='';/* i18nOK:Line */ 
			stmt_str_none_grp='';/* i18nOK:Line */ 
			stmt_str_none_scr='';/* i18nOK:Line */ 
			column_nm_miss='';/* i18nOK:Line */ 
		end;
		if upcase(bin_type_cd)= 'USER_DEF' then do;/* i18nOK:Line */ 
			count_user = count_user + 1;
			if count_user eq 1 then do;
				stmt_str = 'if '||" NOT MISSING("||kstrip(variable_column_nm)||") then do;";/* i18nOK:Line */ 
				put stmt_str;
				stmt_str = 'if';/* i18nOK:Line */ 
			end;
			else if count_user gt 1 then do;
				stmt_str = 'else if';/* i18nOK:Line */ 
			end;
			stmt_str = kstrip(stmt_str)||' '|| kstrip(expression) ||' then do;';/* i18nOK:Line */ 
			put stmt_str;
			stmt_str = 'EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + ' || kstrip(bin_score_point) || ' ;';/* i18nOK:Line */ 
			put stmt_str;
			stmt_str = 'GRP_'||kstrip(variable_column_nm)||' = ' || kstrip(scrcrd_bin_grp_id) || ';';/* i18nOK:Line */ 
			put stmt_str;
			/* Scoring code of UD model should have SCR_ variables having variable wise score(CSB-38146) */
			stmt_str = 'SCR_'||kstrip(variable_column_nm)||' = ' || kstrip(bin_score_point) || ';';/* i18nOK:Line */ 
			put stmt_str;
			stmt_str = 'end;';/* i18nOK:Line */ 
			put stmt_str;
			put ;
			count_user=count_user+1;
		end;
		else if upcase(bin_type_cd)= 'MISSING' then do;/* i18nOK:Line */ 
			count_miss = count_miss+1;
			column_nm_miss=variable_column_nm;
			/* To retain value of stmt_str_miss and stmt_str_miss_grp even in scenario where missing comes in 
			between and later we have bin of user defined. These retained ststements will be put to the score.sas
			file only after USER_DEF. This will ensure that no matter the order in which user has specified the 
			values, MISSING type will always come after USER_DEF.*/
			stmt_str_miss = 'EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + ' || kstrip(bin_score_point) || ' ;';/* i18nOK:Line */ 
			stmt_str_miss_grp='GRP_'||kstrip(variable_column_nm)||' = '|| kstrip(scrcrd_bin_grp_id) || ';';/* i18nOK:Line */ 
			stmt_str_miss_scr='SCR_'||kstrip(variable_column_nm)||' = '|| kstrip(bin_score_point) || ';';/* i18nOK:Line */ 
		end;
		else if upcase(bin_type_cd)= 'NONE' then do;/* i18nOK:Line */ 
			/* To retain value of stmt_str_none and stmt_str_none_grp even in scenario where missing comes in 
			between and later we have bin of user defined. These retained ststements will be put to the score.sas
			file only after USER_DEF/MISSING. This will ensure that no matter the order in which user has specified the 
			values, MISSING type will always come after USER_DEF/MISSING.*/
			stmt_str_none = 'EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + ' || kstrip(bin_score_point) || ' ;'; /* i18nOK:Line */ 
			stmt_str_none_grp='GRP_'||kstrip(variable_column_nm)||' = '|| kstrip(scrcrd_bin_grp_id) || ';'; /* i18nOK:Line */ 
			stmt_str_none_scr='SCR_'||kstrip(variable_column_nm)||' = '|| kstrip(bin_score_point) || ';'; /* i18nOK:Line */ 
		end;
		
		/* Only one missing or */
		if last.scorecard_variable_sk then do;
			/* If there at least one user defined condition for a given scorecard variable then put end to it and start else if for catch all i.e none of these */
			if count_user gt 0 then do;
				stmt_str = 'else do;';/* i18nOK:Line */ 
				put stmt_str;
				put stmt_str_none;
				put stmt_str_none_grp;
				put stmt_str_none_scr;
				stmt_str = 'end;';/* i18nOK:Line */ 
				put stmt_str;
				stmt_str = 'end;';/* i18nOK:Line */ 
				put stmt_str;
				/* Assumpation scorecard will always have either none of these or missing*/
				stmt_str = 'else if ';/* i18nOK:Line */ 
			end;
			else do;
				stmt_str = 'if ';/* i18nOK:Line */ 
			end;
			
			if count_miss gt 0 then do;
				stmt_str = kstrip(stmt_str)||' MISSING('||kstrip(column_nm_miss) ||') then do;';/* i18nOK:Line */ 
				put stmt_str;
				put stmt_str_miss;
				put stmt_str_miss_grp;
				put stmt_str_miss_scr;
				stmt_str = 'end;';/* i18nOK:Line */ 
				put stmt_str;
			end;
			if count_user gt 0 or count_miss gt 0 then do;
			/*Put else do only in case either user defined or missing condition exists. Assumption we have none of these exists. Hence doing else do for it*/
				stmt_str = 'else do;';/* i18nOK:Line */ 
				put stmt_str;
			end;
			
			/*Put condition of none of these at end for every scorecard variable (if applicable)*/
			put stmt_str_none;
			put stmt_str_none_grp;
			put stmt_str_none_scr;
			
			if count_user gt 0 or count_miss gt 0 then do;
				stmt_str = 'end;';/* i18nOK:Line */ 
				put stmt_str;
				put ;
			end;
		end;
	run;
	%dabt_err_chk(type=DATA);

	filename tmp_file "&m_scr_path./&m_scoring_code_file_nm"; /* i18nOK:Line */ 
	filename res_file "&m_port_path/score.sas";/* i18nOK:Line */ 

	/*Start of code to add prefix and suffix to the scoring code.*/

		data _null_;
    		infile tmp_file end=eof_flg;
   			file res_file;
    		input;
			if _n_ = 1 then do;
				put 'data &m_output_table_nm;';/* i18nOK:Line */ 
				put 'set &m_scoring_abt_table_nm;';/* i18nOK:Line */ 
			end;
    		put _infile_;
			if eof_flg then do;
				put 'SCORECARD_POINTS = EM_SCORECARD_POINTS;';/* i18nOK:Line */ 
				put 'run;';/* i18nOK:Line */ 
			end;
		run;
		%dabt_err_chk(type=DATA);
	/*End of code to add prefix and suffix to the scoring code.*/

	*======================================================================================================;
	* Creating filename references for scoring codes of source and destination location;
	* Copying scoring code from pyhsical folder(&m_log_path_cab) to content server;
	*======================================================================================================;
	%let m_mdl_sk_filesrv_path = %str(&m_file_srvr_mdl_folder_path/&m_model_sk.);
	
	filename inrptfl "&m_scr_path./score.sas";/* i18nOK:Line */
	filename outrptfl filesrvc folderpath="/&m_mdl_sk_filesrv_path/" filename= "score.sas" debug=http CD='attachment; filename= score.sas';/* i18nOK:Line */

	data _null_;
		rc_rpt=fcopy('inrptfl','outrptfl');/*i18NOK:LINE*/
		msg=sysmsg();
		put rc_rpt = msg=;
		if rc_rpt=0 then do;
			put "audit report file is copied to content server"; /* i18nOK:Line */
			call symput('m_error_code',0);/*i18NOK:LINE*/
		end;
		else do;
			put "Error: Failed to copy audit report to content server";/* i18nOK:Line */
			call symput('m_error_code',1012);/*i18NOK:LINE*/
		end;
	run;			
	%dabt_err_chk(type=DATA);
	
	%if &m_error_code gt 0 %then %do;
		%let job_rc = 1012;
	%end;
	
	/* If the debug flag is off then delete the temporary files */
	%if %kupcase("&DABT_RETAIN_APPL_SCRATCH_FLG") eq "N" %then %do;/* i18nOK:Line */ 
		proc sql noprint;
			drop table &m_tmp_lib..SCORECARD_BIN_TMP;
			drop table &m_tmp_lib..score_code_exp;
		quit;
		%dabt_err_chk(type=SQL);
	%end;


%mend dabt_scorecard_gen_scoring_code;
