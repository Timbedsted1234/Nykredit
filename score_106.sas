data &m_output_table_nm;
set &m_scoring_abt_table_nm;

*------------------------------------------------------------*;
* DABT JUDGEMENTAL SCORE CODE;
*------------------------------------------------------------*;

EM_SCORECARD_POINTS = 0;

*------------------------------------------------------------*;
* Variable: PANTEBREV;
*------------------------------------------------------------*;
if  NOT MISSING(PANTEBREV) then do;
if PANTEBREV in (1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 7 ;
GRP_PANTEBREV = 30715;
end;

else if PANTEBREV in (2) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 8 ;
GRP_PANTEBREV = 30716;
end;

else if PANTEBREV in (3) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 10 ;
GRP_PANTEBREV = 30717;
end;

else if PANTEBREV in (4) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 11 ;
GRP_PANTEBREV = 30718;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_PANTEBREV = 30719;
end;
end;
else if MISSING(PANTEBREV) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_PANTEBREV = 30719;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_PANTEBREV = 30719;
end;

SCORECARD_POINTS = EM_SCORECARD_POINTS;
run;
