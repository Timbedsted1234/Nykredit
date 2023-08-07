%macro get_folder_uri(return_job_folder_uri=,entity_type= );
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

	%let entity_type = &entity_type.;

	%get_folder_id_x_uri(rest_api_url=%str(&environment_url./folders/rootFolders?filter=eq(name, 'DevOps')), 
		result_tbl_nm=root_folder_list);

	proc sql;
		select id into :root_folder_id from root_folder_list;
	quit;

	%let  root_folder_id = &root_folder_id.;
	%get_folder_id_x_uri(rest_api_url=%str(&environment_url./folders/folders/&root_folder_id./members?filter=eq(name, 'Export')), 
		result_tbl_nm=exprt_folder_list);

	proc sql;
		select uri into :export_folder_uri from exprt_folder_list;
	quit;

	%let  export_folder_uri = &export_folder_uri.;
	%if "&entity_type." eq "PROJECT" %then %do;
		%get_folder_id_x_uri(rest_api_url=%str(&environment_url./&export_folder_uri./members?filter=eq(name, 'Projects')), 
		result_tbl_nm=prj_folder_list);
	%end;
	%else %if "&entity_type." eq "MODEL" %then %do;
		%get_folder_id_x_uri(rest_api_url=%str(&environment_url./&export_folder_uri./members?filter=eq(name, 'Models')), 
		result_tbl_nm=prj_folder_list);
	%end;
	proc sql;
		select uri into :ent_type_folder_uri from prj_folder_list;
	quit;

	%let  ent_type_folder_uri = &ent_type_folder_uri.;
	%let &return_job_folder_uri = &ent_type_folder_uri;
%mend get_folder_uri;