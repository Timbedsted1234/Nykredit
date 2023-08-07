/* cas mySession terminate; */

cas mySession sessopts=(timeout=3500000);
caslib _all_ assign;
options casdatalimit=20000M;

/*****************************************************************************************************/
/************************ TRANSFORMATION AF DATA *****************************************************/
/*****************************************************************************************************/
/*  */
/* ADFAERD_KORR TABEL */
/* %LET VIYA_LIBRARY=RAT_DATA;  */
/* %LET ANALYSE_TABEL=ADFAERD_KORR; */
/* %LET TABEL_NAVN=ADFAERD_KORR_TRANS; */
/*  */
/* %LET VAR_1 = KUNDENR; */
/* %LET VAR_2 = ENGAGEMENT_SUM; */
/* %LET VAR_3 = TRANS_BALANCE_SUM; */
/* %LET ANTAL = 3; */
/*  */
/* %PUT &ANTAL. &VAR_1. &VAR_2.; */

/*  */
/* OKONOMI_KORR TABEL */
/* %LET VIYA_LIBRARY=RAT_DATA;  */
/* %LET ANALYSE_TABEL=OKONOMI_KORR; */
/* %LET TABEL_NAVN=OKONOMI_KORR_TRANS; */
/*  */
/* %LET VAR_1 = FORMUE_NETTO; */
/* %LET VAR_2 = GAELDSFAKTOR; */
/* %LET VAR_3 = RAAD_OPFYLD_GRAD9; */
/* %LET ANTAL = 3; */
/*  */
/*  */
/* %PUT &ANTAL. &VAR_1. &VAR_2.; */


/* OVERTRAEK_KORR TABEL */
/* %LET VIYA_LIBRARY=RAT_DATA;  */
/* %LET ANALYSE_TABEL=OVERTRAEK_KORR; */
/* %LET TABEL_NAVN=OVERTRAEK_KORR_TRANS; */
/*  */
/* %LET VAR_1 = OVERTRK_BLB; */
/*  */
/* %LET ANTAL = 1; */


/* REGNSKABER_KORR TABEL */
/* %LET VIYA_LIBRARY=RAT_DATA;  */
/* %LET ANALYSE_TABEL=REGNSKABER_KORR; */
/* %LET TABEL_NAVN=REGNSKABER_KORR_TRANS; */
/*  */
/* %LET VAR_1 = KUNDENR; */
/* %LET VAR_2 = REGNSKABSTAL_I; */
/* %LET ANTAL = 2; */
/*  */
/* %PUT &ANTAL. &VAR_1. &VAR_2.; */
/*  */
/*  */
/* RYKKER_KORR TABEL */
%LET VIYA_LIBRARY=RAT_DATA; 
%LET ANALYSE_TABEL=RYKKER_KORR;
%LET TABEL_NAVN=RYKKER_KORR_TRANS;


%LET VAR_1 = RYKKER_ANT;
%LET VAR_2 = RYKKER_BELOB;

%LET ANTAL = 2; 
/* %LET VAR_1 = RYKKER_1_ANT; */
/* %LET VAR_2 = RYKKER_2_ANT; */
/* %LET VAR_4 = RYKKER_1_BELOB; */
/* %LET VAR_5 = RYKKER_2_BELOB; */



/*  */
/* %PUT &ANTAL. &VAR_1. &VAR_2.; */
/*  */
/* STAMOPLYSNINGER_KORR TABEL */
/* %LET VIYA_LIBRARY=RAT_DATA;  */
/* %LET ANALYSE_TABEL=STAMOPLYSNINGER_KORR; */
/* %LET TABEL_NAVN=STAMOPLYSNINGER_KORR_TRANS; */
/*  */
/* %LET VAR_1 = KUNDENR; */
/* %LET VAR_2 = NEMKONTO; */
/* %LET ANTAL = 2; */
/*  */
/* %PUT &ANTAL. &VAR_1. &VAR_2.; */

%macro loop;
PROC FEDSQL SESSREF=mySession;
drop table CASUSER.statistik FORCE;
CREATE TABLE CASUSER.statistik as select 
mean(&VAR_1.) as &VAR_1._mean
,std(&VAR_1.) as &VAR_1._std
,-min(&VAR_1.) as &VAR_1._min 
%DO I=2 %TO &ANTAL.;
,mean(&&VAR_&I..) as &&VAR_&I.._mean
,std(&&VAR_&I..) as &&VAR_&I.._STD
,-min(&&VAR_&I..) as &&VAR_&I.._min 
%END;
from &VIYA_LIBRARY..&ANALYSE_TABEL.
;
QUIT;
%mend;
%loop;

%macro loop2;
%DO I=1 %TO &ANTAL.;
%global
&&VAR_&I.._mean
&&VAR_&I.._std
&&VAR_&I.._min 
;
%END;

PROC SQL; 
SELECT 
&VAR_1._mean
,&VAR_1._std
,&VAR_1._min format=22.8
%DO I=2 %TO &ANTAL.;
,&&VAR_&I.._mean
,&&VAR_&I.._STD
,&&VAR_&I.._min format=22.8
%END;

INTO 
:&VAR_1._mean
,:&VAR_1._std
,:&VAR_1._min 
%DO I=2 %TO &ANTAL.;
,:&&VAR_&I.._mean
,:&&VAR_&I.._std
,:&&VAR_&I.._min 
%END;

FROM CASUSER.statistik 
;
QUIT;
%mend;
%loop2;


/* %PUT &&&VAR_1._mean. &&&VAR_2._mean. &&&VAR_1._std. &&&VAR_2._std.; */

/* OUTLIERS */
%macro loop3; 
PROC FEDSQL SESSREF=mySession;
drop table CASUSER.statistik_OUTLIERS FORCE;
CREATE TABLE CASUSER.statistik_OUTLIERS AS SELECT 
KUNDENR
,START_DATO
,SLUT_DATO
,start_dttm
,slut_dttm
 %DO I=1 %TO &ANTAL.; 
 ,&&VAR_&I..
 ,CASE WHEN &&&&&&VAR_&I.._mean. + 2 * &&&&&&VAR_&I.._STD. < &&VAR_&I.. THEN  &&&&&&VAR_&I.._mean. + 2 * &&&&&&VAR_&I.._STD. 
 	   WHEN &&&&&&VAR_&I.._mean. - 2 * &&&&&&VAR_&I.._STD. > &&VAR_&I.. AND &&VAR_&I.. IS NOT MISSING THEN &&&&&&VAR_&I.._mean. - 2 * &&&&&&VAR_&I.._STD. 
	   ELSE &&VAR_&I.. END AS &&VAR_&I.._2STD
 ,CASE WHEN &&&&&&VAR_&I.._mean. + 4 * &&&&&&VAR_&I.._STD. < &&VAR_&I.. THEN  &&&&&&VAR_&I.._mean. + 4 * &&&&&&VAR_&I.._STD. 
 	   WHEN &&&&&&VAR_&I.._mean. - 4 * &&&&&&VAR_&I.._STD. > &&VAR_&I.. AND &&VAR_&I.. IS NOT MISSING THEN &&&&&&VAR_&I.._mean. - 4 * &&&&&&VAR_&I.._STD. 
	   ELSE &&VAR_&I.. END AS &&VAR_&I.._4STD
 ,CASE WHEN &&&&&&VAR_&I.._mean. + 6 * &&&&&&VAR_&I.._STD. < &&VAR_&I.. THEN  &&&&&&VAR_&I.._mean. + 6 * &&&&&&VAR_&I.._STD. 
	   WHEN &&&&&&VAR_&I.._mean. - 6 * &&&&&&VAR_&I.._STD. > &&VAR_&I.. AND &&VAR_&I.. IS NOT MISSING THEN &&&&&&VAR_&I.._mean. - 6 * &&&&&&VAR_&I.._STD. 
	   ELSE &&VAR_&I.. END AS &&VAR_&I.._6STD
 ,CASE WHEN &&&&&&VAR_&I.._mean. + 8 * &&&&&&VAR_&I.._STD. < &&VAR_&I.. THEN  &&&&&&VAR_&I.._mean. + 8 * &&&&&&VAR_&I.._STD. 
	   WHEN &&&&&&VAR_&I.._mean. - 8 * &&&&&&VAR_&I.._STD. > &&VAR_&I.. AND &&VAR_&I.. IS NOT MISSING THEN &&&&&&VAR_&I.._mean. - 8 * &&&&&&VAR_&I.._STD. 
	   ELSE &&VAR_&I.. END AS &&VAR_&I.._8STD  
 %END;    

FROM &VIYA_LIBRARY..&ANALYSE_TABEL.
;
QUIT;



/* LOG */
PROC FEDSQL SESSREF=mySession;
drop table CASUSER.&TABEL_NAVN FORCE;
CREATE TABLE CASUSER.&TABEL_NAVN. AS SELECT 
*
%DO I=1 %TO &ANTAL.; 
  ,LOG(&&VAR_&I.. + &&&&&&VAR_&I.._min. + 1) AS &&VAR_&I.._LOG 
  ,LOG(&&VAR_&I.._2STD + &&&&&&VAR_&I.._min. + 1) AS &&VAR_&I.._2STD_LOG 
  ,LOG(&&VAR_&I.._4STD + &&&&&&VAR_&I.._min. + 1) AS &&VAR_&I.._4STD_LOG 
  ,LOG(&&VAR_&I.._6STD + &&&&&&VAR_&I.._min. + 1) AS &&VAR_&I.._6STD_LOG 
  ,LOG(&&VAR_&I.._8STD + &&&&&&VAR_&I.._min. + 1) AS &&VAR_&I.._8STD_LOG 
%END; 

FROM CASUSER.statistik_OUTLIERS
;
QUIT;
%MEND;
%loop3;



	proc casutil  incaslib="casuser" outcaslib="&VIYA_LIBRARY." ;    
		save casdata="&TABEL_NAVN." replace; 
		DROPTABLE CASDATA="&TABEL_NAVN." INCASLIB="&VIYA_LIBRARY." QUIET;
		load casdata="&TABEL_NAVN..sashdat" 
		casout="&TABEL_NAVN." 	
		incaslib="&VIYA_LIBRARY."  promote;
	run;


