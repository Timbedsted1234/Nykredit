data &m_output_table_nm;
set &m_scoring_abt_table_nm;

*------------------------------------------------------------*;
* DABT JUDGEMENTAL SCORE CODE;
*------------------------------------------------------------*;

EM_SCORECARD_POINTS = 0;

*------------------------------------------------------------*;
* Variable: UDLAAN_SUM_EBITDA;
*------------------------------------------------------------*;
if  NOT MISSING(UDLAAN_SUM_EBITDA) then do;
if UDLAAN_SUM_EBITDA <-2020 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_UDLAAN_SUM_EBITDA = 26805;
end;

else if UDLAAN_SUM_EBITDA>=-2020 and UDLAAN_SUM_EBITDA<-620 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 15 ;
GRP_UDLAAN_SUM_EBITDA = 26806;
end;

else if UDLAAN_SUM_EBITDA>=-620 and UDLAAN_SUM_EBITDA<-420 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 25 ;
GRP_UDLAAN_SUM_EBITDA = 26807;
end;

else if UDLAAN_SUM_EBITDA>=-420 and UDLAAN_SUM_EBITDA<-220 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 37 ;
GRP_UDLAAN_SUM_EBITDA = 26808;
end;

else if UDLAAN_SUM_EBITDA>=-220 and UDLAAN_SUM_EBITDA<-110 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 45 ;
GRP_UDLAAN_SUM_EBITDA = 26809;
end;

else if UDLAAN_SUM_EBITDA>=-110 and UDLAAN_SUM_EBITDA<-10 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 54 ;
GRP_UDLAAN_SUM_EBITDA = 26810;
end;

else if UDLAAN_SUM_EBITDA>=-10 and UDLAAN_SUM_EBITDA<0 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 123 ;
GRP_UDLAAN_SUM_EBITDA = 26811;
end;

else if UDLAAN_SUM_EBITDA >=0 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 7 ;
GRP_UDLAAN_SUM_EBITDA = 26812;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 7 ;
GRP_UDLAAN_SUM_EBITDA = 26812;
end;
end;
else if MISSING(UDLAAN_SUM_EBITDA) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 7 ;
GRP_UDLAAN_SUM_EBITDA = 26812;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 7 ;
GRP_UDLAAN_SUM_EBITDA = 26812;
end;


*------------------------------------------------------------*;
* Variable: AVG_DEBOMS_AVG_KREDOMS;
*------------------------------------------------------------*;
if  NOT MISSING(AVG_DEBOMS_AVG_KREDOMS) then do;
if AVG_DEBOMS_AVG_KREDOMS <100 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 603 ;
GRP_AVG_DEBOMS_AVG_KREDOMS = 26776;
end;

else if AVG_DEBOMS_AVG_KREDOMS>=100 and AVG_DEBOMS_AVG_KREDOMS<110 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 583 ;
GRP_AVG_DEBOMS_AVG_KREDOMS = 26777;
end;

else if AVG_DEBOMS_AVG_KREDOMS>=110 and AVG_DEBOMS_AVG_KREDOMS<155 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 576 ;
GRP_AVG_DEBOMS_AVG_KREDOMS = 26778;
end;

else if AVG_DEBOMS_AVG_KREDOMS>=155 and AVG_DEBOMS_AVG_KREDOMS<290 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 558 ;
GRP_AVG_DEBOMS_AVG_KREDOMS = 26779;
end;

else if AVG_DEBOMS_AVG_KREDOMS >=290 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 552 ;
GRP_AVG_DEBOMS_AVG_KREDOMS = 26780;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 552 ;
GRP_AVG_DEBOMS_AVG_KREDOMS = 26780;
end;
end;
else if MISSING(AVG_DEBOMS_AVG_KREDOMS) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 552 ;
GRP_AVG_DEBOMS_AVG_KREDOMS = 26780;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 552 ;
GRP_AVG_DEBOMS_AVG_KREDOMS = 26780;
end;


*------------------------------------------------------------*;
* Variable: MIN_KREDOMS_AVG_KREDOMS;
*------------------------------------------------------------*;
if  NOT MISSING(MIN_KREDOMS_AVG_KREDOMS) then do;
if MIN_KREDOMS_AVG_KREDOMS <10 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_MIN_KREDOMS_AVG_KREDOMS = 26788;
end;

else if MIN_KREDOMS_AVG_KREDOMS>=10 and MIN_KREDOMS_AVG_KREDOMS<45 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_MIN_KREDOMS_AVG_KREDOMS = 26788;
end;

else if MIN_KREDOMS_AVG_KREDOMS>=45 and MIN_KREDOMS_AVG_KREDOMS<60 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_MIN_KREDOMS_AVG_KREDOMS = 26788;
end;

else if MIN_KREDOMS_AVG_KREDOMS>=60 and MIN_KREDOMS_AVG_KREDOMS<75 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_MIN_KREDOMS_AVG_KREDOMS = 26788;
end;

else if MIN_KREDOMS_AVG_KREDOMS >=75 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_MIN_KREDOMS_AVG_KREDOMS = 26788;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_MIN_KREDOMS_AVG_KREDOMS = 26788;
end;
end;
else if MISSING(MIN_KREDOMS_AVG_KREDOMS) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_MIN_KREDOMS_AVG_KREDOMS = 26788;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_MIN_KREDOMS_AVG_KREDOMS = 26788;
end;


*------------------------------------------------------------*;
* Variable: UDNYTTEGRAD_KREDIT_MEAN_3MND;
*------------------------------------------------------------*;
if  NOT MISSING(UDNYTTEGRAD_KREDIT_MEAN_3MND) then do;
if UDNYTTEGRAD_KREDIT_MEAN_3MND <25 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 105 ;
GRP_UDNYTTEGRAD_KREDIT_MEAN_3MND = 26781;
end;

else if UDNYTTEGRAD_KREDIT_MEAN_3MND>=25 and UDNYTTEGRAD_KREDIT_MEAN_3MND<65 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 68 ;
GRP_UDNYTTEGRAD_KREDIT_MEAN_3MND = 26782;
end;

else if UDNYTTEGRAD_KREDIT_MEAN_3MND>=65 and UDNYTTEGRAD_KREDIT_MEAN_3MND<80 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 58 ;
GRP_UDNYTTEGRAD_KREDIT_MEAN_3MND = 26783;
end;

else if UDNYTTEGRAD_KREDIT_MEAN_3MND>=80 and UDNYTTEGRAD_KREDIT_MEAN_3MND<95 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 47 ;
GRP_UDNYTTEGRAD_KREDIT_MEAN_3MND = 26784;
end;

else if UDNYTTEGRAD_KREDIT_MEAN_3MND>=95 and UDNYTTEGRAD_KREDIT_MEAN_3MND<100 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 31 ;
GRP_UDNYTTEGRAD_KREDIT_MEAN_3MND = 26785;
end;

else if UDNYTTEGRAD_KREDIT_MEAN_3MND>=100 and UDNYTTEGRAD_KREDIT_MEAN_3MND<105 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 21 ;
GRP_UDNYTTEGRAD_KREDIT_MEAN_3MND = 26786;
end;

else if UDNYTTEGRAD_KREDIT_MEAN_3MND >=105 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_UDNYTTEGRAD_KREDIT_MEAN_3MND = 26787;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 105 ;
GRP_UDNYTTEGRAD_KREDIT_MEAN_3MND = 26781;
end;
end;
else if MISSING(UDNYTTEGRAD_KREDIT_MEAN_3MND) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 105 ;
GRP_UDNYTTEGRAD_KREDIT_MEAN_3MND = 26781;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 105 ;
GRP_UDNYTTEGRAD_KREDIT_MEAN_3MND = 26781;
end;


*------------------------------------------------------------*;
* Variable: OVERTRK_MAX_AKT_MAX_6MND;
*------------------------------------------------------------*;
if  NOT MISSING(OVERTRK_MAX_AKT_MAX_6MND) then do;
if OVERTRK_MAX_AKT_MAX_6MND>=0 and OVERTRK_MAX_AKT_MAX_6MND<=0 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 122 ;
GRP_OVERTRK_MAX_AKT_MAX_6MND = 26796;
end;

else if OVERTRK_MAX_AKT_MAX_6MND>0 and OVERTRK_MAX_AKT_MAX_6MND<=5 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 91 ;
GRP_OVERTRK_MAX_AKT_MAX_6MND = 26797;
end;

else if OVERTRK_MAX_AKT_MAX_6MND>5 and OVERTRK_MAX_AKT_MAX_6MND<=20 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 69 ;
GRP_OVERTRK_MAX_AKT_MAX_6MND = 26798;
end;

else if OVERTRK_MAX_AKT_MAX_6MND>20 and OVERTRK_MAX_AKT_MAX_6MND<=30 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 56 ;
GRP_OVERTRK_MAX_AKT_MAX_6MND = 26799;
end;

else if OVERTRK_MAX_AKT_MAX_6MND>30 and OVERTRK_MAX_AKT_MAX_6MND<=60 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 39 ;
GRP_OVERTRK_MAX_AKT_MAX_6MND = 26800;
end;

else if OVERTRK_MAX_AKT_MAX_6MND>60 and OVERTRK_MAX_AKT_MAX_6MND<=90 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 3 ;
GRP_OVERTRK_MAX_AKT_MAX_6MND = 26801;
end;

else if OVERTRK_MAX_AKT_MAX_6MND >90 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_OVERTRK_MAX_AKT_MAX_6MND = 26802;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 122 ;
GRP_OVERTRK_MAX_AKT_MAX_6MND = 26796;
end;
end;
else if MISSING(OVERTRK_MAX_AKT_MAX_6MND) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 122 ;
GRP_OVERTRK_MAX_AKT_MAX_6MND = 26796;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 122 ;
GRP_OVERTRK_MAX_AKT_MAX_6MND = 26796;
end;


*------------------------------------------------------------*;
* Variable: OVERTR_EGENKAP;
*------------------------------------------------------------*;
if  NOT MISSING(OVERTR_EGENKAP) then do;
if OVERTR_EGENKAP <0 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 7 ;
GRP_OVERTR_EGENKAP = 26789;
end;

else if OVERTR_EGENKAP>=0 and OVERTR_EGENKAP<=0 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 50 ;
GRP_OVERTR_EGENKAP = 26790;
end;

else if OVERTR_EGENKAP>0 and OVERTR_EGENKAP<0.05 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 35 ;
GRP_OVERTR_EGENKAP = 26791;
end;

else if OVERTR_EGENKAP>=0.05 and OVERTR_EGENKAP<0.25 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 26 ;
GRP_OVERTR_EGENKAP = 26792;
end;

else if OVERTR_EGENKAP>=0.25 and OVERTR_EGENKAP<2.4 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 17 ;
GRP_OVERTR_EGENKAP = 26793;
end;

else if OVERTR_EGENKAP>=2.4 and OVERTR_EGENKAP<7.35 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 13 ;
GRP_OVERTR_EGENKAP = 26794;
end;

else if OVERTR_EGENKAP>=7.35 and OVERTR_EGENKAP<19.8 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 7 ;
GRP_OVERTR_EGENKAP = 26789;
end;

else if OVERTR_EGENKAP >=19.8 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_OVERTR_EGENKAP = 26795;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_OVERTR_EGENKAP = 26795;
end;
end;
else if MISSING(OVERTR_EGENKAP) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_OVERTR_EGENKAP = 26795;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_OVERTR_EGENKAP = 26795;
end;


*------------------------------------------------------------*;
* Variable: TRANS_LIM_EGENKAP;
*------------------------------------------------------------*;
if  NOT MISSING(TRANS_LIM_EGENKAP) then do;
if TRANS_LIM_EGENKAP in (0) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 26 ;
GRP_TRANS_LIM_EGENKAP = 26803;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 5 ;
GRP_TRANS_LIM_EGENKAP = 26804;
end;
end;
else if MISSING(TRANS_LIM_EGENKAP) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 5 ;
GRP_TRANS_LIM_EGENKAP = 26804;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 5 ;
GRP_TRANS_LIM_EGENKAP = 26804;
end;


*------------------------------------------------------------*;
* Variable: UDLAAN_SUM_EGENKAP;
*------------------------------------------------------------*;
if  NOT MISSING(UDLAAN_SUM_EGENKAP) then do;
if UDLAAN_SUM_EGENKAP <-245 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 5 ;
GRP_UDLAAN_SUM_EGENKAP = 26813;
end;

else if UDLAAN_SUM_EGENKAP>=-245 and UDLAAN_SUM_EGENKAP<-35 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 21 ;
GRP_UDLAAN_SUM_EGENKAP = 26814;
end;

else if UDLAAN_SUM_EGENKAP>=-35 and UDLAAN_SUM_EGENKAP<-10 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 33 ;
GRP_UDLAAN_SUM_EGENKAP = 26815;
end;

else if UDLAAN_SUM_EGENKAP>=-10 and UDLAAN_SUM_EGENKAP<=0 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 43 ;
GRP_UDLAAN_SUM_EGENKAP = 26816;
end;

else if UDLAAN_SUM_EGENKAP >0 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_UDLAAN_SUM_EGENKAP = 26817;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_UDLAAN_SUM_EGENKAP = 26817;
end;
end;
else if MISSING(UDLAAN_SUM_EGENKAP) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_UDLAAN_SUM_EGENKAP = 26817;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_UDLAAN_SUM_EGENKAP = 26817;
end;

SCORECARD_POINTS = EM_SCORECARD_POINTS;
run;
