/*******************************************************************
	NAME:	load_SANDKASSE_into_sandbox.sas
	DESC:	Load all AL Azure DB tables into CAS lib KKM.
******************************************************************/


cas mySession sessopts=(timeout=3500000);

caslib _all_ assign;

/*
proc fedsql sessref=mySession;
	create table casuser.PRGD_KUNDE_NOGLE_HIST as 
    select * 
	from sandkasse.PRGD_KUNDE_NOGLE_HIST
;
quit;
data casuser.PRGD_KUNDE_NOGLE_HIST;
	set casuser.PRGD_KUNDE_NOGLE_HIST;
	start_dttm=dhms(start_dato,0,0,0) ;
	slut_dttm=dhms(slut_dato,23,59,99);
	format slut_dttm start_dttm datetime20. ;
run;
proc casutil  incaslib="casuser" outcaslib="sandbox" ;    
	save casdata="PRGD_KUNDE_NOGLE_HIST" replace; 
	DROPTABLE CASDATA="PRGD_KUNDE_NOGLE_HIST" INCASLIB="sandbox" QUIET;
	load casdata="PRGD_KUNDE_NOGLE_HIST" 
	casout="PRGD_KUNDE_NOGLE_HIST" 	
	incaslib="sandbox"  promote;
run;  
proc fedsql  sessref=mySession;
	drop table casuser.PRGD_KUNDE_NOGLE_HIST ;
quit;
*/

%macro hop(dsname);
	proc fedsql sessref=mySession;
		create table casuser.&dsname. as 
	    select *
		from sandkasse.&dsname.
	;
	quit;
	data casuser.&dsname.;
		set casuser.&dsname.;
		start_dttm=dhms(start_dato,0,0,0) ;
		slut_dttm=dhms(slut_dato,23,59,59);
		format slut_dttm start_dttm datetime20. ;
	run;
	proc casutil  incaslib="casuser" outcaslib="sandbox" ;    
		save casdata="&dsname." replace; 
		DROPTABLE CASDATA="&dsname." INCASLIB="sandbox" QUIET;
		load casdata="&dsname..sashdat" 
		casout="&dsname." 	
		incaslib="sandbox"  promote;
	run;  
	proc fedsql  sessref=mySession;
		drop table casuser.&dsname. ;
	quit;
%mend hop;

%hop(PRGD_KKM_DATA_RAA_HIST);
%hop(PRGD_KKM_DATA_RAA);
%hop(INITIAL_RATING_HIST);

proc fedsql sessref=mySession;
	create table casuser.PRGD_KUNDE_NOGLE as 
    select *
	from sandkasse.PRGD_KUNDE_NOGLE
;
quit;
data casuser.PRGD_KUNDE_NOGLE;
	set casuser.PRGD_KUNDE_NOGLE;
	start_dttm=dhms(start_dato,0,0,0) ;
	slut_dttm=dhms(slut_dato,23,59,59);
	opr_dttm=dhms(oprdato,0,0,0);
	format slut_dttm start_dttm datetime20. ;
run;
proc casutil  incaslib="casuser" outcaslib="sandbox" ;    
	save casdata="PRGD_KUNDE_NOGLE" replace; 
	DROPTABLE CASDATA="PRGD_KUNDE_NOGLE" INCASLIB="sandbox" QUIET;
	load casdata="PRGD_KUNDE_NOGLE.sashdat" 
		casout="PRGD_KUNDE_NOGLE" 	
		incaslib="sandbox"  promote;
run;  
proc fedsql  sessref=mySession;
	drop table casuser.PRGD_KUNDE_NOGLE;
quit;


proc fedsql sessref=mySession;
	create table casuser.PRGD_KUNDE_NOGLE_HIST as 
    select *
	from sandkasse.PRGD_KUNDE_NOGLE_HIST
;
quit;
data casuser.PRGD_KUNDE_NOGLE_HIST;
	set casuser.PRGD_KUNDE_NOGLE_HIST;
	start_dttm=dhms(start_dato,0,0,0) ;
	slut_dttm=dhms(slut_dato,23,59,59);
	opr_dttm=dhms(oprdato,0,0,0);
	format slut_dttm start_dttm datetime20. ;
run;
proc casutil  incaslib="casuser" outcaslib="sandbox" ;    
	save casdata="PRGD_KUNDE_NOGLE_HIST" replace; 
	DROPTABLE CASDATA="PRGD_KUNDE_NOGLE_HIST" INCASLIB="sandbox" QUIET;
	load casdata="PRGD_KUNDE_NOGLE_HIST.sashdat" 
		casout="PRGD_KUNDE_NOGLE_HIST" 	
		incaslib="sandbox"  promote;
run;  
proc fedsql  sessref=mySession;
	drop table casuser.PRGD_KUNDE_NOGLE_HIST;
quit;


