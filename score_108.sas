data &m_output_table_nm;
set &m_scoring_abt_table_nm;

*------------------------------------------------------------*;
* DABT JUDGEMENTAL SCORE CODE;
*------------------------------------------------------------*;

EM_SCORECARD_POINTS = 0;

*------------------------------------------------------------*;
* Variable: EJERFORENING;
*------------------------------------------------------------*;
if  NOT MISSING(EJERFORENING) then do;
if EJERFORENING in (1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 3 ;
GRP_EJERFORENING = 30720;
end;

else if EJERFORENING in (2) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4 ;
GRP_EJERFORENING = 30721;
end;

else if EJERFORENING in (3) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4 ;
GRP_EJERFORENING = 30721;
end;

else if EJERFORENING in (4) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4 ;
GRP_EJERFORENING = 30721;
end;

else if EJERFORENING in (5) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4 ;
GRP_EJERFORENING = 30721;
end;

else if EJERFORENING in (6) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 5 ;
GRP_EJERFORENING = 30722;
end;

else if EJERFORENING in (7) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 5 ;
GRP_EJERFORENING = 30722;
end;

else if EJERFORENING in (8) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 5 ;
GRP_EJERFORENING = 30722;
end;

else if EJERFORENING in (9) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 5 ;
GRP_EJERFORENING = 30722;
end;

else if EJERFORENING in (10) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 5 ;
GRP_EJERFORENING = 30722;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_EJERFORENING = 30723;
end;
end;
else if MISSING(EJERFORENING) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_EJERFORENING = 30723;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_EJERFORENING = 30723;
end;

SCORECARD_POINTS = EM_SCORECARD_POINTS;
run;