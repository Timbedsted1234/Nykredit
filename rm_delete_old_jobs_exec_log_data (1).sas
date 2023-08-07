%macro rm_delete_old_jobs_exec_log_data(m_delete_data_older_than_days=,m_export_existing_apdm_as_xpt=Y, m_location_of_apdm_export=);

%let m_delete_data_older_than_days = &m_delete_data_older_than_days.;
%let m_export_existing_apdm_as_xpt = &m_export_existing_apdm_as_xpt.;

%if &m_delete_data_older_than_days. <= 5 %then %do;
	/* %put WARNING: Skipping deletion of jobs. Jobs to be deleted should be older than 5 days*/
	%put %sysfunc(sasmsg(SASHELP.dabt_error_messages, DELETE_OLD_JOBS_DATA_Warning1.1, noquote) );
	%return ;
%end;
	
%if &m_export_existing_apdm_as_xpt. eq Y %then %do;
	
	%if "&m_location_of_apdm_export." ne "" %then %do;

		/**** check existence of user specified SAS content folder loaction ***/
		filename resp temp;
		filename resp_hdr temp;
		/* %let BASE_URI=%sysfunc(getoption(servicesbaseurl)); */
	
		proc http url="&BASE_URI_FOLDERS/folders/folders/@item?path=&m_location_of_apdm_export." /* i18nOK:Line */
			method='get'/* i18nOK:Line */
			oauth_bearer=sas_services out=resp headerout=resp_hdr headerout_overwrite 
				ct="application/json";		/* i18nOK:Line */
			DEBUG LEVEL=3;
		run;
		quit;
		
		%put &SYS_PROCHTTP_STATUS_CODE.;
		%if &SYS_PROCHTTP_STATUS_CODE. ne 200 %then %do;
			/* %let syscc=99; */
			/* %put ERROR: &m_location_of_apdm_export. path does not exist in SAS content Folder;*/
 			%put %sysfunc(sasmsg(SASHELP.dabt_error_messages, DELETE_OLD_JOBS_DATA_ERROR1.1, noquote, &m_location_of_apdm_export.) );
			%return ;
		%end;
		%else %do;
			filename jobxpt filesrvc folderpath="&m_location_of_apdm_export." filename= %sysfunc(kstrip("apdm_deleted_jobs_backup %sysfunc(datetime(), E8601DT.).xpt")) debug=http recfm=n;	/* i18nOK:Line */
			proc cport library=apdm file=jobxpt  memtype=data;
			select JOB_EXECUTION_LOG JOB_BUILD_DATE_PARAMETER JOB_MASTER;
			run;
		%end;
	%end;

    %else %do;
		/* %put ERROR: The parameter containing apdm export location is missing. Assign value to the parameter M_LOCATION_OF_APDM_EXPORT; */
		%put %sysfunc(sasmsg(SASHELP.dabt_error_messages, DELETE_OLD_JOBS_DATA_ERROR1.2, noquote) );
        %return;
	%end;
	
%end;

/* Creating table of job ids that is to be deleted*/
proc sql noprint;
	create table work.jobs_to_be_deleted 
	as select job_sk from  &lib_apdm..job_master
	where  datepart(execution_start_dttm) < intnx('DAY', today(), - &m_delete_data_older_than_days.);	/* i18nOK:Line */
run;
%dabt_err_chk(type=SQL);

%let job_cnt=;
proc sql noprint;
	select count(*) into: job_cnt from work.jobs_to_be_deleted;	/* i18nOK:Line */
run;

%let job_cnt= &job_cnt.;

%if &job_cnt. ne 0 %then %do; /*Delete records from apdm table if Job Count is not 0*/

    proc sql;
		update &lib_apdm..EXTERNAL_CODE_MASTER
		set vldn_job_sk = .
		where vldn_job_sk in(select job_sk from jobs_to_be_deleted);
	run;
	
	proc sql noprint;
	   delete from &lib_apdm..JOB_EXECUTION_LOG 
	      where job_sk in(select job_sk from jobs_to_be_deleted);
	run;


	proc sql noprint;
	   delete from  &lib_apdm..JOB_BUILD_DATE_PARAMETER 
	      where job_sk in(select job_sk from jobs_to_be_deleted);
	run;

	
	proc sql noprint;
	   delete from  &lib_apdm..JOB_MASTER 
	      where job_sk in(select job_sk from jobs_to_be_deleted);
	run;

%end;
%else %do;
	/* %put NOTE: No jobs are present older than &m_delete_data_older_than_days. days; */
	%put %sysfunc(sasmsg(SASHELP.dabt_error_messages, DELETE_OLD_JOBS_DATA_NOTE1.1, noquote, &m_delete_data_older_than_days.) );
%end;

%mend rm_delete_old_jobs_exec_log_data;