/* cas mySession terminate; */
/* libname apdm "/abd/data/apdm"; */

cas mySession sessopts=(timeout=3500000);
caslib _all_ assign;
options casdatalimit=20000M;

* APDM -> Kør i  CODE EXECUTION;
/* filename apdmxpt filesrvc folderpath="/Public" filename="apdm.xpt" debug=http recfm=n; */
/* proc cport library=apdm file=apdmxpt; */
/* run; */


*  APDM -> WORK * kør i SAS STUDIO for at kopiere til work. ;
filename apdmxpt filesrvc folderpath="/Public" filename= "apdm.xpt" debug=http recfm=n;
proc cimport library=work file=apdmxpt;
run;

/*Dette sættes ind i code executer*/
/*Angiv nummer og navn. Tjek i tabel, hvad tidligere har  */
proc sql;
insert into apdm.subset_from_path_master 
values(1000001
	,'RAT Segmentering'
	,'RAT Segmentering'
	,"%sysfunc(datetime(),DATETIME.)"dt
	,"&sysuserid"
	,"%sysfunc(datetime(),DATETIME.)"dt
	,"&sysuserid");
quit;

/************************* STAMOPLYSNINGER *****************************************/
/*Angiv nr. og SK-nøgle for tabellen der skal bruges.  */
/*I dette tilfælde STAMOPLYSNINGER har SK-nøgle  1000028 */
proc sql;
insert into APDM.SUBSET_TABLE_JOIN_CONDITION 
	values(1000001,
	1000001,
	1,
	'INNER',
	1000028,
	NULL,
	NULL,
	NULL,
	"%sysfunc(datetime(),DATETIME.)"dt,
	"&sysuserid",
	"%sysfunc(datetime(),DATETIME.)"dt,
	"&sysuserid");
quit;

/* Find analyseniveau. Dette tilfælde RAT_DATA og kolonne nr. på key, som i dette tilfælde er KUNDENR */



/* level_key_column_dtl_sk=100001 findes i tabellen LEVEL_KEY_COLUMN_DTL */
proc sql;
insert into APDM.SUBSET_FROM_PATH_X_LEVEL 
	values(
		1000001
		,1000001
		, 1000826
		, 100001
		,"%sysfunc(datetime(),DATETIME.)"dt
		,"&sysuserid");
quit;

/************************* OKONOMI_KORR *****************************************/
/*Angiv nr. og SK-nøgle for tabellen der skal bruges.  */
/*I dette tilfælde STAMOPLYSNINGER har SK-nøgle  1000028 */
/*Første skal være et nyt nr. hver gang  */
proc sql;
insert into APDM.SUBSET_TABLE_JOIN_CONDITION 
	values(1000002,
	1000001,
	1,
	'LEFT',
	1000037,
	NULL,
	NULL,
	NULL,
	"%sysfunc(datetime(),DATETIME.)"dt,
	"&sysuserid",
	"%sysfunc(datetime(),DATETIME.)"dt,
	"&sysuserid");
quit;

/* Find analyseniveau. Dette tilfælde RAT_DATA og kolonne nr. på key, som i dette tilfælde er KUNDENR */



/* level_key_column_dtl_sk=100001 findes i tabellen LEVEL_KEY_COLUMN_DTL */
proc sql;
insert into APDM.SUBSET_FROM_PATH_X_LEVEL 
	values(
		1000001
		,1000001
		, 1001158
		, 100001
		,"%sysfunc(datetime(),DATETIME.)"dt
		,"&sysuserid");
quit;


/*Flere tabeller så gøres sådan her.  */
proc sql;
insert into APDM.SUBSET_TABLE_JOIN_CONDITION 
	values(1000001,
	1000001,
	1,
	'LEFT',
	1000028,
	1000826,
	1000037,
	1001158,
	"%sysfunc(datetime(),DATETIME.)"dt,
	"&sysuserid",
	"%sysfunc(datetime(),DATETIME.)"dt,
	"&sysuserid");
quit;


/* PROC SQL; */
/* DELETE FROM APDM.SUBSET_FROM_PATH_X_LEVEL */
/* WHERE select_source_column_sk=1001158 */
/* ; */
/* QUIT; */




