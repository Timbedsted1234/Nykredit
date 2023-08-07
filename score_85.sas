data &m_output_table_nm;
set &m_scoring_abt_table_nm;

*------------------------------------------------------------*;
* DABT JUDGEMENTAL SCORE CODE;
*------------------------------------------------------------*;

EM_SCORECARD_POINTS = 0;

*------------------------------------------------------------*;
* Variable: MATRIX_MODEL;
*------------------------------------------------------------*;
if  NOT MISSING(MATRIX_MODEL) then do;
if MATRIX_MODEL in ("INTERN") then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4 ;
GRP_MATRIX_MODEL = 23638;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_MATRIX_MODEL = 23639;
end;
end;
else if MISSING(MATRIX_MODEL) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_MATRIX_MODEL = 23639;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_MATRIX_MODEL = 23639;
end;

SCORECARD_POINTS = EM_SCORECARD_POINTS;
run;
