/*******************************************************************
	NAME:	test_db_scor_write_access.sas
	DESC:	Tesetr mo jeg kan skrive resultater tilbage til AL DB
			Er nød til at lave manuelt sqlsvr access libname for at 
			kunne opdatere  data i DB tabel
********************************************************************/
cas mysession;
caslib _all_ assign ; 


libname scor_b  cas caslib="BATCH_SCORING";
data  casuser.class;
	set sashelp.class;
	weight=100;
run;

data  class;
	set sashelp.class;
	weight=100;
run;

data scor_b.class;
   modify scor_b.class casuser.class;
   by name;   
	*if _iorc_=0 then replace;
run;

proc fedsql sessref=mysession;
	select *
	INTO BATCH_SCORING.class
	FROM casuser.class
;
quit;

/**************** AL DB ********************
passwd=vNhxwIBt0KybCoc5qsFAPzlj8rudGmMS
userid=SAS
skema=BATCH_SCORING
DB=azure_mssql_dev
********************************************/

libname mydblib sqlsvr  user="SAS" password="vNhxwIBt0KybCoc5qsFAPzlj8rudGmMS" 
                schema="BATCH_SCORING" DB="azure_mssql_dev"; 
data mydblib.class;
   modify mydblib.class work.class;
   by name;   
	*if _iorc_=0 then replace;
run;

libname scor_l  cas caslib="LIVE_SCORING";
data scor_L.class;
	set sashelp.class;
	weight=100;
run;

libname mydblib sqlsvr  user="SAS" password="vNhxwIBt0KybCoc5qsFAPzlj8rudGmMS" 
                schema="LIVE_SCORING" DB="azure_mssql_dev"; 
data mydblib.class;
   modify mydblib.class scor_l.class;
   by name;   
	*if _iorc_=0 then replace;
run;
