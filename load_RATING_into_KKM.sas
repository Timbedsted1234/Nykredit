/*******************************************************************
	NAME:	load_RATING_into_KKM.sas
	DESC:	Load all AL Azure DB tables into CAS lib KKM.
******************************************************************/
cas mySession sessopts=(timeout=3500000);
caslib _all_ assign;

/*******************************************************
Tilpas manglende kundenr i KKM tabeller
	PRGD_KKM_OVERTRK_HIST  	– DEL_MODPARTS_ID
	PRGD_OVERTRK_STAT_HIST	– DEL_MODPARTS_ID
	PRGD_OKONOMI_HIST 		- INTERESSENTNR

Kode eksempel fra Rasmus 
De tabeller som kun har DEL_MODPARTS_ID, som nøgle, 
kan man anvende følgende kode til at oversætte til de 
kundenumre, som er en del af DEL_MODPARTS_ID: 

PROC SQL;
CREATE TABLE KUNDENR_DELM_ID AS SELECT
DISTINCT
KUNDENR
DEL_MODPARTS_ID
FROM PRGD_STAMOPL_HIST
;
QUIT;

Bemærk at der kan være 2 kundenumre tilknyttet et 
DEL_MODPARTS_ID
*******************************************************/

* Kundenr <-> del_modparts_id *;
PROC FEDSQL sessref=mysession;
CREATE TABLE casuser.KUNDENR_DELM_ID AS 
	SELECT DISTINCT KUNDENR, DEL_MODPARTS_ID
	FROM KKM.PRGD_STAMOPL_HIST
;
QUIT;

%macro hop(dsname);
	proc fedsql sessref=mySession;
		create table casuser.&dsname. as 
	    select *
		from RATING.&dsname.
	;
	quit;
	data casuser.&dsname.;
		set casuser.&dsname.;
		start_dttm=dhms(start_dato,0,0,0) ;
		slut_dttm=dhms(slut_dato,23,59,59);
		format slut_dttm start_dttm datetime20. ;
	run;
	proc casutil  incaslib="casuser" outcaslib="KKM" ;    
		save casdata="&dsname." replace; 
		DROPTABLE CASDATA="&dsname." INCASLIB="KKM" QUIET;
		load casdata="&dsname..sashdat" 
		casout="&dsname." 	
		incaslib="sandbox"  promote;
	run;  
	proc fedsql  sessref=mySession;
		drop table casuser.&dsname. ;
	quit;
%mend hop;

* PRGD_KKM_OVERTRK *; 
proc fedsql sessref=mysession;
	drop table kkm.PRGD_KKM_OVERTRK_HIST
	;
quit;
proc fedsql sessref=mysession;
	create table casuser.PRGD_KKM_OVERTRK_HIST  AS 
	select RAT.* , STAM.KUNDENR
	FROM  rating.PRGD_KKM_OVERTRK_HIST  RAT, casuser.KUNDENR_DELM_ID STAM
	where  RAT.DEL_MODPARTS_ID=STAM.DEL_MODPARTS_ID
	;
quit;
data casuser.PRGD_KKM_OVERTRK_HIST;
	set casuser.PRGD_KKM_OVERTRK_HIST;
	start_dttm=dhms(start_dato,0,0,0) ;
	slut_dttm=dhms(slut_dato,23,59,59);
	format slut_dttm start_dttm datetime20. ;
run;

proc casutil  incaslib="casuser" outcaslib="KKM" ;    
	save casdata="PRGD_KKM_OVERTRK_HIST" replace; 
	DROPTABLE CASDATA="PRGD_KKM_OVERTRK_HIST" INCASLIB="KKM" QUIET;
	load casdata="PRGD_KKM_OVERTRK_HIST.sashdat" 
	casout="PRGD_KKM_OVERTRK_HIST" 	
	incaslib="sandbox"  promote;
run;  
proc fedsql  sessref=mySession;
	drop table casuser.PRGD_KKM_OVERTRK_HIST ;
quit;

proc fedsql sessref=mysession;
	drop table kkm.PRGD_KKM_OVERTRK
	;
quit;
proc fedsql sessref=mysession;
	create table casuser.PRGD_KKM_OVERTRK  AS 
	select RAT.* , STAM.KUNDENR
	FROM  rating.PRGD_KKM_OVERTRK  RAT, casuser.KUNDENR_DELM_ID STAM
	where  RAT.DEL_MODPARTS_ID=STAM.DEL_MODPARTS_ID
	;
quit;
data casuser.PRGD_KKM_OVERTRK;
	set casuser.PRGD_KKM_OVERTRK;
	start_dttm=dhms(start_dato,0,0,0) ;
	slut_dttm=dhms(slut_dato,23,59,59);
	format slut_dttm start_dttm datetime20. ;
run;

proc casutil  incaslib="casuser" outcaslib="KKM" ;    
	save casdata="PRGD_KKM_OVERTRK" replace; 
	DROPTABLE CASDATA="PRGD_KKM_OVERTRK" INCASLIB="KKM" QUIET;

*	load casdata="PRGD_KKM_OVERTRK.sashdat" 
	casout="PRGD_KKM_OVERTRK" 	
	incaslib="sandbox"  promote;
run;  
proc fedsql  sessref=mySession;
	drop table casuser.PRGD_KKM_OVERTRK ;
quit;


* PRGD_OVERTRK_STAT *; 
proc fedsql sessref=mysession;
	drop table kkm.PRGD_OVERTRK_STAT_HIST
	;
quit;

proc fedsql sessref=mysession;
	create table casuser.PRGD_OVERTRK_STAT_HIST  AS 
	select RAT.* , STAM.KUNDENR
	FROM  rating.PRGD_OVERTRK_STAT_HIST  RAT, casuser.KUNDENR_DELM_ID STAM
	where  RAT.DEL_MODPARTS_ID=STAM.DEL_MODPARTS_ID
	;
quit;
data casuser.PRGD_OVERTRK_STAT_HIST;
	set casuser.PRGD_OVERTRK_STAT_HIST;
	start_dttm=dhms(start_dato,0,0,0) ;
	slut_dttm=dhms(slut_dato,23,59,59);
	format slut_dttm start_dttm datetime20. ;
run;

proc casutil  incaslib="casuser" outcaslib="KKM" ;    
	save casdata="PRGD_OVERTRK_STAT_HIST" replace; 
	DROPTABLE CASDATA="PRGD_OVERTRK_STAT_HIST" INCASLIB="KKM" QUIET;
	load casdata="PRGD_OVERTRK_STAT_HIST.sashdat" 
	casout="PRGD_OVERTRK_STAT_HIST" 	
	incaslib="sandbox"  promote;
run;  
proc fedsql  sessref=mySession;
	drop table casuser.PRGD_OVERTRK_STAT_HIST ;
quit;


proc fedsql sessref=mysession;
	drop table kkm.PRGD_OVERTRK_STAT
	;
quit;

proc fedsql sessref=mysession;
	create table casuser.PRGD_OVERTRK_STAT  AS 
	select RAT.* , STAM.KUNDENR
	FROM  rating.PRGD_OVERTRK_STAT  RAT, casuser.KUNDENR_DELM_ID STAM
	where  RAT.DEL_MODPARTS_ID=STAM.DEL_MODPARTS_ID
	;
quit;
data casuser.PRGD_OVERTRK_STAT;
	set casuser.PRGD_OVERTRK_STAT;
	start_dttm=dhms(start_dato,0,0,0) ;
	slut_dttm=dhms(slut_dato,23,59,59);
	format slut_dttm start_dttm datetime20. ;
run;

proc casutil  incaslib="casuser" outcaslib="KKM" ;    
	save casdata="PRGD_OVERTRK_STAT" replace; 
	DROPTABLE CASDATA="PRGD_OVERTRK_STAT" INCASLIB="KKM" QUIET;
	load casdata="PRGD_OVERTRK_STAT.sashdat" 
	casout="PRGD_OVERTRK_STAT" 	
	incaslib="sandbox"  promote;
run;  
proc fedsql  sessref=mySession;
	drop table casuser.PRGD_OVERTRK_STAT ;
quit;

* PRGD_OKONOMI *;
proc fedsql sessref=mysession;
	drop table kkm.PRGD_OKONOMI_HIST
	;
quit;
proc fedsql sessref=mysession;
	create table casuser.PRGD_OKONOMI_HIST  AS 
	select RAT.* , RAT.INTERESSENTNR  as KUNDENR
	FROM  rating.PRGD_OKONOMI_HIST  RAT
	;
quit;
data casuser.PRGD_OKONOMI_HIST;
	set casuser.PRGD_OKONOMI_HIST;
	start_dttm=dhms(start_dato,0,0,0) ;
	slut_dttm=dhms(slut_dato,23,59,59);
	format slut_dttm start_dttm datetime20. ;
run;

proc casutil  incaslib="casuser" outcaslib="KKM" ;    
	save casdata="PRGD_OKONOMI_HIST" replace; 
	DROPTABLE CASDATA="PRGD_OKONOMI_HIST" INCASLIB="KKM" QUIET;
	load casdata="PRGD_OKONOMI_HIST.sashdat" 
	casout="PRGD_OKONOMI_HIST" 	
	incaslib="sandbox"  promote;
run;  
proc fedsql  sessref=mySession;
	drop table casuser.PRGD_OKONOMI_HIST ;
quit;

proc fedsql sessref=mysession;
	drop table kkm.PRGD_OKONOMI
	;
quit;
proc fedsql sessref=mysession;
	create table casuser.PRGD_OKONOMI  AS 
	select RAT.* , RAT.INTERESSENTNR  as KUNDENR
	FROM  rating.PRGD_OKONOMI  RAT
	;
quit;
data casuser.PRGD_OKONOMI;
	set casuser.PRGD_OKONOMI;
	start_dttm=dhms(start_dato,0,0,0) ;
	slut_dttm=dhms(slut_dato,23,59,59);
	format slut_dttm start_dttm datetime20. ;
run;

proc casutil  incaslib="casuser" outcaslib="KKM" ;    
	save casdata="PRGD_OKONOMI" replace; 
	DROPTABLE CASDATA="PRGD_OKONOMI" INCASLIB="KKM" QUIET;
	load casdata="PRGD_OKONOMI.sashdat" 
	casout="PRGD_OKONOMI" 	
	incaslib="sandbox"  promote;
run;  
proc fedsql  sessref=mySession;
	drop table casuser.PRGD_OKONOMI ;
quit;


* PRGD_KKM_DATA *;
proc fedsql sessref=mysession;
	drop table kkm.PRGD_KKM_DATA
	;
quit;

proc fedsql sessref=mysession;
	create table casuser.PRGD_KKM_DATA  AS 
	select RAT.* , STAM.KUNDENR
	FROM  rating.PRGD_KKM_DATA  RAT, casuser.KUNDENR_DELM_ID STAM
	where  RAT.DEL_MODPARTS_ID=STAM.DEL_MODPARTS_ID
	;
quit;
data casuser.PRGD_KKM_DATA;
	set casuser.PRGD_KKM_DATA;
	start_dttm=dhms(start_dato,0,0,0) ;
	slut_dttm=dhms(slut_dato,23,59,59);
	format slut_dttm start_dttm datetime20. ;
run;

proc casutil  incaslib="casuser" outcaslib="KKM" ;    
	save casdata="PRGD_KKM_DATA" replace; 
	DROPTABLE CASDATA="PRGD_KKM_DATA" INCASLIB="KKM" QUIET;
	load casdata="PRGD_KKM_DATA.sashdat" 
	casout="PRGD_KKM_DATA" 	
	incaslib="sandbox"  promote;
run;  
proc fedsql  sessref=mySession;
	drop table casuser.PRGD_KKM_DATA ;
quit;



proc fedsql sessref=mysession;
	drop table kkm.PRGD_KKM_DATA_HIST
	;
quit;

proc fedsql sessref=mysession;
	create table casuser.PRGD_KKM_DATA_HIST  AS 
	select RAT.* , STAM.KUNDENR
	FROM  rating.PRGD_KKM_DATA_HIST  RAT, casuser.KUNDENR_DELM_ID STAM
	where  RAT.DEL_MODPARTS_ID=STAM.DEL_MODPARTS_ID
	;
quit;
data casuser.PRGD_KKM_DATA_HIST;
	set casuser.PRGD_KKM_DATA_HIST;
	start_dttm=dhms(start_dato,0,0,0) ;
	slut_dttm=dhms(slut_dato,23,59,59);
	format slut_dttm start_dttm datetime20. ;
run;

proc casutil  incaslib="casuser" outcaslib="KKM" ;    
	save casdata="PRGD_KKM_DATA_HIST" replace; 
	DROPTABLE CASDATA="PRGD_KKM_DATA_HIST" INCASLIB="KKM" QUIET;
	load casdata="PRGD_KKM_DATA_HIST.sashdat" 
	casout="PRGD_KKM_DATA_HIST" 	
	incaslib="sandbox"  promote;
run;  
proc fedsql  sessref=mySession;
	drop table casuser.PRGD_KKM_DATA_HIST ;
quit;



%HOP(PRRE_DEFAULT);
%HOP(PRRE_DEFAULT_HIST);

* PRGD_VIRKSOMHEDSOPL *;  
%HOP(PRGD_VIRKSOMHEDSOPL);
%HOP(PRGD_VIRKSOMHEDSOPL_HIST);
 
* PRGD_TK_KUNDE *; 
%HOP(PRGD_TK_KUNDE);
%HOP(PRGD_TK_KUNDE_HIST); 

* PRGD_STAMOPL *; 
%HOP(PRGD_STAMOPL);
%HOP(PRGD_STAMOPL_HIST); 

* PRGD_RYKKER *;
%HOP(PRGD_RYKKER);
%HOP(PRGD_RYKKER_HIST); 
 
* PRGD_REGNSKABER *; 
%HOP(PRGD_REGNSKABER);
%HOP(PRGD_REGNSKABER_HIST); 

* PRGD_PANTEBREV_KUNDE *;
%HOP(PRGD_PANTEBREV_KUNDE);
%HOP(PRGD_PANTEBREV_KUNDE_HIST); 

* PRGD_OVERTRK_KND *;
%HOP(PRGD_OVERTRK_KND);
%HOP(PRGD_OVERTRK_KND_HIST); 

* PRGD_MANUEL_RATING*; 
%HOP(PRGD_MANUEL_RATING);
%HOP(PRGD_MANUEL_RATING_HIST); 

* PRGD_KREDITFLAG *;
%HOP(PRGD_KREDITFLAG);
%HOP(PRGD_KREDITFLAG_HIST); 

* PRGD_EJERFORENING *; 
%HOP(PRGD_EJERFORENING);
%HOP(PRGD_EJERFORENING_HIST); 

* PRGD_ANDELSBOLIG *; 
%HOP(PRGD_ANDELSBOLIG);
%HOP(PRGD_ANDELSBOLIG_HIST); 
