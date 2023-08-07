%macro create_model_export_package(model_id_list=);
	filename cr_cd filesrvc folderpath="/DevOps/ucmacros" 
		filename="get_folder_uri.sas";
	%include cr_cd / lrecl=64000;
	filename cr_cd clear;
	%let model_id_list = &model_id_list.;
	%let root_job_folder_uri =;
	%get_folder_uri(return_job_folder_uri=root_job_folder_uri, entity_type=MODEL);
	%let root_job_folder_uri = &root_job_folder_uri.;
	%put &=root_job_folder_uri.;
	filename prep_jid temp LRECL=1000000 encoding='utf-8';

	data _null_;
		format text $3000.;
		file prep_jid;
		text='{"name":"'||"&m_job_sk."||'"}';
		put text;
	run;

	filename resp temp LRECL=1000000 encoding='utf-8';

	proc http method="POST" 
			url="&environment_url./folders/folders?parentFolderUri=&root_job_folder_uri." 
			ct="application/json" in=prep_jid out=resp OAUTH_BEARER=SAS_SERVICES;
	run;

	filename prep_jid clear;
	filename resp clear;
	%dabt_cprm_mdl_export_wrapper (model_id_lst=&model_id_list., 
		export_ouput_folder_path=%str(/DevOps/Export/Models/&m_job_sk./));
	filename imp_file filesrvc folderpath="/DevOps/Export/Models/&m_job_sk./" 
		filename="cprm_import_specification_file.csv" debug=http 
		CD="attachment; filename=cprm_import_specification_file.csv";

	PROC IMPORT OUT=work.mdl_imprt_specification_tmp DATAFILE=imp_file DBMS=csv 
			REPLACE;
		GETNAMES=NO;
		guessingrows=32767;
		DATAROW=2;
	RUN;

	filename imp_file clear;

	data work.mdl_imprt_specification_tmp;
		set work.mdl_imprt_specification_tmp;

		IF upcase(var1)='MODEL';
	run;

	proc sql noprint;
		create table work.mdl_imprt_specification (entity_type_cd character(40) not 
			null label="Entity Type Code", entity_type_nm character(360) not null 
			label="Entity Type Name", entity_key numeric(10) not null 
			label="Entity Key", entity_nm character(360) not null label="Entity Name", 
			entity_desc character(1800) label="Entity Description", promote_flg 
			character(1) not null label="Promote This Entity Flag", owner character(32) 
			not null label="Owner", constraint entity_type_cd_key primary 
			key (entity_type_cd, entity_key));
	quit;

	proc sql noprint;
		insert into work.mdl_imprt_specification
			(entity_type_cd, entity_type_nm, entity_key, entity_nm, entity_desc, 
			promote_flg, owner) select var1 as entity_type_cd, var2 as entity_type_nm, 
			var3 as entity_key, var4 as entity_nm, var5 as entity_desc, var6 as 
			promote_flg, var7 as owner from work.mdl_imprt_specification_tmp;
	quit;

	filename exp_file filesrvc folderpath="/DevOps/Export/Models/&m_job_sk./" 
		filename="cprm_import_specification_file.csv" encoding='utf-8' debug=http;

	proc export data=work.mdl_imprt_specification outfile=exp_file DBMS=csv 
			replace label;
	run;

	filename exp_file clear;
%mend create_model_export_package;