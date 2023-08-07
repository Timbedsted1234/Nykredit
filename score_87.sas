data &m_output_table_nm;
set &m_scoring_abt_table_nm;

*------------------------------------------------------------*;
* DABT JUDGEMENTAL SCORE CODE;
*------------------------------------------------------------*;

EM_SCORECARD_POINTS = 0;

*------------------------------------------------------------*;
* Variable: REST_ERHVERV;
*------------------------------------------------------------*;
if  NOT MISSING(REST_ERHVERV) then do;
if REST_ERHVERV in (1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 6 ;
GRP_REST_ERHVERV = 23644;
end;

else if REST_ERHVERV in (2) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 5 ;
GRP_REST_ERHVERV = 23645;
end;

else if REST_ERHVERV in (3) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4 ;
GRP_REST_ERHVERV = 23646;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_REST_ERHVERV = 23647;
end;
end;
else if MISSING(REST_ERHVERV) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_REST_ERHVERV = 23647;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_REST_ERHVERV = 23647;
end;

SCORECARD_POINTS = EM_SCORECARD_POINTS;
run;
