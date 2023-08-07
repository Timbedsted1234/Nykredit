/****************************************************
	NAME:	Nem_kto_ant.sas
	DESC: 	Beregener antal konto basreet på 
			del_modparts_id

****************************************************/
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

/* Kundenr <-> del_modparts_id *;

PROC FEDSQL sessref=mysession;
CREATE TABLE casuser.KUNDENR_DELM_ID AS 
	SELECT DISTINCT KUNDENR, DEL_MODPARTS_ID
	FROM KKM.PRGD_STAMOPL_HIST
;
QUIT;
*/
/*****************************************************
Kode til beregning af nem_kto_ant fra Tobias

PROC SQL;
CREATE TABLE PRGD_STAMOPL AS SELECT
*
,SUM(CASE WHEN NEMKONTO IN (.,0) THEN 0 ELSE 1 END) FORMAT = 12. AS NEM_KTO_ANT
 
FROM PROD.PRGD_STAMOPL
 
GROUP BY DEL_MODPARTS_ID
;
QUIT;
******************************************************/

proc fedsql sessref=mysession;
	drop table sandbox.nem_kto_ant
	;
quit; 

PROC FEDSQL  sessref=mysession;

CREATE TABLE sandbox.nem_kto_ant AS 
	SELECT start_dato, slut_dato, Kundenr, DEL_MODPARTS_ID, 
	SUM(CASE WHEN NEMKONTO IN (.,0) THEN 0 ELSE 1 END) AS NEM_KTO_ANT
 
FROM KKM.PRGD_STAMOPL_hist
 
GROUP BY kundenr ,DEL_MODPARTS_ID, start_dato, slut_dato
;
QUIT;

data casuser.nem_kto_ant;
	set sandbox.nem_kto_ant;
	start_dttm=dhms(start_dato,0,0,0) ;
	slut_dttm=dhms(slut_dato,23,59,99);
	format slut_dttm start_dttm datetime20. ;
run;

proc casutil  incaslib="casuser" outcaslib="sandbox" ;    
	save casdata="nem_kto_ant" replace; 
	DROPTABLE CASDATA="nem_kto_ant" INCASLIB="sandbox" QUIET;
	/*load casdata="nem_kto_ant" 
	casout="nem_kto_ant" 	
	incaslib="sandbox"  promote;*/
run;  
proc fedsql  sessref=mySession;
	drop table casuser.nem_kto_ant ;
quit;
 

/*
proc sort data=casuser.nem_kto_ant nodupkey;
	by start_dato slut_dato kundenr;
run;

PROC FEDSQL  sessref=mysession;

CREATE TABLE casuser.prgd_stamopl AS 
	SELECT start_dato, slut_dato, Kundenr, DEL_MODPARTS_ID, 
	SUM(CASE WHEN NEMKONTO IN (.,0) THEN 0 ELSE 1 END) AS NEM_KTO_ANT
 
FROM KKM.PRGD_STAMOPL
 
GROUP BY kundenr ,DEL_MODPARTS_ID, start_dato, slut_dato
;
QUIT;

