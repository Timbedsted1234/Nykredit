data &m_output_table_nm;
set &m_scoring_abt_table_nm;

*------------------------------------------------------------*;
* DABT JUDGEMENTAL SCORE CODE;
*------------------------------------------------------------*;

EM_SCORECARD_POINTS = 0;

*------------------------------------------------------------*;
* Variable: BELAANINGSGRAD_1;
*------------------------------------------------------------*;
if  NOT MISSING(BELAANINGSGRAD_1) then do;
if BELAANINGSGRAD_1 <15 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -14567223 ;
GRP_BELAANINGSGRAD_1 = 32934;
end;

else if BELAANINGSGRAD_1>=15 and BELAANINGSGRAD_1<30 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -9587742 ;
GRP_BELAANINGSGRAD_1 = 32935;
end;

else if BELAANINGSGRAD_1>=30 and BELAANINGSGRAD_1<50 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 5350703 ;
GRP_BELAANINGSGRAD_1 = 32936;
end;

else if BELAANINGSGRAD_1>=50 and BELAANINGSGRAD_1<70 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 10330184 ;
GRP_BELAANINGSGRAD_1 = 32937;
end;

else if BELAANINGSGRAD_1>=70 and BELAANINGSGRAD_1<90 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 25268627 ;
GRP_BELAANINGSGRAD_1 = 32938;
end;

else if BELAANINGSGRAD_1 >=90 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 30248108 ;
GRP_BELAANINGSGRAD_1 = 32939;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 30248108 ;
GRP_BELAANINGSGRAD_1 = 32939;
end;
end;
else if MISSING(BELAANINGSGRAD_1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 30248108 ;
GRP_BELAANINGSGRAD_1 = 32939;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 30248108 ;
GRP_BELAANINGSGRAD_1 = 32939;
end;


*------------------------------------------------------------*;
* Variable: ANDEL_M2PRIS_FORHOLD;
*------------------------------------------------------------*;
if  NOT MISSING(ANDEL_M2PRIS_FORHOLD) then do;
if ANDEL_M2PRIS_FORHOLD <=-1 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 24887684 ;
GRP_ANDEL_M2PRIS_FORHOLD = 32929;
end;

else if ANDEL_M2PRIS_FORHOLD>-1 and ANDEL_M2PRIS_FORHOLD<=-0.6 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -3670750 ;
GRP_ANDEL_M2PRIS_FORHOLD = 32930;
end;

else if ANDEL_M2PRIS_FORHOLD>-0.6 and ANDEL_M2PRIS_FORHOLD<=-0.2000 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -3670750 ;
GRP_ANDEL_M2PRIS_FORHOLD = 32930;
end;

else if ANDEL_M2PRIS_FORHOLD>-0.2000 and ANDEL_M2PRIS_FORHOLD<=0 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 24887684 ;
GRP_ANDEL_M2PRIS_FORHOLD = 32929;
end;

else if ANDEL_M2PRIS_FORHOLD >0 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 53446118 ;
GRP_ANDEL_M2PRIS_FORHOLD = 32931;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 24887684 ;
GRP_ANDEL_M2PRIS_FORHOLD = 32929;
end;
end;
else if MISSING(ANDEL_M2PRIS_FORHOLD) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 24887684 ;
GRP_ANDEL_M2PRIS_FORHOLD = 32929;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 24887684 ;
GRP_ANDEL_M2PRIS_FORHOLD = 32929;
end;


*------------------------------------------------------------*;
* Variable: SLSK_ANTAL_MEDARB;
*------------------------------------------------------------*;
if  NOT MISSING(SLSK_ANTAL_MEDARB) then do;
if SLSK_ANTAL_MEDARB in (1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -362917 ;
GRP_SLSK_ANTAL_MEDARB = 32952;
end;

else if SLSK_ANTAL_MEDARB in (2) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 3915102 ;
GRP_SLSK_ANTAL_MEDARB = 32953;
end;

else if SLSK_ANTAL_MEDARB in (3) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 1776093 ;
GRP_SLSK_ANTAL_MEDARB = 32954;
end;

else if SLSK_ANTAL_MEDARB in (4) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -362917 ;
GRP_SLSK_ANTAL_MEDARB = 32952;
end;

else if SLSK_ANTAL_MEDARB in (5) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 3915102 ;
GRP_SLSK_ANTAL_MEDARB = 32953;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 3915102 ;
GRP_SLSK_ANTAL_MEDARB = 32953;
end;
end;
else if MISSING(SLSK_ANTAL_MEDARB) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 3915102 ;
GRP_SLSK_ANTAL_MEDARB = 32953;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 3915102 ;
GRP_SLSK_ANTAL_MEDARB = 32953;
end;


*------------------------------------------------------------*;
* Variable: SLSK_ETABLERINGSAAR;
*------------------------------------------------------------*;
if  NOT MISSING(SLSK_ETABLERINGSAAR) then do;
if SLSK_ETABLERINGSAAR in (1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -833863 ;
GRP_SLSK_ETABLERINGSAAR = 32955;
end;

else if SLSK_ETABLERINGSAAR in (2) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 8848901 ;
GRP_SLSK_ETABLERINGSAAR = 32956;
end;

else if SLSK_ETABLERINGSAAR in (3) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4007519 ;
GRP_SLSK_ETABLERINGSAAR = 32957;
end;

else if SLSK_ETABLERINGSAAR in (4) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -833863 ;
GRP_SLSK_ETABLERINGSAAR = 32955;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -833863 ;
GRP_SLSK_ETABLERINGSAAR = 32955;
end;
end;
else if MISSING(SLSK_ETABLERINGSAAR) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -833863 ;
GRP_SLSK_ETABLERINGSAAR = 32955;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -833863 ;
GRP_SLSK_ETABLERINGSAAR = 32955;
end;


*------------------------------------------------------------*;
* Variable: INDLAAN_SUM_MEAN_6MND;
*------------------------------------------------------------*;
if  NOT MISSING(INDLAAN_SUM_MEAN_6MND) then do;
if INDLAAN_SUM_MEAN_6MND in (1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 1591305 ;
GRP_INDLAAN_SUM_MEAN_6MND = 32940;
end;

else if INDLAAN_SUM_MEAN_6MND in (2) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 1591305 ;
GRP_INDLAAN_SUM_MEAN_6MND = 32940;
end;

else if INDLAAN_SUM_MEAN_6MND in (3) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 745652 ;
GRP_INDLAAN_SUM_MEAN_6MND = 32941;
end;

else if INDLAAN_SUM_MEAN_6MND in (4) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -100000 ;
GRP_INDLAAN_SUM_MEAN_6MND = 32942;
end;

else if INDLAAN_SUM_MEAN_6MND in (5) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -1791305 ;
GRP_INDLAAN_SUM_MEAN_6MND = 32943;
end;

else if INDLAAN_SUM_MEAN_6MND in (6) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 1591305 ;
GRP_INDLAAN_SUM_MEAN_6MND = 32940;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 1591305 ;
GRP_INDLAAN_SUM_MEAN_6MND = 32940;
end;
end;
else if MISSING(INDLAAN_SUM_MEAN_6MND) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 1591305 ;
GRP_INDLAAN_SUM_MEAN_6MND = 32940;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 1591305 ;
GRP_INDLAAN_SUM_MEAN_6MND = 32940;
end;


*------------------------------------------------------------*;
* Variable: ANDEL_REGION;
*------------------------------------------------------------*;
if  NOT MISSING(ANDEL_REGION) then do;
if ANDEL_REGION in (1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -668212 ;
GRP_ANDEL_REGION = 32932;
end;

else if ANDEL_REGION in (2) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 9329271 ;
GRP_ANDEL_REGION = 32933;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 9329271 ;
GRP_ANDEL_REGION = 32933;
end;
end;
else if MISSING(ANDEL_REGION) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 9329271 ;
GRP_ANDEL_REGION = 32933;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 9329271 ;
GRP_ANDEL_REGION = 32933;
end;


*------------------------------------------------------------*;
* Variable: OVERTRK_MAX_AKT_MAX_6MND_X;
*------------------------------------------------------------*;
if  NOT MISSING(OVERTRK_MAX_AKT_MAX_6MND_X) then do;
if OVERTRK_MAX_AKT_MAX_6MND_X in (1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -249504 ;
GRP_OVERTRK_MAX_AKT_MAX_6MND_X = 32948;
end;

else if OVERTRK_MAX_AKT_MAX_6MND_X in (2) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 9456197 ;
GRP_OVERTRK_MAX_AKT_MAX_6MND_X = 32949;
end;

else if OVERTRK_MAX_AKT_MAX_6MND_X in (3) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 19161897 ;
GRP_OVERTRK_MAX_AKT_MAX_6MND_X = 32950;
end;

else if OVERTRK_MAX_AKT_MAX_6MND_X in (4) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 38573298 ;
GRP_OVERTRK_MAX_AKT_MAX_6MND_X = 32951;
end;

else if OVERTRK_MAX_AKT_MAX_6MND_X in (5) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 38573298 ;
GRP_OVERTRK_MAX_AKT_MAX_6MND_X = 32951;
end;

else if OVERTRK_MAX_AKT_MAX_6MND_X in (6) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -249504 ;
GRP_OVERTRK_MAX_AKT_MAX_6MND_X = 32948;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -249504 ;
GRP_OVERTRK_MAX_AKT_MAX_6MND_X = 32948;
end;
end;
else if MISSING(OVERTRK_MAX_AKT_MAX_6MND_X) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -249504 ;
GRP_OVERTRK_MAX_AKT_MAX_6MND_X = 32948;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -249504 ;
GRP_OVERTRK_MAX_AKT_MAX_6MND_X = 32948;
end;


*------------------------------------------------------------*;
* Variable: ORDINAERT_RES;
*------------------------------------------------------------*;
if  NOT MISSING(ORDINAERT_RES) then do;
if ORDINAERT_RES in (1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -1398743 ;
GRP_ORDINAERT_RES = 32944;
end;

else if ORDINAERT_RES in (2) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 26267921 ;
GRP_ORDINAERT_RES = 32945;
end;

else if ORDINAERT_RES in (3) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 7823478 ;
GRP_ORDINAERT_RES = 32946;
end;

else if ORDINAERT_RES in (4) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 17045699 ;
GRP_ORDINAERT_RES = 32947;
end;

else if ORDINAERT_RES in (5) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 26267921 ;
GRP_ORDINAERT_RES = 32945;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 26267921 ;
GRP_ORDINAERT_RES = 32945;
end;
end;
else if MISSING(ORDINAERT_RES) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 26267921 ;
GRP_ORDINAERT_RES = 32945;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 26267921 ;
GRP_ORDINAERT_RES = 32945;
end;

SCORECARD_POINTS = EM_SCORECARD_POINTS;
run;
