data &m_output_table_nm;
set &m_scoring_abt_table_nm;

*------------------------------------------------------------*;
* DABT JUDGEMENTAL SCORE CODE;
*------------------------------------------------------------*;

EM_SCORECARD_POINTS = 0;

*------------------------------------------------------------*;
* Variable: REST_PRIVAT;
*------------------------------------------------------------*;
if  NOT MISSING(REST_PRIVAT) then do;
if REST_PRIVAT in (1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 6 ;
GRP_REST_PRIVAT = 23610;
end;

else if REST_PRIVAT in (2) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 5 ;
GRP_REST_PRIVAT = 23611;
end;

else if REST_PRIVAT in (3) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4 ;
GRP_REST_PRIVAT = 23612;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_REST_PRIVAT = 23613;
end;
end;
else if MISSING(REST_PRIVAT) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_REST_PRIVAT = 23613;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_REST_PRIVAT = 23613;
end;

SCORECARD_POINTS = EM_SCORECARD_POINTS;
run;
