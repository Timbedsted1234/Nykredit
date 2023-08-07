data &m_output_table_nm;
set &m_scoring_abt_table_nm;

*------------------------------------------------------------*;
* DABT JUDGEMENTAL SCORE CODE;
*------------------------------------------------------------*;

EM_SCORECARD_POINTS = 0;

*------------------------------------------------------------*;
* Variable: ANSVARLIGT_LAAN;
*------------------------------------------------------------*;
if  NOT MISSING(ANSVARLIGT_LAAN) then do;
if ANSVARLIGT_LAAN in (1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 7 ;
GRP_ANSVARLIGT_LAAN = 23630;
end;

else if ANSVARLIGT_LAAN in (2) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 11 ;
GRP_ANSVARLIGT_LAAN = 23631;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_ANSVARLIGT_LAAN = 23632;
end;
end;
else if MISSING(ANSVARLIGT_LAAN) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_ANSVARLIGT_LAAN = 23632;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_ANSVARLIGT_LAAN = 23632;
end;

SCORECARD_POINTS = EM_SCORECARD_POINTS;
run;
