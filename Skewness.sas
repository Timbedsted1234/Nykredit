cas mySession sessopts=(timeout=3500000);
caslib _all_ assign;
options casdatalimit=500M;


%LET LIB = RAT_DATA;
%LET TABELNAME = OKONOMI_KORR_TRANS;


proc sql ;
select name into : vars separated by ","
from SASHELP.VCOLUMN
where LIBNAME = "&LIB."
and MEMNAME = "&TABELNAME."

;
quit;

%PUT &VARS.;

PROC FEDSQL SESSREF=mySession;
drop table casuser.test FORCE;
CREATE TABLE casuser.test AS SELECT 

SKEWNESS(&vars.) AS S_&vars.
FROM &LIB..&TABELNAME.
;
QUIT;










proc means  data=&LIB..&TABELNAME.  noprint;
var &vars.;
output out=OKONOMI_KORR_TRANS_STAT(drop=_type_ _freq_)  skew= kurt= / autoname;
run;


proc transpose data=OKONOMI_KORR_TRANS_STAT out=OKONOMI_KORR_TRANS_STAT;
run;

data out1;
set OKONOMI_KORR_TRANS_STAT;
Variable=substr(_name_, 1, length(_name_)-5);
stat=scan(_name_,-1,'_');
DoubleValue = COL1;
drop COL1;
drop _name_;
run;

proc sort data=out1;
by variable;
run;

