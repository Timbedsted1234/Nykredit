
%macro create_project_export_package();
	%let root_job_folder_uri =;
	%get_job_folder_uri(return_job_folder_uri=root_job_folder_uri);
	%let root_job_folder_uri = &root_job_folder_uri.;
	%put &=root_job_folder_uri.;

	proc sql;
		create table project_master as select project_sk from apdm.project_master;
		select count(*) into :Project_count from work.project_master;
	quit;

	%let Project_count = &Project_count;

	%do prj_counter =1 %to &Project_count.;
		%local exp_project_sk ;
		data _null_;
			pointer=&prj_counter;
			set work.project_master point=pointer;
			call symput('exp_project_sk', project_sk);
			stop;
		run;

		%let exp_project_sk = &exp_project_sk;
		filename prep_jid temp LRECL=1000000 encoding='utf-8';

		data _null_;
			format text $3000.;
			file prep_jid;
			text='{"name":"'||"&exp_project_sk."||'"}';
			put text;
		run;

		filename resp temp LRECL=1000000 encoding='utf-8';

		proc http method="POST" url="&environment_url./folders/folders?parentFolderUri=&root_job_folder_uri." 
				ct="application/json" in=prep_jid out=resp OAUTH_BEARER=SAS_SERVICES;
		run;

		filename prep_jid clear;
		filename resp clear;

		%dabt_cprm_prj_export_wrapper (project_id_lst = &exp_project_sk.,
										export_ouput_folder_path=%str(/SAS Risk Modeling/Application Data/Jobs/&m_job_sk./&exp_project_sk.));
	%end;
%mend create_project_export_package;

%macro get_job_folder_uri(return_job_folder_uri=);
	%macro get_folder_id_x_uri(rest_api_url=, result_tbl_nm=);
		%let result_tbl_nm = &result_tbl_nm;
		%let rest_api_url = &rest_api_url;
		filename resp_hdr temp;
		filename outfile temp;

		proc http url="&rest_api_url." method="GET" out=outfile headerout=resp_hdr 
				headerout_overwrite OAUTH_BEARER=SAS_SERVICES;
			;
		run;

		libname posts JSON fileref=outfile;

		/* 	libname stage "&codepath/stage"; */
		data work.&result_tbl_nm;
			set posts.items;
		run;

		libname posts clear;
		filename outfile clear;
		filename resp_hdr clear;
	%mend get_folder_id_x_uri;

	%get_folder_id_x_uri(rest_api_url=%str(&environment_url./folders/rootFolders?filter=eq(name, 'SAS Risk Modeling')), 
		result_tbl_nm=root_folder_list);

	proc sql;
		select id into :root_folder_id from root_folder_list;
	quit;

	%let  root_folder_id = &root_folder_id.;
	%get_folder_id_x_uri(rest_api_url=%str(&environment_url./folders/folders/&root_folder_id./members?filter=eq(name, 'Application Data')), 
		result_tbl_nm=rm_folder_list);

	proc sql;
		select uri into :applctn_folder_uri from rm_folder_list;
	quit;

	%let  applctn_folder_uri = &applctn_folder_uri.;
	%get_folder_id_x_uri(rest_api_url=%str(&environment_url./&applctn_folder_uri./members?filter=eq(name, 'Jobs')), 
		result_tbl_nm=applctn_folder_list);

	proc sql;
		select uri into :job_folder_uri from applctn_folder_list;
	quit;

	%let  job_folder_uri = &job_folder_uri.;
	%get_folder_id_x_uri(rest_api_url=%str(&environment_url./&job_folder_uri./members?limit=20000), 
		result_tbl_nm=job_folder_list);

	proc sql;
		select uri into :parentFolderUri from job_folder_list where 
			name="&m_job_sk.";
	quit;

	%let &return_job_folder_uri = &parentFolderUri;
%mend get_job_folder_uri;

