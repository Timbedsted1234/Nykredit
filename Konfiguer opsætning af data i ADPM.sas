libname apdm "/abd/data/apdm";


/*code execution*/
proc sql;
insert into apdm.library_master
(library_Sk,LIBRARY_REFERENCE,
LIBRARY_TYPE_CD, LIBRARY_SHORT_NM ,LIBRARY_DESC,
CREATED_DTTM ,CREATED_BY_USER ,
LAST_PROCESSED_DTTM ,LAST_PROCESSED_BY_USER)
VALUES (1000002,"RAT_DATA","SRC_TBL",
"RAT_DATA","Library for ny ratingmodel for AL anno 2023",
"%sysfunc(datetime(),DATETIME.)"dt, "B204991@al-bank.dk",
"%sysfunc(datetime(),DATETIME.)"dt, "sysuserid");
quit;

/*code execution*/
proc sql;
insert into APDM.PURPOSE_X_LEVEL
(level_Sk,purpose_sk,created_dttm,created_by_user)
VALUES (1000003,101,"%sysfunc(datetime(),DATETIME.)"dt,"B204991@al-bank.dk")
;
quit;
proc sql;
insert into APDM.PURPOSE_X_LEVEL
(level_Sk,purpose_sk,created_dttm,created_by_user)
VALUES (1000003,102,"%sysfunc(datetime(),DATETIME.)"dt,"B204991@al-bank.dk")
;
quit;
proc sql;
insert into APDM.PURPOSE_X_LEVEL
(level_Sk,purpose_sk,created_dttm,created_by_user)
VALUES (1000003,103,"%sysfunc(datetime(),DATETIME.)"dt,"B204991@al-bank.dk")
;
quit;

* APDM -> SAS STudio *  CODE EXECUTION;
filename apdmxpt filesrvc folderpath="/Public" filename="apdm.xpt" debug=http recfm=n;
proc cport library=apdm file=apdmxpt;
run;


*  APDM -> WORK * SAS STUDIO;
filename apdmxpt filesrvc folderpath="/Public" filename= "apdm.xpt" debug=http recfm=n;
proc cimport library=work file=apdmxpt;
run;


