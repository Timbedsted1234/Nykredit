cas mySession sessopts=(timeout=3500000);
caslib _all_ assign;
options casdatalimit=500M;


/*Load udviklingsdata indtil RAT_DATA for udvikling af model.  */
%LET SQL_SERVER=SANDKASSE; 
%LET VIYA_LIBRARY=RAT_DATA; 

%macro hop(TABEL_NAVN);
	proc fedsql sessref=mySession;
		create table casuser.&TABEL_NAVN. as 
	    select *
		from &SQL_SERVER..&TABEL_NAVN.
	;
	quit;
	data casuser.&TABEL_NAVN.;
		set casuser.&TABEL_NAVN.;
		start_dttm=dhms(start_dato,0,0,0) ;
		slut_dttm=dhms(slut_dato,23,59,59) -86400;
		format slut_dttm start_dttm datetime20. ;
	run;
	proc casutil  incaslib="casuser" outcaslib="&VIYA_LIBRARY." ;    
		save casdata="&TABEL_NAVN." replace; 
		DROPTABLE CASDATA="&TABEL_NAVN." INCASLIB="&VIYA_LIBRARY." QUIET;
		load casdata="&TABEL_NAVN..sashdat" 
		casout="&TABEL_NAVN." 	
		incaslib="&VIYA_LIBRARY."  promote;
	run;  
	proc fedsql  sessref=mySession;
		drop table casuser.&TABEL_NAVN. ;
	quit;
%mend hop;


%hop(RYKKER);
%hop(REGNSKABER);
%hop(DEFAULT_DATA);
%hop(DAGE);
%hop(SVAG_KUNDE);
%hop(RELATIONER);

/*Store tabeller  */
%hop(STAMOPLYSNINGER);



/*Tabeller der skal have fjernet HIST  */
%macro hop_HIST(TABEL_NAVN);
	proc fedsql sessref=mySession;
		create table casuser.&TABEL_NAVN. as 
	    select *
		from &SQL_SERVER..&TABEL_NAVN._HIST
	;
	quit;
	data casuser.&TABEL_NAVN.;
		set casuser.&TABEL_NAVN.;
		start_dttm=dhms(start_dato,0,0,0) ;
		slut_dttm=dhms(slut_dato,23,59,59)-86400;
		format slut_dttm start_dttm datetime20. ;
	run;
	proc casutil  incaslib="casuser" outcaslib="&VIYA_LIBRARY." ;    
		save casdata="&TABEL_NAVN." replace; 
		DROPTABLE CASDATA="&TABEL_NAVN." INCASLIB="&VIYA_LIBRARY." QUIET;
		load casdata="&TABEL_NAVN..sashdat" 
		casout="&TABEL_NAVN." 	
		incaslib="&VIYA_LIBRARY."  promote;
	run;  
	proc fedsql  sessref=mySession;
		drop table casuser.&TABEL_NAVN. ;
	quit;
%mend hop_HIST;
%hop_HIST(OKONOMI);
%hop_HIST(OVERTRAEK);

/*Tabeller der skal have fjernet DATA*/
%macro hop_DATA(TABEL_NAVN);
	proc fedsql sessref=mySession;
		create table casuser.&TABEL_NAVN. as 
	    select *
		from &SQL_SERVER..&TABEL_NAVN._DATA
	;
	quit;
	data casuser.&TABEL_NAVN.;
		set casuser.&TABEL_NAVN.;
		start_dttm=dhms(start_dato,0,0,0) ;
		slut_dttm=dhms(slut_dato,23,59,59)-86400;
		format slut_dttm start_dttm datetime20. ;
	run;
	proc casutil  incaslib="casuser" outcaslib="&VIYA_LIBRARY." ;    
		save casdata="&TABEL_NAVN." replace; 
		DROPTABLE CASDATA="&TABEL_NAVN." INCASLIB="&VIYA_LIBRARY." QUIET;
		load casdata="&TABEL_NAVN..sashdat" 
		casout="&TABEL_NAVN." 	
		incaslib="&VIYA_LIBRARY."  promote;
	run;  
	proc fedsql  sessref=mySession;
		drop table casuser.&TABEL_NAVN. ;
	quit;
%mend hop_DATA;
%hop_DATA(DEFAULT);




/*Tabeller som hedder noget helt forkert  */
	proc fedsql sessref=mySession;
		create table casuser.ADFAERD as 
	    select *
		from &SQL_SERVER..KKM_DATA_RAA_HIST
	;
	quit;
	data casuser.ADFAERD;
		set casuser.ADFAERD;
		start_dttm=dhms(start_dato,0,0,0) ;
		slut_dttm=dhms(slut_dato,23,59,59)-86400;
		format slut_dttm start_dttm datetime20. ;
	run;
	proc casutil  incaslib="casuser" outcaslib="&VIYA_LIBRARY." ;    
		save casdata="ADFAERD" replace; 
		DROPTABLE CASDATA="ADFAERD" INCASLIB="&VIYA_LIBRARY." QUIET;
		load casdata="ADFAERD.sashdat" 
		casout="ADFAERD" 	
		incaslib="&VIYA_LIBRARY."  promote;
	run;  
	proc fedsql  sessref=mySession;
		drop table casuser.ADFAERD;
	quit;