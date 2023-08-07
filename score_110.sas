data &m_output_table_nm;
set &m_scoring_abt_table_nm;

*------------------------------------------------------------*;
* DABT JUDGEMENTAL SCORE CODE;
*------------------------------------------------------------*;

EM_SCORECARD_POINTS = 0;

*------------------------------------------------------------*;
* Variable: SOLIDITETSGRAD_1;
*------------------------------------------------------------*;
if  NOT MISSING(SOLIDITETSGRAD_1) then do;
if SOLIDITETSGRAD_1 <-50 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4953015 ;
GRP_SOLIDITETSGRAD_1 = 32620;
end;

else if SOLIDITETSGRAD_1>=-50 and SOLIDITETSGRAD_1<-20 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 3479832 ;
GRP_SOLIDITETSGRAD_1 = 32621;
end;

else if SOLIDITETSGRAD_1>=-20 and SOLIDITETSGRAD_1<0 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 3479832 ;
GRP_SOLIDITETSGRAD_1 = 32621;
end;

else if SOLIDITETSGRAD_1>=0 and SOLIDITETSGRAD_1<10 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 2006648 ;
GRP_SOLIDITETSGRAD_1 = 32622;
end;

else if SOLIDITETSGRAD_1>=10 and SOLIDITETSGRAD_1<20 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -939719 ;
GRP_SOLIDITETSGRAD_1 = 32623;
end;

else if SOLIDITETSGRAD_1>=20 and SOLIDITETSGRAD_1<40 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -3886086 ;
GRP_SOLIDITETSGRAD_1 = 32624;
end;

else if SOLIDITETSGRAD_1>=40 and SOLIDITETSGRAD_1<60 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -5359269 ;
GRP_SOLIDITETSGRAD_1 = 32625;
end;

else if SOLIDITETSGRAD_1 >=60 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -8305636 ;
GRP_SOLIDITETSGRAD_1 = 32626;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4953015 ;
GRP_SOLIDITETSGRAD_1 = 32620;
end;
end;
else if MISSING(SOLIDITETSGRAD_1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4953015 ;
GRP_SOLIDITETSGRAD_1 = 32620;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4953015 ;
GRP_SOLIDITETSGRAD_1 = 32620;
end;


*------------------------------------------------------------*;
* Variable: EGENKAPITAL_IALT_2;
*------------------------------------------------------------*;
if  NOT MISSING(EGENKAPITAL_IALT_2) then do;
if EGENKAPITAL_IALT_2 <0 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4635383 ;
GRP_EGENKAPITAL_IALT_2 = 32598;
end;

else if EGENKAPITAL_IALT_2>=0 and EGENKAPITAL_IALT_2<300 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -1573955 ;
GRP_EGENKAPITAL_IALT_2 = 32599;
end;

else if EGENKAPITAL_IALT_2>=300 and EGENKAPITAL_IALT_2<750 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -7783293 ;
GRP_EGENKAPITAL_IALT_2 = 32600;
end;

else if EGENKAPITAL_IALT_2>=750 and EGENKAPITAL_IALT_2<1250 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -13992632 ;
GRP_EGENKAPITAL_IALT_2 = 32601;
end;

else if EGENKAPITAL_IALT_2 >=1250 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -26411308 ;
GRP_EGENKAPITAL_IALT_2 = 32602;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4635383 ;
GRP_EGENKAPITAL_IALT_2 = 32598;
end;
end;
else if MISSING(EGENKAPITAL_IALT_2) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4635383 ;
GRP_EGENKAPITAL_IALT_2 = 32598;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4635383 ;
GRP_EGENKAPITAL_IALT_2 = 32598;
end;


*------------------------------------------------------------*;
* Variable: EGENKAPITAL_IALT_1;
*------------------------------------------------------------*;
if  NOT MISSING(EGENKAPITAL_IALT_1) then do;
if EGENKAPITAL_IALT_1 <0 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 7324826 ;
GRP_EGENKAPITAL_IALT_1 = 32593;
end;

else if EGENKAPITAL_IALT_1>=0 and EGENKAPITAL_IALT_1<300 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -424523 ;
GRP_EGENKAPITAL_IALT_1 = 32594;
end;

else if EGENKAPITAL_IALT_1>=300 and EGENKAPITAL_IALT_1<750 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -8173873 ;
GRP_EGENKAPITAL_IALT_1 = 32595;
end;

else if EGENKAPITAL_IALT_1>=750 and EGENKAPITAL_IALT_1<1250 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -15923223 ;
GRP_EGENKAPITAL_IALT_1 = 32596;
end;

else if EGENKAPITAL_IALT_1 >=1250 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -31421922 ;
GRP_EGENKAPITAL_IALT_1 = 32597;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 7324826 ;
GRP_EGENKAPITAL_IALT_1 = 32593;
end;
end;
else if MISSING(EGENKAPITAL_IALT_1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 7324826 ;
GRP_EGENKAPITAL_IALT_1 = 32593;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 7324826 ;
GRP_EGENKAPITAL_IALT_1 = 32593;
end;


*------------------------------------------------------------*;
* Variable: LIKVIDITETSGRAD1_1;
*------------------------------------------------------------*;
if  NOT MISSING(LIKVIDITETSGRAD1_1) then do;
if LIKVIDITETSGRAD1_1 <=10 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 6363308 ;
GRP_LIKVIDITETSGRAD1_1 = 32615;
end;

else if LIKVIDITETSGRAD1_1>10 and LIKVIDITETSGRAD1_1<=60 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 2658831 ;
GRP_LIKVIDITETSGRAD1_1 = 32616;
end;

else if LIKVIDITETSGRAD1_1>60 and LIKVIDITETSGRAD1_1<=120 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -1045647 ;
GRP_LIKVIDITETSGRAD1_1 = 32617;
end;

else if LIKVIDITETSGRAD1_1>120 and LIKVIDITETSGRAD1_1<=300 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -4750124 ;
GRP_LIKVIDITETSGRAD1_1 = 32618;
end;

else if LIKVIDITETSGRAD1_1 >300 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -12159078 ;
GRP_LIKVIDITETSGRAD1_1 = 32619;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 6363308 ;
GRP_LIKVIDITETSGRAD1_1 = 32615;
end;
end;
else if MISSING(LIKVIDITETSGRAD1_1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 6363308 ;
GRP_LIKVIDITETSGRAD1_1 = 32615;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 6363308 ;
GRP_LIKVIDITETSGRAD1_1 = 32615;
end;


*------------------------------------------------------------*;
* Variable: GAELDSERVICERING_1;
*------------------------------------------------------------*;
if  NOT MISSING(GAELDSERVICERING_1) then do;
if GAELDSERVICERING_1 <=0 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 8420558 ;
GRP_GAELDSERVICERING_1 = 32603;
end;

else if GAELDSERVICERING_1>0 and GAELDSERVICERING_1<=100 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -4804292 ;
GRP_GAELDSERVICERING_1 = 32604;
end;

else if GAELDSERVICERING_1>100 and GAELDSERVICERING_1<=400 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 1808133 ;
GRP_GAELDSERVICERING_1 = 32605;
end;

else if GAELDSERVICERING_1>400 and GAELDSERVICERING_1<=1000 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 5114345 ;
GRP_GAELDSERVICERING_1 = 32606;
end;

else if GAELDSERVICERING_1 >1000 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 8420558 ;
GRP_GAELDSERVICERING_1 = 32603;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 8420558 ;
GRP_GAELDSERVICERING_1 = 32603;
end;
end;
else if MISSING(GAELDSERVICERING_1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 8420558 ;
GRP_GAELDSERVICERING_1 = 32603;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 8420558 ;
GRP_GAELDSERVICERING_1 = 32603;
end;


*------------------------------------------------------------*;
* Variable: KONSOLIDERING_1;
*------------------------------------------------------------*;
if  NOT MISSING(KONSOLIDERING_1) then do;
if KONSOLIDERING_1 <0 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 9562986 ;
GRP_KONSOLIDERING_1 = 32607;
end;

else if KONSOLIDERING_1>=0 and KONSOLIDERING_1<300 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -2875825 ;
GRP_KONSOLIDERING_1 = 32608;
end;

else if KONSOLIDERING_1>=300 and KONSOLIDERING_1<1000 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -15314637 ;
GRP_KONSOLIDERING_1 = 32609;
end;

else if KONSOLIDERING_1 >=1000 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -40192259 ;
GRP_KONSOLIDERING_1 = 32610;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 9562986 ;
GRP_KONSOLIDERING_1 = 32607;
end;
end;
else if MISSING(KONSOLIDERING_1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 9562986 ;
GRP_KONSOLIDERING_1 = 32607;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 9562986 ;
GRP_KONSOLIDERING_1 = 32607;
end;


*------------------------------------------------------------*;
* Variable: KONSOLIDERING_2;
*------------------------------------------------------------*;
if  NOT MISSING(KONSOLIDERING_2) then do;
if KONSOLIDERING_2 <0 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 8209045 ;
GRP_KONSOLIDERING_2 = 32611;
end;

else if KONSOLIDERING_2>=0 and KONSOLIDERING_2<300 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -4773541 ;
GRP_KONSOLIDERING_2 = 32612;
end;

else if KONSOLIDERING_2>=300 and KONSOLIDERING_2<1000 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -17756128 ;
GRP_KONSOLIDERING_2 = 32613;
end;

else if KONSOLIDERING_2 >=1000 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -43721300 ;
GRP_KONSOLIDERING_2 = 32614;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 8209045 ;
GRP_KONSOLIDERING_2 = 32611;
end;
end;
else if MISSING(KONSOLIDERING_2) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 8209045 ;
GRP_KONSOLIDERING_2 = 32611;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 8209045 ;
GRP_KONSOLIDERING_2 = 32611;
end;


*------------------------------------------------------------*;
* Variable: LIKVID_GRAD_1_DELTA;
*------------------------------------------------------------*;
if  NOT MISSING(LIKVID_GRAD_1_DELTA) then do;
if LIKVID_GRAD_1_DELTA <=-50 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4859284 ;
GRP_LIKVID_GRAD_1_DELTA = 32633;
end;

else if LIKVID_GRAD_1_DELTA>-50 and LIKVID_GRAD_1_DELTA<=-20 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 1727358 ;
GRP_LIKVID_GRAD_1_DELTA = 32634;
end;

else if LIKVID_GRAD_1_DELTA>-20 and LIKVID_GRAD_1_DELTA<=0 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -1404569 ;
GRP_LIKVID_GRAD_1_DELTA = 32635;
end;

else if LIKVID_GRAD_1_DELTA>0 and LIKVID_GRAD_1_DELTA<=40 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -4536495 ;
GRP_LIKVID_GRAD_1_DELTA = 32636;
end;

else if LIKVID_GRAD_1_DELTA >40 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -7668421 ;
GRP_LIKVID_GRAD_1_DELTA = 32637;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4859284 ;
GRP_LIKVID_GRAD_1_DELTA = 32633;
end;
end;
else if MISSING(LIKVID_GRAD_1_DELTA) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4859284 ;
GRP_LIKVID_GRAD_1_DELTA = 32633;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4859284 ;
GRP_LIKVID_GRAD_1_DELTA = 32633;
end;


*------------------------------------------------------------*;
* Variable: ALDER_OFF_DATO1;
*------------------------------------------------------------*;
if  NOT MISSING(ALDER_OFF_DATO1) then do;
if ALDER_OFF_DATO1 <=8 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -1940972 ;
GRP_ALDER_OFF_DATO1 = 32590;
end;

else if ALDER_OFF_DATO1>8 and ALDER_OFF_DATO1<=10 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 2414084 ;
GRP_ALDER_OFF_DATO1 = 32591;
end;

else if ALDER_OFF_DATO1 >10 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4591611 ;
GRP_ALDER_OFF_DATO1 = 32592;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4591611 ;
GRP_ALDER_OFF_DATO1 = 32592;
end;
end;
else if MISSING(ALDER_OFF_DATO1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4591611 ;
GRP_ALDER_OFF_DATO1 = 32592;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4591611 ;
GRP_ALDER_OFF_DATO1 = 32592;
end;


*------------------------------------------------------------*;
* Variable: KAPACITETSGRAD_1;
*------------------------------------------------------------*;
if  NOT MISSING(KAPACITETSGRAD_1) then do;
if KAPACITETSGRAD_1 <50 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 15047249 ;
GRP_KAPACITETSGRAD_1 = 32627;
end;

else if KAPACITETSGRAD_1>=50 and KAPACITETSGRAD_1<95 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 9787305 ;
GRP_KAPACITETSGRAD_1 = 32628;
end;

else if KAPACITETSGRAD_1>=95 and KAPACITETSGRAD_1<105 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4527361 ;
GRP_KAPACITETSGRAD_1 = 32629;
end;

else if KAPACITETSGRAD_1>=105 and KAPACITETSGRAD_1<120 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -732583 ;
GRP_KAPACITETSGRAD_1 = 32630;
end;

else if KAPACITETSGRAD_1>=120 and KAPACITETSGRAD_1<140 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -5992526 ;
GRP_KAPACITETSGRAD_1 = 32631;
end;

else if KAPACITETSGRAD_1>=140 and KAPACITETSGRAD_1<200 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -5992526 ;
GRP_KAPACITETSGRAD_1 = 32631;
end;

else if KAPACITETSGRAD_1 >=200 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -21772358 ;
GRP_KAPACITETSGRAD_1 = 32632;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 15047249 ;
GRP_KAPACITETSGRAD_1 = 32627;
end;
end;
else if MISSING(KAPACITETSGRAD_1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 15047249 ;
GRP_KAPACITETSGRAD_1 = 32627;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 15047249 ;
GRP_KAPACITETSGRAD_1 = 32627;
end;

SCORECARD_POINTS = EM_SCORECARD_POINTS;
run;
