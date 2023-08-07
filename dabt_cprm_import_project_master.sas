/********************************************************************************************************
   Module:  dabt_cprm_import_project_master

   Called by: dabt_cprm_import_project job
   Function : This macro validates if the project can be imported 
			  from the source machine to the TGT. If yes, then import the project_master.

   Parameters: INPUT: 
			1. entity_sk                   : table sk of the source machine, to be imported.
			2. import_spec_ds_nm           : dataset which contains the entity details to be imported.
			3. import_package_path 	       : Path containing the import package.
			4. import_analysis_report_path : Path where the impor analysis report is generated.
			5. import_analysis_report_ds_nm: The dataset where individual macros will insert the analysis result.
			6. mode						   : ANALYSE/EXECUTE
*********************************************************************************************************/

%macro dabt_cprm_import_project_master(	entity_sk=&enity_key., 
								import_spec_ds_nm=CPRM_IMPORT_PARAM_LIST_TMP,
								import_package_path=, 
								import_analysis_report_path=, 
								import_analysis_report_ds_nm = cprm_import_analysis_dtl,
								mode = 
								);

	/*Declare local macro variables*/
%global m_tgt_mpng_sk m_project_present_in_tgt_flg;   /**** for CSBCR-14112 source target IDs mapping ***/
	%local m_valid_flg
		m_prj_short_nm
		m_tgt_project_sk
		m_src_level_sk
		m_tgt_level_sk
		m_valid_level_flg
		m_src_purpose_sk
		m_tgt_purpose_sk
		m_valid_purpose_flg
		m_src_subject_group_sk
		m_tgt_subject_group_sk
		m_valid_subject_group_flg
		m_tgt_level_sk_check
		m_tgt_purpose_sk_check
		m_tgt_sbjct_grp_sk_check
		m_same_sbjct_grp_flg
		m_same_purpose_flg
		m_same_level_flg
		;

	%let import_analysis_report_path = &import_analysis_report_path.;
	%let import_analysis_report_ds_nm = &import_analysis_report_ds_nm.;
	%let mode = &mode.;

	%let m_valid_flg= &CHECK_FLAG_TRUE.;

	%local m_entity_type_nm m_entity_type_cd ; 

	%let m_entity_type_nm= ;
	%let m_entity_type_cd=PROJECT;
	
	proc sql noprint;
		select entity_type_nm 
			into :m_entity_type_nm
		from &lib_apdm..CPRM_ENTITY_MASTER
		where ktrim(kleft(kupcase(entity_type_cd)))=%upcase("&m_entity_type_cd.");	/* I18NOK:LINE */
	quit; 

	/*m_cprm_src_apdm- Stores libref of source apdm. dabt_assign_lib macro will assign value to this*/
	/*m_cprm_scr_lib- Stores libref for scratch. dabt_assign_lib macro will assign value to this*/
	/*m_cprm_imp_ctl- Stores libref for control library. This lib will has CPRM_IMPORT_PARAM_LIST_TMP, . dabt_assign_lib macro will assign value to this*/

	%local m_cprm_src_apdm m_cprm_scr_lib m_cprm_imp_ctl m_apdm_lib;
	%dabt_assign_libs(tmp_lib=m_cprm_scr_lib,m_workspace_type=CPRM_IMP,src_lib = m_apdm_lib,
	                                import_analysis_report_path = &import_analysis_report_path., m_cprm_src_apdm_lib= m_cprm_src_apdm, 
	                                m_cprm_ctl_lib = m_cprm_imp_ctl);


	/****************************************START OF ANALYSIS MODE*****************************************/

	%let m_prj_short_nm = ;
	proc sql noprint;
		select src_prj.project_short_nm
				into :m_prj_short_nm
			from &m_cprm_src_apdm..project_master src_prj 
			where src_prj.project_sk = &entity_sk.;
	quit;
	
	%let m_present_in_tgt= ;
	%let m_present_in_import_package= ;
	%let m_prj_short_nm = %superq(m_prj_short_nm);
	

	/*Get the project_sk on the TGT machine if the project is already present on the TGT.*/
	%let m_tgt_project_sk = ;	

	%dabt_cprm_get_entity_tgt_sk(	entity_sk = &entity_sk.,
									entity_type_cd = &m_entity_type_cd. , 
									src_apdm_lib = &m_cprm_src_apdm., 
									tgt_apdm_lib = &lib_apdm., 
									return_entity_tgt_sk = m_tgt_project_sk);


	/*Start of Validation for SOA: Validating if the SOA required for the project is 
									   present on the target.*/

	/*Get the level_sk for the project, from the source package.*/

	%let m_src_level_sk = ;

	proc sql noprint;
		select src_lvl.level_sk
				into :m_src_level_sk
			from &m_cprm_src_apdm..project_master src_prj 
				inner join &m_cprm_src_apdm..level_master src_lvl
					on src_prj.level_sk = src_lvl.level_sk
			where src_prj.project_sk = &entity_sk.;
	quit;
	%let m_src_level_sk = &m_src_level_sk.;

	/*Call macro to check if the level is present on the target or in the source package.
	  If yes, then return the target level_sk.*/
	%let m_present_in_tgt= ;
	%let m_present_in_import_package= ;

	%let m_tgt_level_sk = ;
	%let m_valid_level_flg = ;
	%dabt_cprm_check_parent_entity( 	entity_sk = &entity_sk., 
										entity_type_cd = &m_entity_type_cd., 
										assoc_entity_sk = &m_src_level_sk., 
										assoc_entity_type_cd = SOA, 
										src_apdm_lib = &m_cprm_src_apdm., 
										tgt_apdm_lib = &m_apdm_lib.,   
										mode = &mode.,
										return_assoc_entity_tgt_sk = m_tgt_level_sk,
										return_validation_rslt_flg = m_valid_level_flg);

	
	/*End of Validation for SOA*/

	/*Start of Validation for Purpose: Validating if the Purpose required for the project is 
									   present on the target.*/

	/*Get the purpose_sk for the project, from the source package.*/

	%let m_src_purpose_sk = ;

	proc sql noprint;
		select src_purp.purpose_sk
				into :m_src_purpose_sk
			from &m_cprm_src_apdm..project_master src_prj 
				inner join &m_cprm_src_apdm..purpose_master src_purp
					on src_prj.purpose_sk = src_purp.purpose_sk
			where src_prj.project_sk = &entity_sk.;
	quit;
	%let m_src_purpose_sk = &m_src_purpose_sk.;

	/*Call macro to check if the purpose is present on the target or in the source package.
	  If yes, then return the target purpose_sk.*/
	%let m_present_in_tgt= ;
	%let m_present_in_import_package= ;

	%let m_tgt_purpose_sk = ;
	%let m_valid_purpose_flg = ;
	%dabt_cprm_check_parent_entity( 	entity_sk = &entity_sk., 
										entity_type_cd = &m_entity_type_cd., 
										assoc_entity_sk = &m_src_purpose_sk., 
										assoc_entity_type_cd = PURPOSE, 
										src_apdm_lib = &m_cprm_src_apdm., 
										tgt_apdm_lib = &m_apdm_lib.,   
										mode = &mode.,
										return_assoc_entity_tgt_sk = m_tgt_purpose_sk,
										return_validation_rslt_flg = m_valid_purpose_flg);

	
	/*End of Validation for Purpose*/

	/*Start of Validation for Subject Group: Validating if the Subject Group required for the project is 
									   present on the target.*/

	/*Get the subject_group_sk for the project, from the source package.*/

	%let m_src_subject_group_sk = .;

	proc sql noprint;
		select src_sbj.subject_group_sk
				into :m_src_subject_group_sk
			from &m_cprm_src_apdm..project_master src_prj 
				inner join &m_cprm_src_apdm..subject_group_master src_sbj
					on src_prj.subject_group_sk = src_sbj.subject_group_sk
			where src_prj.project_sk = &entity_sk.;
	quit;

	/*If subject group is linked to the project then call macro to check if the Subject Group is 
		present on the target or in the source package. If yes, then return the target subject_group_sk.*/

	%if &m_src_subject_group_sk. ne . %then %do;

		%let m_present_in_tgt= ;
		%let m_present_in_import_package= ;

		%let m_tgt_subject_group_sk = .;
		%let m_valid_subject_group_flg = ;
		%dabt_cprm_check_parent_entity( 	entity_sk = &entity_sk., 
							entity_type_cd = &m_entity_type_cd., 
							assoc_entity_sk = &m_src_subject_group_sk., 
							assoc_entity_type_cd = SBJCT_GRP, 
							src_apdm_lib = &m_cprm_src_apdm., 
							tgt_apdm_lib = &m_apdm_lib.,   
							mode = &mode.,
							return_assoc_entity_tgt_sk = m_tgt_subject_group_sk,
							return_validation_rslt_flg = m_valid_subject_group_flg);

	%end;
	%else %do;
		%let m_tgt_subject_group_sk = .;
	%end;

	/*End of Validation for Subject Group*/

	/*Start: Validations if the project is already present on TGT.*/
	%if &m_tgt_project_sk. ne  %then %do;
		/*Check if level associated with the project on TGT is also the same as on SRC.*/

		%let m_tgt_level_sk_check = ;
		
		proc sql noprint;
			select tgt_lvl.level_sk
					into :m_tgt_level_sk_check
				from &m_cprm_src_apdm..project_master src_prj 
					inner join &m_cprm_src_apdm..level_master src_lvl
						on src_prj.level_sk = src_lvl.level_sk
					inner join &lib_apdm..level_master tgt_lvl
						on src_lvl.level_cd = tgt_lvl.level_cd
					inner join &lib_apdm..project_master tgt_prj
						on tgt_prj.level_sk = tgt_lvl.level_sk
							and tgt_prj.project_sk = &m_tgt_project_sk.
				where src_prj.project_sk = &entity_sk.;
		quit;

		%let m_same_level_flg = &CHECK_FLAG_FALSE;
		%if &m_tgt_level_sk_check. ne %then %do;
			%let m_same_level_flg = &CHECK_FLAG_TRUE;
		%end;

		/*Check if purpose associated with the project on TGT is also the same as on SRC.*/
		%let m_tgt_purpose_sk_check = ;
		
		proc sql noprint;
			select tgt_prp.purpose_sk
					into :m_tgt_purpose_sk_check
				from &m_cprm_src_apdm..project_master src_prj 
					inner join &m_cprm_src_apdm..purpose_master src_prp
						on src_prj.purpose_sk = src_prp.purpose_sk
					inner join &lib_apdm..purpose_master tgt_prp
						on src_prp.purpose_cd = tgt_prp.purpose_cd
					inner join &lib_apdm..project_master tgt_prj
						on tgt_prj.purpose_sk = tgt_prp.purpose_sk
							and tgt_prj.project_sk = &m_tgt_project_sk.
				where src_prj.project_sk = &entity_sk.;
		quit;

		%let m_same_purpose_flg = &CHECK_FLAG_FALSE;
		%if &m_tgt_purpose_sk_check. ne %then %do;
			%let m_same_purpose_flg = &CHECK_FLAG_TRUE;
		%end;

		/*Check if subject group associated with the project on TGT is also the same as on SRC.*/

		%let m_tgt_sbjct_grp_sk_check = ;
		%let m_same_sbjct_grp_flg = &CHECK_FLAG_FALSE;

		%let m_tgt_subject_group_present = ;

		proc sql noprint;
			select tgt_prj.subject_group_sk
					into :m_tgt_subject_group_present
				from &m_cprm_src_apdm..project_master src_prj 
					inner join &lib_apdm..project_master tgt_prj 
						on src_prj.project_short_nm = tgt_prj.project_short_nm
				where src_prj.project_sk = &entity_sk.;
		quit;

		%if (&m_src_subject_group_sk. ne . and 
				&m_tgt_subject_group_present. ne .) %then %do;
		
			proc sql noprint;
				select tgt_sbj.subject_group_sk
						into :m_tgt_sbjct_grp_sk_check
					from &m_cprm_src_apdm..project_master src_prj 
						inner join &m_cprm_src_apdm..subject_group_master src_sbj
							on src_prj.subject_group_sk = src_sbj.subject_group_sk
						inner join &lib_apdm..subject_group_master tgt_sbj
							on src_sbj.subject_group_cd = tgt_sbj.subject_group_cd
						inner join &lib_apdm..project_master tgt_prj
							on tgt_prj.subject_group_sk = tgt_sbj.subject_group_sk
								and tgt_prj.project_sk = &m_tgt_project_sk.
					where src_prj.project_sk = &entity_sk.;
			quit;

			%if &m_tgt_sbjct_grp_sk_check. ne %then %do;
				%let m_same_sbjct_grp_flg = &CHECK_FLAG_TRUE;
			%end;
		%end;
		%else %if (&m_src_subject_group_sk. eq . and 
					&m_tgt_subject_group_present. eq .) %then %do;

				%let m_same_sbjct_grp_flg = &CHECK_FLAG_TRUE;

		%end;

		%if &m_same_level_flg = &CHECK_FLAG_TRUE 
			and &m_same_purpose_flg = &CHECK_FLAG_TRUE
			and &m_same_sbjct_grp_flg = &CHECK_FLAG_TRUE %then %do;

				%let m_valid_flg= &CHECK_FLAG_TRUE.;
				%let m_present_in_tgt = &CHECK_FLAG_TRUE.;
				%let m_different_defn = &CHECK_FLAG_FALSE.;	

		%end;
		%else %do;

				%let m_valid_flg= &CHECK_FLAG_FALSE.;
				%let m_present_in_tgt = &CHECK_FLAG_TRUE.;
				%let m_different_defn = &CHECK_FLAG_TRUE.;	

		%end;

	%end; /*End: Validations if the project is already present on TGT.*/

	%else %do;
		%let m_present_in_tgt = &CHECK_FLAG_FALSE.;
		%let m_different_defn = ;
	%end;
	

	%if &mode = ANALYSE %then %do;
		%dabt_cprm_ins_pre_analysis_dtl (
							m_promotion_entity_nm=&m_prj_short_nm,
							m_promotion_entity_type_cd=&m_entity_type_cd,
							m_assoc_entity_nm=&m_prj_short_nm ,
							m_assoc_entity_type_cd=&m_entity_type_cd,
							m_present_in_tgt_flg= &m_present_in_tgt.,
							m_present_in_import_package_flg= &CHECK_FLAG_TRUE.,
							m_different_defn_flg = &m_different_defn.
						);
	%end;

	/* Custom Script: Change */
	/* 
	This case is for Project not present in the target Environment.
	Then the all the scripts associated to the project will be
	appear in the pre analysis report with their respective 
	flags.
	*/
	
	%macro source_tgt_script(_script_lib_nm=,_script_entity_sk=,_presence=,_mode=);
		
		%let _script_entity_sk=&_script_entity_sk.;
		%Let _presence=&_presence.;
		%let _script_lib_nm=&_script_lib_nm.;
		
		%if &_presence eq %then %do;
			%let _script_tbl_nm=src;
		%end;
		%else %do;
			%let _script_tbl_nm=%str(src,tgt);
		%end;	
	
		%do i= 1 %to %sysfunc(countw(&_script_tbl_nm));		/* Do Loop Start */
			
			%let _script_tbl_=%scan(&_script_tbl_nm,&i.,%str(,));					/* i18nok:line */
			%let _script_lib_nm_=%scan(&_script_lib_nm,&i.,%str(,));				/* i18nok:line */
			%let _script_entity_sk_=%scan(&_script_entity_sk,&i.,%str(,));			/* i18nok:line */

			proc sql;
			create table &_script_tbl_._script_tmp_&entity_sk. as 
			select 
				pm.project_short_nm as Promotion_entity_nm,
				"&M_ENTITY_TYPE_CD" as promotion_entity_type_cd,							/* I18NOK:LINE */
				ecm.external_code_short_nm as ASSOC_ENTITY_NM,
				"SCRIPT" as ASSOC_ENTITY_TYPE_CD,											/* I18NOK:LINE */
				ecm.external_code_sk,
				eco.objective_cd
				from &_script_lib_nm_..external_Code_Assoc eca
				inner join &_script_lib_nm_..external_code_master ecm
				on eca.ext_code_Sk=ecm.external_code_sk
				inner join &_script_lib_nm_..external_code_Versions ecv
				on ecm.external_code_sk=ecv.external_code_Sk
				inner join &_script_lib_nm_..external_code_objective eco
				on ecm.objective_sk=eco.objective_sk
				inner join &_script_lib_nm_..project_master pm
				on eca.entity_sk=pm.project_sk
				where ext_code_entity_type_param_sk in 
				(select ref_parameter_sk from &_script_lib_nm_..REFERENCE_PARAMETER_VALUE
					where parameter_type_cd_txt="SCRIPT_ASSOCIATED_ENTITY_TYPE_CD" and 						/* i18nOK:Line */
					parameter_value_cd_txt="PROJECT"														/* i18NOK:LINE */
				)
				and pm.project_sk = &_script_entity_sk_.
				and ecm.template_flg=&CHECK_FLAG_FALSE.;							
			quit;

			%if &_script_tbl_. ne src %then %do;
				proc sql noprint;
					create table EXT_CODE_MODEL_USAGE as 
						select distinct external_code_sk from &m_apdm_lib..VW_EXT_CODE_MODEL_USAGE;
				quit;
				
				proc sql noprint;
					create table &_script_tbl_._script_&entity_sk. as 
						select 
							a.*,
							case 
								when b.external_code_sk is null then &CHECK_FLAG_FALSE else &CHECK_FLAG_TRUE
							end as REFERRED_IN_OTHER_ENTITY_FLG
						from &_script_tbl_._script_tmp_&entity_sk. a
							left join EXT_CODE_MODEL_USAGE b
							on a.external_code_sk = b.external_code_sk;
				quit;
			%end;
								
		%end;	/* Do Loop End */
		
		%if &_presence eq %then %do;		/* Checking for the presence of the target project */
			proc sql noprint;
				select count(*) into :_src_cnt from src_script_tmp_&entity_sk.;								/* I18NOK:LINE */
			quit;
			
			/*
			Bring distinct values to the table
			as external variables were part of the source table
			being used in the below query. To get script level values.
			*/
			
			proc sql noprint;
			create table src_script_&entity_sk. as 
			select distinct
				Promotion_entity_nm,
				promotion_entity_type_cd,
				ASSOC_ENTITY_NM,
				ASSOC_ENTITY_TYPE_CD,
				&CHECK_FLAG_FALSE. AS REFERRED_IN_OTHER_ENTITY_FLG
			from src_script_tmp_&entity_sk.;
			quit;
			
			%do i=1 %to %eval(&_src_cnt.);	/* Do Loop End */
				/* i18NOK:BEGIN */
				data _null_;
				c=&i.;
				set src_script_&entity_sk. point=c;
				call symputx('m_prj_short_nm',Promotion_entity_nm);
				call symputx('m_entity_type_cd',promotion_entity_type_cd);
				call symputx('_assoc_entity_nm',ASSOC_ENTITY_NM);					
				call symputx('_assoc_entity_type_cd',ASSOC_ENTITY_TYPE_CD);
				call symputx('m_present_in_tgt',"&CHECK_FLAG_FALSE.");
				call symputx('_referred_in_other_entity_flg',cats("'",REFERRED_IN_OTHER_ENTITY_FLG,"'"));
				call symputx('m_different_defn',"&CHECK_FLAG_FALSE.");
				call symputx('_addnl_info','');
				stop;
				run;
				/* i18NOK:END */
				
				%if &_mode = ANALYSE %then %do;
					%dabt_cprm_ins_pre_analysis_dtl (
										m_promotion_entity_nm=&m_prj_short_nm,
										m_promotion_entity_type_cd=&m_entity_type_cd,
										m_assoc_entity_nm=&_assoc_entity_nm ,
										m_assoc_entity_type_cd=&_assoc_entity_type_cd,
										m_present_in_tgt_flg= &m_present_in_tgt.,
										m_present_in_import_package_flg= &CHECK_FLAG_TRUE.,
										m_referred_in_other_entity_flg=&_referred_in_other_entity_flg,
										m_different_defn_flg = &m_different_defn.,
										m_addnl_info=&_addnl_info.
									);
				%end;	/* ANALYSE END */				
				
			%end; /* Do Loop End */
		%end;
		
		%if &_presence ne %then %do;
			proc sql noprint;
			create table src_tgt_tbl_&entity_sk. as 
			select 
				distinct
				coalesce(a.Promotion_entity_nm,b.Promotion_entity_nm) as Promotion_entity_nm_src,
				coalesce(a.promotion_entity_type_cd,b.promotion_entity_type_cd) as promotion_entity_type_cd_src,
				coalesce(a.ASSOC_ENTITY_NM,b.ASSOC_ENTITY_NM) as ASSOC_ENTITY_NM_src,
				coalesce(a.ASSOC_ENTITY_TYPE_CD,b.ASSOC_ENTITY_TYPE_CD) as ASSOC_ENTITY_TYPE_CD_src,
				case when b.ASSOC_ENTITY_NM is null then &CHECK_FLAG_FALSE else &CHECK_FLAG_TRUE. end as present_in_tgt_flg,
				case when a.ASSOC_ENTITY_NM is null then &CHECK_FLAG_FALSE else &CHECK_FLAG_TRUE. end as present_in_import_package_flg,
				case when b.REFERRED_IN_OTHER_ENTITY_FLG=&CHECK_FLAG_TRUE then &CHECK_FLAG_TRUE else &CHECK_FLAG_FALSE. end as referred_in_other_entity_flg,
				case when ktrim(kupcase(a.objective_cd))=ktrim(kupcase(b.objective_cd)) or a.objective_cd is null then &CHECK_FLAG_FALSE else &CHECK_FLAG_TRUE. end as different_defn_flg											/* I18NOK:LINE */
			from 
				work.src_script_tmp_&entity_sk. a
			full outer join 
				work.tgt_script_&entity_sk. b
			on ktrim(kleft(kupcase(a.Promotion_entity_nm)))=ktrim(kleft(kupcase(b.Promotion_entity_nm)))
			and ktrim(kleft(kupcase(a.ASSOC_ENTITY_NM)))=ktrim(kleft(kupcase(b.ASSOC_ENTITY_NM)))
			/*where a.Promotion_entity_nm is not null */
			;
			quit;
			
		
			proc sql noprint;
				select count(*) into :_all_cnt from src_tgt_tbl_&entity_sk.;								/* I18NOK:LINE */
			quit;
				
			%do i=1 %to %eval(&_all_cnt.);	/* Do Loop End */
				/* i18NOK:BEGIN */
				data _null_;
				c=&i.;
				set src_tgt_tbl_&entity_sk. point=c;
				call symputx('m_prj_short_nm',Promotion_entity_nm_src);
				call symputx('m_entity_type_cd',promotion_entity_type_cd_src);
				call symputx('_assoc_entity_nm',ASSOC_ENTITY_NM_src);					
				call symputx('_assoc_entity_type_cd',ASSOC_ENTITY_TYPE_CD_src);
				call symputx('m_present_in_tgt',cats("'",present_in_tgt_flg,"'"));
				call symputx('_present_in_import',cats("'",present_in_import_package_flg,"'"));					
				call symputx('_referred_in_other_entity_flg',cats("'",REFERRED_IN_OTHER_ENTITY_FLG,"'"));
				call symputx('m_different_defn',cats("'",different_defn_flg,"'"));
				call symputx('_addnl_info','');
				stop;
				run;
				/* i18NOK:END */
				
				%if &_mode = ANALYSE %then %do;
					%dabt_cprm_ins_pre_analysis_dtl (
										m_promotion_entity_nm=&m_prj_short_nm,
										m_promotion_entity_type_cd=&m_entity_type_cd,
										m_assoc_entity_nm=&_assoc_entity_nm ,
										m_assoc_entity_type_cd=&_assoc_entity_type_cd,
										m_present_in_tgt_flg= &m_present_in_tgt.,
										m_present_in_import_package_flg= &_present_in_import.,
										m_referred_in_other_entity_flg=&_referred_in_other_entity_flg,
										m_different_defn_flg = &m_different_defn.,
										m_addnl_info=&_addnl_info.
									);
				%end;	/* ANALYSE END */				
				
			%end; /* Do Loop End */				
		%end;
	%mend source_tgt_script;
	/* This macro is designed for custom script pre analysis report */
	%source_tgt_script(_script_lib_nm=%quote(&m_cprm_src_apdm.,&lib_apdm.),_script_entity_sk=%quote(&entity_sk.,&m_tgt_project_sk),_presence=&m_tgt_project_sk.,_mode=&mode.);
	

	%if &m_valid_level_flg. = &CHECK_FLAG_FALSE or
		&m_valid_purpose_flg. = &CHECK_FLAG_FALSE or
		&m_valid_subject_group_flg. = &CHECK_FLAG_FALSE %then %do;

			%let m_valid_flg= &CHECK_FLAG_FALSE.;

	%end;
	/****************************************END OF ANALYSIS MODE*****************************************/


	/****************************************START OF EXECUTE MODE****************************************/

	/*If the mode is execute and all the validations have passed then execute the below block*/

	%if &mode = EXECUTE and &m_valid_flg. = &CHECK_FLAG_TRUE. and &syscc le 4 %then %do;

		%if &m_tgt_project_sk. ne %then %do; 
 
			%let upd_cols_project_master = ;
			%dabt_cprm_get_col_lst(	m_ds_nm=project_master, 
									m_src_lib_nm=&m_cprm_src_apdm, 
									m_tgt_lib_nm=&lib_apdm, 
									m_exclued_col= project_sk purpose_sk level_sk subject_group_sk project_id project_short_nm authorization_rule_id owned_by_user lineage_status_sk, 
									m_col_lst=, 
									m_prim_col_nm=project_sk, 
									m_prim_col_val=&entity_sk,
									m_upd_cols_lst= upd_cols_project_master
								  );

			/*Delete the records from source_table_x_level*/
			proc sql;
				update &lib_apdm..project_master
					set &upd_cols_project_master 
					where project_sk = &m_tgt_project_sk.; 
			quit;
			%let m_tgt_mpng_sk=&m_tgt_project_sk.;   /*** CSBCR-14112****/
			
			%let trgt_owned_by=;
			proc sql noprint;
			select owned_by_user into :trgt_owned_by from &lib_apdm..project_master 
			where project_sk=&m_tgt_project_sk.;
			quit;
			
			/*Update last processed dttm as part of defect*/
			proc sql;
				update &lib_apdm..project_master
					set last_processed_dttm="%sysfunc(datetime(),DATETIME.)"dt /* i18nok:line */ 
					where project_sk = &m_tgt_project_sk.; 
			quit;
			
			%if "&trgt_owned_by" ne "&owned_by" %then %do;						/* i18nok:line */
				%dabt_change_project_ownership(project_id=&m_tgt_project_sk., change_owner_to=&owned_by);
			%end;
		%end;

		%else %do;
	
			/*Start: Insert records in the project_master.*/
			%let ins_cols_project_master = ;
			%dabt_cprm_get_col_lst(	m_ds_nm=project_master, 
									m_src_lib_nm=&m_cprm_src_apdm, 
									m_tgt_lib_nm=&lib_apdm, 
									m_exclued_col= project_sk purpose_sk level_sk subject_group_sk project_id authorization_rule_id lineage_status_sk, 
									m_col_lst=, 
									m_prim_col_nm=project_sk, 
									m_prim_col_val=&entity_sk,
									m_ins_cols_lst= ins_cols_project_master
								  );
			
			%let m_next_project_sk = .;
			proc sql;
				&apdm_connect_string.; 
					select 
						temp into :m_next_project_sk
					from 
						connection to postgres 
						( 
							select nextval( %nrbquote('&apdm_schema..project_master_project_sk_seq') ) as temp
						);
				&apdm_disconnect_string.; 
			quit;

			%let m_next_project_sk = &m_next_project_sk.;

			%let m_tgt_project_sk = &m_next_project_sk.;
			
			
			%let m_tgt_mpng_sk=&m_next_project_sk.;
			
			proc sql noprint;
		       insert into &lib_apdm..project_master 
				(project_sk, &ins_cols_project_master., purpose_sk, level_sk, 
					subject_group_sk, project_id) 
		       select &m_next_project_sk., &ins_cols_project_master., &m_tgt_purpose_sk., &m_tgt_level_sk., 
					&m_tgt_subject_group_sk., "&m_next_project_sk."
		       	from &m_cprm_src_apdm..project_master src
		       	where src.project_sk = &entity_sk.; 
			quit; 

		proc sql;
			update &lib_apdm..PARAMETER_VALUE_DTL set parameter_value='Y' 
					where parameter_nm='MIGRATION_IN_PROGRESS_FLAG';
		quit;
		
		
		
		/*???We need to check and call api that would create a folder on content under project*/
		
		/*%dabt_make_work_area(dir=&project_path., create_dir=&m_tgt_project_sk./application/log, path=prj_path);
		%dabt_make_work_area(dir=&project_path., create_dir=&m_tgt_project_sk./application/scratch, path=prj_path);*/
	
		%dabt_change_project_ownership(project_id=&m_tgt_project_sk., change_owner_to=&owned_by);
		
		proc sql;
			update &lib_apdm..PARAMETER_VALUE_DTL set parameter_value='N' 
					where parameter_nm='MIGRATION_IN_PROGRESS_FLAG';
		quit;
		
		/*Update current date as created_dttm and last_processed_dttm as part of defect*/
		proc sql;
				update &lib_apdm..project_master
					set last_processed_dttm="%sysfunc(datetime(),DATETIME.)"dt ,created_dttm="%sysfunc(datetime(),DATETIME.)"dt /* i18nok:line */
					where project_sk = &m_tgt_project_sk.; 
			quit;
		
		%end;
		
		/* Custom Script: Change */
		/* 
			This code facilitates the import of scripts of non template flags.
			This code inserts data to 
				*External_code_assoc
				*External_Code_master
				*External_code_versions
				*External_variable_master
			if not present or updates it if present.
		*/			
		%let _dist_ext_cnt=0;
		proc sql noprint;
			select count(distinct external_code_sk) into :_dist_ext_cnt from  		/* i18nok:line */
				src_script_tmp_&entity_sk.;
		quit;
		
		proc sql noprint;
			create table script_sk_loop as 
				select distinct external_code_sk,ASSOC_ENTITY_NM
					from src_script_tmp_&entity_sk.;
		quit;
					
		
		%do i = 1 %to %eval(&_dist_ext_cnt.);	/* Loop Start for Script insert or update */
				
			data _null_;
			c=&i.;
			set script_sk_loop point=c;
			call symputx('_ext_sk_',external_code_sk);									/* i18nok:line */
			call symputx('_ext_script_nm_',	ktrim(kleft(kupcase(ASSOC_ENTITY_NM))));	/* i18nok:line */
			stop;
			run;
			
			%let m_tgt_entity_sk=;
			%let m_src_entity_sk=;
			
			%if &m_tgt_project_sk. ne %then %do;
				proc sql noprint;
					select tgt_ext_cd.external_Code_Sk,src_ext_cd.external_code_sk into :m_tgt_entity_sk,:m_src_entity_sk
						from 
							&m_apdm_lib..external_code_master tgt_ext_cd
						inner join &m_cprm_src_apdm..external_code_master src_ext_cd
								on(tgt_ext_cd.external_code_short_nm=src_ext_cd.external_code_short_nm)
						inner join &m_apdm_lib..external_Code_Assoc eca
								on(tgt_ext_cd.external_code_sk=eca.ext_code_sk)
						inner join &m_apdm_lib..project_master pm 
								on(eca.entity_sk=pm.project_sk)
						where ktrim(kleft(kupcase(src_ext_cd.external_code_short_nm)))=ktrim(kleft(kupcase("&_ext_script_nm_.")))
							and tgt_ext_cd.template_flg=&CHECK_FLAG_FALSE and src_ext_cd.template_flg=&CHECK_FLAG_FALSE
								and pm.project_sk=&m_tgt_project_sk;
				quit;

				%let m_tgt_entity_sk=&m_tgt_entity_sk.;
				%let m_src_entity_sk=&m_src_entity_sk.;
			%end;
		
			%let _ref_param_Sk=;
			proc sql noprint;
				select ref_parameter_sk into :_ref_param_Sk from &m_apdm_lib..REFERENCE_PARAMETER_VALUE
					where parameter_type_cd_txt="SCRIPT_ASSOCIATED_ENTITY_TYPE_CD" and 						/* i18nOK:Line */
							parameter_value_cd_txt="PROJECT"												/* i18nok:line */
					;
			quit;
			%let _ref_param_Sk=&_ref_param_Sk.;	
			
			/*
			If target external sk is present then the code will update the tables.
			m_tgt_entity_sk here is target external_code_sk
			*/
			%if &m_tgt_entity_sk. ne %then %do;
				
				%let m_project_present_in_tgt_flg=Y;
				/*
				Delete those external code variables which are present only on TGT.
					and are not being used in any model.
				
				TODO: Check whether to stop the process if the variables are being used in model.
					  as we are replacing the script. (one code_sk - Multiple ext variables)
				*/
				
				proc sql noprint;
					create table EXT_VAR_MODEL_USAGE as 
						select distinct external_variable_sk from &m_apdm_lib..VW_EXT_VAR_MODEL_USAGE;
				quit;
				
				%let _ext_var_sk_only_in_tgt=;
				proc sql noprint;
					select tgt.external_variable_sk into :_ext_var_sk_only_in_tgt separated by ','			/*i18NOK:LINE*/
						from &m_apdm_lib..external_variable_master tgt
						left join EXT_VAR_MODEL_USAGE evmu
						on tgt.external_variable_sk=evmu.external_variable_sk
						left join &m_apdm_lib..external_code_master ecm
						on tgt.external_code_sk=ecm.external_code_sk
						where kstrip(kupcase(tgt.external_variable_column_nm)) not in
															(select kstrip(kupcase(src.external_variable_column_nm)) from
																&m_cprm_src_apdm..external_variable_master src
																	where src.external_code_sk = &m_src_entity_sk.)
						and tgt.external_code_sk = &m_tgt_entity_sk.
						and evmu.external_variable_sk is null
						and ecm.template_flg=&CHECK_FLAG_FALSE;
				quit;

				/* Deletion of variables present in target but not present in source */
				%if &_ext_var_sk_only_in_tgt. ne %then %do; 
					proc sql noprint;
						delete from &m_apdm_lib..external_variable tgt 
							where tgt.external_variable_sk in (&_ext_var_sk_only_in_tgt.);
						delete from &m_apdm_lib..external_variable_master tgt 
							where tgt.external_variable_sk in (&_ext_var_sk_only_in_tgt.);
					quit;
				%end;	
				
				/*
				Delete entries from external_code_assoc when target script is not being used in a model
					and only present in the target not source.
				*/				
				
				%let _del_ext_code_sk=;
				%let _del_ext_file_id=;
				
				proc sql noprint;
					create table EXT_CODE_MODEL_USAGE as 
						select distinct external_code_sk from &m_apdm_lib..VW_EXT_CODE_MODEL_USAGE;
				quit;
				
				proc sql noprint;
				select 
					teca.ext_code_sk,
					tecv.file_id into 
					:_del_ext_code_sk separated by ',' , 				/* i18nok:line */
					:_del_ext_file_id separated by '|'  				/* i18nok:line */
				from &m_apdm_lib..external_code_assoc teca
				inner join &m_apdm_lib..external_code_master tecm
				on teca.ext_code_sk=tecm.external_Code_sk
				left join EXT_CODE_MODEL_USAGE tecmu
				on teca.ext_code_sk=tecmu.external_code_sk
				left join &m_apdm_lib..external_code_versions tecv
				on teca.ext_code_sk=tecv.external_code_sk
				where kstrip(kupcase(tecm.external_code_short_nm)) not in 
							(select kstrip(kupcase(external_code_short_nm))
								from &m_cprm_src_apdm..external_code_assoc seca
								inner join &m_cprm_src_apdm..external_code_master secm
								on seca.ext_code_sk=secm.external_Code_sk
								where seca.entity_sk=&entity_sk.
							)
						and teca.entity_sk=&m_tgt_project_sk.
						and tecmu.external_code_sk is null
						and teca.ext_code_entity_type_param_sk=&_ref_param_sk.
						and tecm.template_flg=&CHECK_FLAG_FALSE.;
				quit;	
				
				%if &_del_ext_code_sk ne %then %do;
					proc sql noprint;
						delete from &m_apdm_lib..external_code_assoc
							where ext_code_entity_type_param_sk=&_ref_param_sk.
								and entity_sk=&m_tgt_project_sk.
								and ext_Code_sk in (&_del_ext_code_sk.);
						delete from &m_apdm_lib..external_code_versions
							where external_code_sk in (&_del_ext_code_sk.);
						delete from &m_apdm_lib..external_code_master
							where external_code_sk in (&_del_ext_code_sk.);
						/* Custom Script: Start */
						/*
							PMRM261_TODO: Deleting the external codes which are not present in the source but 
											present on the target machine.
						*/
						delete from &m_apdm_lib..external_code_dependency
							where external_code_sk in (&_del_ext_code_sk.);
						/* Custom Script: End */						
					quit;
					%dabt_err_chk(type=SQL);		

					%Let _cnt_file_id=%eval(%sysfunc(countc(&_del_ext_file_id,%str(|)))+1);		/* i18nok:line */

					%do file=1 %to &_cnt_file_id.;
						%let _del_file_id=%scan(&_del_ext_file_id,&file.,%str(|));
						%dabt_cprm_proc_http(_fileid=&_del_file_id.,_fileref=,_method=DELETE,_out=_out_id);
					%end;		
				%end;	/* End of delete from assoc,versions,master */					

				%let upd_cols_lst = ;
				%dabt_cprm_get_col_lst(	m_ds_nm=external_code_master, 
										m_src_lib_nm=&m_cprm_src_apdm, 
										m_tgt_lib_nm=&m_apdm_lib, 
										m_exclued_col= external_code_file_loc external_code_sk external_code_id level_sk created_by_user last_processed_dttm vldn_job_sk,
										m_col_lst=, 
										m_prim_col_nm=external_code_sk, 
										m_prim_col_val=&m_src_entity_sk,
										m_ins_cols_lst=,
										m_upd_cols_lst=upd_cols_lst
				);

				proc sql noprint ; 
					update &m_apdm_lib..external_code_master tgt	
					set &upd_cols_lst ,
						external_code_file_loc = '&DABT_EXTERNAL_CODE_PATH_LOCATION.' /* i18nok:line */
					where tgt.external_code_sk = &m_tgt_entity_sk; 
				quit;

				/*Update last processed dttm as part of defect*/
				proc sql noprint ; 
					update &m_apdm_lib..external_code_master tgt	
					set last_processed_dttm="%sysfunc(datetime(),DATETIME.)"dt /* i18nok:line */
					where tgt.external_code_sk = &m_tgt_entity_sk  ; 
				quit;

				/*Extract file id from external_code_versions and pass it to proc http*/
				%let _file_id=;
				proc sql noprint;
					select file_id into :_file_id from &m_apdm_lib..external_code_versions
						where external_code_sk=&m_tgt_entity_sk;
				quit;
				%let _file_id=&_file_id.;

				%if "&_file_id." ne "" %then %do;
					filename source filesrvc folderpath="&IMPORT_PACKAGE_PATH." filename="&_ext_script_nm_..sas" debug= http;	/* i18nok:line */
					
					%dabt_cprm_proc_http(_fileid=&_file_id.,_fileref=source,_method=PUT,_out=_out_id);
				%end;				

				/*
				update those external code variables which are present in both source and TGT.
				*/

				%let _ext_var_nm_src_and_tgt = ; 
				%let _ext_var_sk_src_and_tgt = ;

				proc sql noprint;
					select tgt.external_variable_column_nm, tgt.external_variable_sk 
							into :_ext_var_nm_src_and_tgt separated by ',' , :_ext_var_sk_src_and_tgt separated by ','		/*i18NOK:LINE*/
						from &m_apdm_lib..external_variable_master tgt
						left join &m_apdm_lib..external_code_master ecm
						on tgt.external_code_sk=ecm.external_code_sk							
						where tgt.external_variable_column_nm in (select src.external_variable_column_nm from
															&m_cprm_src_apdm..external_variable_master src
															where src.external_code_sk = &m_src_entity_sk.)
						and tgt.external_code_sk = &m_tgt_entity_sk.
						and ecm.template_flg=&CHECK_FLAG_FALSE;
				quit; 			
				/*Execution starts for variables _ext_var_sk_src_and_tgt */	
				%if &_ext_var_sk_src_and_tgt. ne %then %do;
		
					%let _src_count = %eval(%sysfunc(countc(%quote(&_ext_var_sk_src_and_tgt.), ','))+1);			/*i18NOK:LINE*/	
		
					%do count = 1 %to &_src_count;
						%let _src_tgt_ext_var_sk_tkn = %scan(%quote(&_ext_var_sk_src_and_tgt.),&count,%str(,)); /* i18nOK:Line */
						%let _src_tgt_ext_var_nm_tkn = %scan(%quote(&_ext_var_nm_src_and_tgt.),&count,%str(,)); /* i18nOK:Line */
						
						%let _src_ext_var_sk=;
						proc sql;
						select src.external_variable_sk into :_src_ext_var_sk from
							&m_cprm_src_apdm..external_variable_master src
							where src.external_code_sk = &m_src_entity_sk. and src.external_variable_column_nm="&_src_tgt_ext_var_nm_tkn";		/* i18nok:line */
						quit;
						
						/*Get the list of external code variables to be updated, from external_variable_master*/
						%let upd_cols_table = ;
						%dabt_cprm_get_col_lst(	m_ds_nm=external_variable_master, 
												m_src_lib_nm=&m_cprm_src_apdm, 
												m_tgt_lib_nm=&m_apdm_lib, 
												m_exclued_col= external_variable_sk external_code_sk, 
												m_col_lst=, 
												m_prim_col_nm=external_variable_sk, 
												m_prim_col_val=&_src_ext_var_sk, 
												m_upd_cols_lst= upd_cols_table
											  );
		
						proc sql noprint;
							update &m_apdm_lib..external_variable_master tgt 
								set &upd_cols_table. ,external_code_sk=&m_tgt_entity_sk
								where tgt.external_variable_sk = &_src_tgt_ext_var_sk_tkn.;
						quit;
					%end;/*Loop end for processing of variables _ext_var_sk_src_and_tgt */
				%end;
				
				
				/* If the script is present on the target machine the following code will insert the missing variable from the script to the target. */
				%let _ext_var_nm_only_in_src = ;
				%let _ext_var_sk_only_in_src = ;				
				proc sql;
					select src.external_variable_column_nm, src.external_variable_sk 
							into :_ext_var_nm_only_in_src separated by ',', :_ext_var_sk_only_in_src separated by ','			/*i18NOK:LINE*/
						from &m_cprm_src_apdm..external_variable_master src
						where src.external_code_sk = &m_src_entity_sk. and kupcase(kstrip(external_variable_column_nm))
							not in (select kupcase(kstrip(external_variable_column_nm)) 
											from &m_apdm_lib..external_variable_master
												where external_code_sk=&m_tgt_entity_sk.);
				quit;			

				/*Execution Starts  for variables _ext_var_sk_only_in_src */
				%if &_ext_var_sk_only_in_src. ne %then %do;
					%let _src_count=;
					%let _src_count = %eval(%sysfunc(countc(%quote(&_ext_var_sk_only_in_src.), ','))+1);		/*i18NOK:LINE*/

					%do count = 1 %to &_src_count;
						%let _src_ext_var_sk_tkn = %scan(%quote(&_ext_var_sk_only_in_src.),&count,%str(,)); /* i18nOK:Line */

						/*Get the list of external code variables to be updated, from external_variable_master*/
						%let ins_cols_lst = ;
						%dabt_cprm_get_col_lst(	m_ds_nm=external_variable_master, 
												m_src_lib_nm=&m_cprm_src_apdm, 
												m_tgt_lib_nm=&m_apdm_lib, 
												m_exclued_col= external_variable_sk external_code_sk, 
												m_col_lst=, 
												m_prim_col_nm=external_variable_sk, 
												m_prim_col_val=&_src_ext_var_sk_tkn, 
												m_ins_cols_lst= ins_cols_lst
											  );
											  
						%let m_next_ext_var_sk = .;
						proc sql;
							&apdm_connect_string.; 
								select 
									temp into :m_next_ext_var_sk
								from 
									connection to postgres 
									( 
										select nextval( %nrbquote('&apdm_schema..external_variable_master_external_variable_sk_seq') ) as temp
									);
							&apdm_disconnect_string.; 
						quit;

						%let m_next_ext_var_sk = &m_next_ext_var_sk.;
						
						proc sql noprint ;
							insert into &m_apdm_lib..external_variable_master 
									(external_variable_sk,&ins_cols_lst , external_code_sk)
								select &m_next_ext_var_sk.,&ins_cols_lst, &m_tgt_entity_sk. as external_code_sk
										from  &m_cprm_src_apdm..external_variable_master src
									where src.external_variable_sk eq &_src_ext_var_sk_tkn.;
						quit;
					%end;/*Loop end for processing of variables m_ext_var_sk_only_in_src */	
				%end; /*End:Conditional processing of  variables present on both source and target */										
				
			%end;
			/*
			If target external sk is not present then the code will insert the records into the tables.
			*/					
			%else %do;
				%let m_project_present_in_tgt_flg=N;
				
				%let ins_cols_lst = ;
				%dabt_cprm_get_col_lst(	m_ds_nm=external_code_master, 
										m_src_lib_nm=&m_cprm_src_apdm, 
										m_tgt_lib_nm=&m_apdm_lib, 
										m_exclued_col= external_code_file_loc external_code_sk external_code_id vldn_job_sk created_by_user,
										m_col_lst=, 
										m_prim_col_nm=, 
										m_prim_col_val=,
										m_ins_cols_lst=ins_cols_lst,
										m_upd_cols_lst=
									  );
				
				proc sql noprint ;
					   insert into &m_apdm_lib..external_code_master
						(&ins_cols_lst, external_code_file_loc,external_code_id,level_sk,created_by_user) 
						   select 
							 &ins_cols_lst, 
								'&DABT_EXTERNAL_CODE_PATH_LOCATION.' as external_code_file_loc, /* i18nok:line */
								"src_&entity_sk." as external_code_id  /* i18nok:line */
							/*External code id is hardcoded "src_&entity_sk." to avoid unique constraint failure on tgt machine*/
								,&m_tgt_level_sk. as level_sk
								,"&sysuserid." as created_by_user								/*i18NOK:LINE*/
						   from 
								&m_cprm_src_apdm..external_code_master src 
						   where 
								src.external_code_sk = &_ext_sk_. ; 
				quit;
				%dabt_err_chk(type=SQL);

				/*Updating external_code_id based on last insert record in external_code_master on tgt machine */

				proc sql noprint;
					select tgt.external_code_sk  into :tgt_external_code_sk
						from &m_apdm_lib..external_code_master tgt
						where tgt.external_code_id = "src_&entity_sk.";  /*i18NOK:LINE*/
				quit;

				%let tgt_external_code_sk = &tgt_external_code_sk.;

				proc sql noprint;
					update &m_apdm_lib..external_code_master
						set external_code_id = "&tgt_external_code_sk." 	/* i18nok:line */
					where external_code_sk = &tgt_external_code_sk;
				quit;
				
				/*Update current date as created_dttm and last_processed_dttm as part of defect*/
				proc sql noprint ; 
					update &m_apdm_lib..external_code_master tgt	
					set last_processed_dttm="%sysfunc(datetime(),DATETIME.)"dt ,created_dttm="%sysfunc(datetime(),DATETIME.)"dt /* i18nok:line */
					where tgt.external_code_sk = &tgt_external_code_sk  ; 
				quit;

				/* Inserting data to External_code_assoc */			
				proc sql noprint;
					insert into &m_apdm_lib..external_code_assoc(entity_sk,ext_code_entity_type_param_sk,ext_code_sk)
						values(&m_tgt_project_sk.,&_ref_param_Sk,&tgt_external_code_sk.);
				quit;

				filename source filesrvc folderpath="&IMPORT_PACKAGE_PATH." filename="&_ext_script_nm_..sas" debug= http;	/* i18nok:line */
				%put &_FILESRVC_source_URI.;
					
				%let _out_id=;
				%dabt_cprm_proc_http(_fileid=&_FILESRVC_source_URI.,_fileref=source,_method=POST,_out=_out_id);

				%let _next_ext_ver_sk = .;
				proc sql;
					&apdm_connect_string.; 
						select temp into :_next_ext_ver_sk from 
							connection to postgres 
							( 
								select nextval( %nrbquote('&apdm_schema..external_code_versions_version_sk_seq') ) as temp
							);
					&apdm_disconnect_string.; 
				quit;

				proc sql noprint;
					insert into &m_apdm_lib..external_code_versions(external_code_sk,version_sk,version_number,file_id,active_flg,created_dttm,created_by,modified_dttm,modified_by)
						values(&tgt_external_code_sk.,&_next_ext_ver_sk.,1,"&_out_id","Y","%sysfunc(datetime(),DATETIME.)"dt,"&sysuserid","%sysfunc(datetime(),DATETIME.)"dt,"&sysuserid");		/* i18nok:line */
				quit;
				%dabt_err_chk(type=SQL);

				/*Processing for the list of external code variables present only in source.*/
				%let _ext_var_nm_only_in_src = ;
				%let _ext_var_sk_only_in_src = ;
				
				proc sql noprint;
					select src.external_variable_column_nm, src.external_variable_sk 
							into :_ext_var_nm_only_in_src separated by ',', :_ext_var_sk_only_in_src separated by ','			/*i18NOK:LINE*/
						from &m_cprm_src_apdm..external_variable_master src
						where src.external_code_sk = &_ext_sk_.;
				quit;
	
				/*Execution Starts  for variables _ext_var_sk_only_in_src */
				%if &_ext_var_sk_only_in_src. ne %then %do;
					%let _src_count=;
					%let _src_count = %eval(%sysfunc(countc(%quote(&_ext_var_sk_only_in_src.), ','))+1);		/*i18NOK:LINE*/

					%do count = 1 %to &_src_count;
						%let _src_ext_var_sk_tkn = %scan(%quote(&_ext_var_sk_only_in_src.),&count,%str(,)); /* i18nOK:Line */

						/*Get the list of external code variables to be updated, from external_variable_master*/
						%let ins_cols_lst = ;
						%dabt_cprm_get_col_lst(	m_ds_nm=external_variable_master, 
												m_src_lib_nm=&m_cprm_src_apdm, 
												m_tgt_lib_nm=&m_apdm_lib, 
												m_exclued_col= external_variable_sk external_code_sk, 
												m_col_lst=, 
												m_prim_col_nm=external_variable_sk, 
												m_prim_col_val=&_src_ext_var_sk_tkn, 
												m_ins_cols_lst= ins_cols_lst
											  );
											  
						%let m_next_ext_var_sk = .;
						proc sql;
							&apdm_connect_string.; 
								select 
									temp into :m_next_ext_var_sk
								from 
									connection to postgres 
									( 
										select nextval( %nrbquote('&apdm_schema..external_variable_master_external_variable_sk_seq') ) as temp
									);
							&apdm_disconnect_string.; 
						quit;

						%let m_next_ext_var_sk = &m_next_ext_var_sk.;
						
						proc sql noprint ;
							insert into &m_apdm_lib..external_variable_master 
									(external_variable_sk,&ins_cols_lst , external_code_sk)
								select &m_next_ext_var_sk.,&ins_cols_lst, &tgt_external_code_sk as external_code_sk
										from  &m_cprm_src_apdm..external_variable_master src
									where src.external_variable_sk eq &_src_ext_var_sk_tkn.;
						quit;
					%end;/*Loop end for processing of variables m_ext_var_sk_only_in_src */	
				%end; /*End:Conditional processing of  variables present on both source and target */

			%end;/*Ending block for Insertion in &m_apdm_lib..external_code_master, External_code_assoc */
		%end;	/* Loop end for script */
	%end;
	%if &m_valid_flg. = &CHECK_FLAG_FALSE. and &syscc. le 4 %then %do;
		%let syscc = 999 ;
	%end;


	/****************************************END OF EXECUTE MODE*****************************************/
%mend dabt_cprm_import_project_master;
