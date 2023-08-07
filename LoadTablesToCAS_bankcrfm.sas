/*Run this program from SAS studio.  The sashdat files in the bankcrm, 
rm_mdl, and rm_pbdst caslibs need to be loaded into memory.*/

%macro load_lib_to_cas(input_caslib=, action=load);
	/* INITIATE SESSION and ENSURE CASLIB is assigned */
	cas load_unload_library;
	caslib _all_ assign;

	proc cas;
		%if &action=load %then
			%do;
				table.fileInfo %end;
		%else
			%do;
				table.tableInfo %end;
		result=Files / caslib="&input_caslib.";
		exist_Files=findtable(Files);

		if exist_Files then
			saveresult Files dataout=work.Files;
		else
			put 
			%if &action=load %then
				%do;
					'ERROR: No files to load.     ' %end;
		%else
			%do;
				'ERROR: No tables to unload.   ' %end;
		;
	quit;
	%local m_hdatfile_exists_check;
	proc sql noprint;
		select count(*) into: m_hdat_file_cnt from work.Files;
	quit;
	%let m_hdatfile_exists_check = &m_hdat_file_cnt.;
	
	%if %sysfunc(exist(work.Files)) and &m_hdatfile_exists_check. gt 0 %then
		%do;

			proc sql noprint;
				select count(*) , name into :cnt, :name separated by '~' from files;
			quit;

			proc cas;
				%do i=1 %to &cnt;
					%let current_nm = %scan(&name, &i., ~);
					%let op_nm = %scan(&current_nm, 1);

					%if &action=load %then
						%do;
							table.loadTable / casout={caslib="&input_caslib.", name="&op_nm.", 
								promote="TRUE" replace="FALSE"} caslib="&input_caslib.", 
								path="&current_nm.";
						%end;
					%else
						%do;
							table.dropTable / caslib="&input_caslib." name="&current_nm." quiet=TRUE;
						%end;
				%end;
			quit;

		%end;
	cas load_unload_library terminate;
%mend;


%load_lib_to_cas(input_caslib=bankcrfm, action=load);



