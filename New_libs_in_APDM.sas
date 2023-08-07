/***************************************************************************************************************
	NAME:	New_libs_in_APDM.sas
	DESC: 	Create 2 entries in APDM for the new libraries KKM and sandbox
****************************************************************************************************************/

proc sql; 

insert into apdm.library_master (LIBRARY_SK, LIBRARY_REFERENCE, LIBRARY_TYPE_CD, LIBRARY_SHORT_NM ,LIBRARY_DESC,  

CREATED_DTTM ,CREATED_BY_USER ,LAST_PROCESSED_DTTM ,LAST_PROCESSED_BY_USER)  

VALUES (1000000, "KKM","SRC_TBL", 

"KKM data","AL KKM data from Azure DB", 

"%sysfunc(datetime(),DATETIME.)"dt, "&sysuserid",  

"%sysfunc(datetime(),DATETIME.)"dt, "sysuserid") 

; 

quit; 

 
 
 proc sql; 

insert into apdm.library_master (LIBRARY_SK, LIBRARY_REFERENCE, LIBRARY_TYPE_CD, LIBRARY_SHORT_NM ,LIBRARY_DESC,  

CREATED_DTTM ,CREATED_BY_USER ,LAST_PROCESSED_DTTM ,LAST_PROCESSED_BY_USER)  

VALUES (1000001, "sandbox","SRC_TBL", 

"Sandbox data","AL SANDKASSE data from Azure DB", 

"%sysfunc(datetime(),DATETIME.)"dt, "&sysuserid",  

"%sysfunc(datetime(),DATETIME.)"dt, "sysuserid") 

; 

quit; 