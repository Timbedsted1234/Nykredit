data &m_output_table_nm;
set &m_scoring_abt_table_nm;

*------------------------------------------------------------*;
* DABT JUDGEMENTAL SCORE CODE;
*------------------------------------------------------------*;

EM_SCORECARD_POINTS = 0;

*------------------------------------------------------------*;
* Variable: EGENKAPITAL_IALT_2;
*------------------------------------------------------------*;
if  NOT MISSING(EGENKAPITAL_IALT_2) then do;
if EGENKAPITAL_IALT_2 <0 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 10150010 ;
GRP_EGENKAPITAL_IALT_2 = 27858;
end;

else if EGENKAPITAL_IALT_2>=0 and EGENKAPITAL_IALT_2<500 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4918046 ;
GRP_EGENKAPITAL_IALT_2 = 27859;
end;

else if EGENKAPITAL_IALT_2>=500 and EGENKAPITAL_IALT_2<1000 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -313918 ;
GRP_EGENKAPITAL_IALT_2 = 27860;
end;

else if EGENKAPITAL_IALT_2>=1000 and EGENKAPITAL_IALT_2<5000 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -5545882 ;
GRP_EGENKAPITAL_IALT_2 = 27861;
end;

else if EGENKAPITAL_IALT_2 >=5000 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -10777845 ;
GRP_EGENKAPITAL_IALT_2 = 27862;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 10150010 ;
GRP_EGENKAPITAL_IALT_2 = 27858;
end;
end;
else if MISSING(EGENKAPITAL_IALT_2) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 10150010 ;
GRP_EGENKAPITAL_IALT_2 = 27858;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 10150010 ;
GRP_EGENKAPITAL_IALT_2 = 27858;
end;


*------------------------------------------------------------*;
* Variable: EGENKAPITAL_IALT_1;
*------------------------------------------------------------*;
if  NOT MISSING(EGENKAPITAL_IALT_1) then do;
if EGENKAPITAL_IALT_1 <0 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 10019368 ;
GRP_EGENKAPITAL_IALT_1 = 27851;
end;

else if EGENKAPITAL_IALT_1>=0 and EGENKAPITAL_IALT_1<500 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 6630126 ;
GRP_EGENKAPITAL_IALT_1 = 27852;
end;

else if EGENKAPITAL_IALT_1>=500 and EGENKAPITAL_IALT_1<1000 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 3240883 ;
GRP_EGENKAPITAL_IALT_1 = 27853;
end;

else if EGENKAPITAL_IALT_1>=1000 and EGENKAPITAL_IALT_1<2500 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -148359 ;
GRP_EGENKAPITAL_IALT_1 = 27854;
end;

else if EGENKAPITAL_IALT_1>=2500 and EGENKAPITAL_IALT_1<5000 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -3537602 ;
GRP_EGENKAPITAL_IALT_1 = 27855;
end;

else if EGENKAPITAL_IALT_1>=5000 and EGENKAPITAL_IALT_1<10000 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -10316087 ;
GRP_EGENKAPITAL_IALT_1 = 27856;
end;

else if EGENKAPITAL_IALT_1 >=10000 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -20483814 ;
GRP_EGENKAPITAL_IALT_1 = 27857;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 10019368 ;
GRP_EGENKAPITAL_IALT_1 = 27851;
end;
end;
else if MISSING(EGENKAPITAL_IALT_1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 10019368 ;
GRP_EGENKAPITAL_IALT_1 = 27851;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 10019368 ;
GRP_EGENKAPITAL_IALT_1 = 27851;
end;


*------------------------------------------------------------*;
* Variable: RESULTAT_EFTERSKAT_1;
*------------------------------------------------------------*;
if  NOT MISSING(RESULTAT_EFTERSKAT_1) then do;
if RESULTAT_EFTERSKAT_1 <-300 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 11561317 ;
GRP_RESULTAT_EFTERSKAT_1 = 27878;
end;

else if RESULTAT_EFTERSKAT_1>=-300 and RESULTAT_EFTERSKAT_1<50 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 7381578 ;
GRP_RESULTAT_EFTERSKAT_1 = 27879;
end;

else if RESULTAT_EFTERSKAT_1>=50 and RESULTAT_EFTERSKAT_1<150 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 3201838 ;
GRP_RESULTAT_EFTERSKAT_1 = 27880;
end;

else if RESULTAT_EFTERSKAT_1>=150 and RESULTAT_EFTERSKAT_1<300 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -977901 ;
GRP_RESULTAT_EFTERSKAT_1 = 27881;
end;

else if RESULTAT_EFTERSKAT_1>=300 and RESULTAT_EFTERSKAT_1<500 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -5157641 ;
GRP_RESULTAT_EFTERSKAT_1 = 27882;
end;

else if RESULTAT_EFTERSKAT_1>=500 and RESULTAT_EFTERSKAT_1<1000 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -9337380 ;
GRP_RESULTAT_EFTERSKAT_1 = 27883;
end;

else if RESULTAT_EFTERSKAT_1 >=1000 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -17696860 ;
GRP_RESULTAT_EFTERSKAT_1 = 27884;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 11561317 ;
GRP_RESULTAT_EFTERSKAT_1 = 27878;
end;
end;
else if MISSING(RESULTAT_EFTERSKAT_1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 11561317 ;
GRP_RESULTAT_EFTERSKAT_1 = 27878;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 11561317 ;
GRP_RESULTAT_EFTERSKAT_1 = 27878;
end;


*------------------------------------------------------------*;
* Variable: RESULTAT_EFTERSKAT_2;
*------------------------------------------------------------*;
if  NOT MISSING(RESULTAT_EFTERSKAT_2) then do;
if RESULTAT_EFTERSKAT_2 <-300 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 11746599 ;
GRP_RESULTAT_EFTERSKAT_2 = 27885;
end;

else if RESULTAT_EFTERSKAT_2>=-300 and RESULTAT_EFTERSKAT_2<50 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4345628 ;
GRP_RESULTAT_EFTERSKAT_2 = 27886;
end;

else if RESULTAT_EFTERSKAT_2>=50 and RESULTAT_EFTERSKAT_2<500 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -3055345 ;
GRP_RESULTAT_EFTERSKAT_2 = 27887;
end;

else if RESULTAT_EFTERSKAT_2 >=500 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -10456316 ;
GRP_RESULTAT_EFTERSKAT_2 = 27888;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 11746599 ;
GRP_RESULTAT_EFTERSKAT_2 = 27885;
end;
end;
else if MISSING(RESULTAT_EFTERSKAT_2) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 11746599 ;
GRP_RESULTAT_EFTERSKAT_2 = 27885;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 11746599 ;
GRP_RESULTAT_EFTERSKAT_2 = 27885;
end;


*------------------------------------------------------------*;
* Variable: REVISION_ANMAERK_TYPE_TXT_1;
*------------------------------------------------------------*;
if  NOT MISSING(REVISION_ANMAERK_TYPE_TXT_1) then do;
if REVISION_ANMAERK_TYPE_TXT_1 in ("REV") then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 12772965 ;
GRP_REVISION_ANMAERK_TYPE_TXT_1 = 27889;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -1956521 ;
GRP_REVISION_ANMAERK_TYPE_TXT_1 = 27890;
end;
end;
else if MISSING(REVISION_ANMAERK_TYPE_TXT_1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -1956521 ;
GRP_REVISION_ANMAERK_TYPE_TXT_1 = 27890;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -1956521 ;
GRP_REVISION_ANMAERK_TYPE_TXT_1 = 27890;
end;


*------------------------------------------------------------*;
* Variable: LIKVIDITETSGRAD1_1;
*------------------------------------------------------------*;
if  NOT MISSING(LIKVIDITETSGRAD1_1) then do;
if LIKVIDITETSGRAD1_1 <=10 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 6730931 ;
GRP_LIKVIDITETSGRAD1_1 = 27867;
end;

else if LIKVIDITETSGRAD1_1>10 and LIKVIDITETSGRAD1_1<=60 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 5094812 ;
GRP_LIKVIDITETSGRAD1_1 = 27868;
end;

else if LIKVIDITETSGRAD1_1>60 and LIKVIDITETSGRAD1_1<=85 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 3458693 ;
GRP_LIKVIDITETSGRAD1_1 = 27869;
end;

else if LIKVIDITETSGRAD1_1>85 and LIKVIDITETSGRAD1_1<=105 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 1822575 ;
GRP_LIKVIDITETSGRAD1_1 = 27870;
end;

else if LIKVIDITETSGRAD1_1>105 and LIKVIDITETSGRAD1_1<=120 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 186456 ;
GRP_LIKVIDITETSGRAD1_1 = 27871;
end;

else if LIKVIDITETSGRAD1_1>120 and LIKVIDITETSGRAD1_1<=180 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -3085782 ;
GRP_LIKVIDITETSGRAD1_1 = 27872;
end;

else if LIKVIDITETSGRAD1_1>180 and LIKVIDITETSGRAD1_1<=300 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -4721900 ;
GRP_LIKVIDITETSGRAD1_1 = 27873;
end;

else if LIKVIDITETSGRAD1_1 >300 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -7994138 ;
GRP_LIKVIDITETSGRAD1_1 = 27874;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 6730931 ;
GRP_LIKVIDITETSGRAD1_1 = 27867;
end;
end;
else if MISSING(LIKVIDITETSGRAD1_1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 6730931 ;
GRP_LIKVIDITETSGRAD1_1 = 27867;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 6730931 ;
GRP_LIKVIDITETSGRAD1_1 = 27867;
end;


*------------------------------------------------------------*;
* Variable: OVERSKUDSGRAD_1;
*------------------------------------------------------------*;
if  NOT MISSING(OVERSKUDSGRAD_1) then do;
if OVERSKUDSGRAD_1 <2.5 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4337180 ;
GRP_OVERSKUDSGRAD_1 = 27875;
end;

else if OVERSKUDSGRAD_1>=2.5 and OVERSKUDSGRAD_1<10 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -6073623 ;
GRP_OVERSKUDSGRAD_1 = 27876;
end;

else if OVERSKUDSGRAD_1 >=10 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -26895228 ;
GRP_OVERSKUDSGRAD_1 = 27877;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4337180 ;
GRP_OVERSKUDSGRAD_1 = 27875;
end;
end;
else if MISSING(OVERSKUDSGRAD_1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4337180 ;
GRP_OVERSKUDSGRAD_1 = 27875;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4337180 ;
GRP_OVERSKUDSGRAD_1 = 27875;
end;


*------------------------------------------------------------*;
* Variable: KORTGAELDSSEVICERING_1;
*------------------------------------------------------------*;
if  NOT MISSING(KORTGAELDSSEVICERING_1) then do;
if KORTGAELDSSEVICERING_1 <=0 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 7105313 ;
GRP_KORTGAELDSSEVICERING_1 = 27863;
end;

else if KORTGAELDSSEVICERING_1>0 and KORTGAELDSSEVICERING_1<=200 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -20655954 ;
GRP_KORTGAELDSSEVICERING_1 = 27864;
end;

else if KORTGAELDSSEVICERING_1>200 and KORTGAELDSSEVICERING_1<=400 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -6775320 ;
GRP_KORTGAELDSSEVICERING_1 = 27865;
end;

else if KORTGAELDSSEVICERING_1>400 and KORTGAELDSSEVICERING_1<=800 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 164996 ;
GRP_KORTGAELDSSEVICERING_1 = 27866;
end;

else if KORTGAELDSSEVICERING_1 >800 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 7105313 ;
GRP_KORTGAELDSSEVICERING_1 = 27863;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 7105313 ;
GRP_KORTGAELDSSEVICERING_1 = 27863;
end;
end;
else if MISSING(KORTGAELDSSEVICERING_1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 7105313 ;
GRP_KORTGAELDSSEVICERING_1 = 27863;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 7105313 ;
GRP_KORTGAELDSSEVICERING_1 = 27863;
end;


*------------------------------------------------------------*;
* Variable: KAPACITETSGRAD_1;
*------------------------------------------------------------*;
if  NOT MISSING(KAPACITETSGRAD_1) then do;
if KAPACITETSGRAD_1 <50 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 5231596 ;
GRP_KAPACITETSGRAD_1 = 27899;
end;

else if KAPACITETSGRAD_1>=50 and KAPACITETSGRAD_1<95 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 2860106 ;
GRP_KAPACITETSGRAD_1 = 27900;
end;

else if KAPACITETSGRAD_1>=95 and KAPACITETSGRAD_1<105 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 488617 ;
GRP_KAPACITETSGRAD_1 = 27901;
end;

else if KAPACITETSGRAD_1>=105 and KAPACITETSGRAD_1<120 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -1882874 ;
GRP_KAPACITETSGRAD_1 = 27902;
end;

else if KAPACITETSGRAD_1>=120 and KAPACITETSGRAD_1<140 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -4254363 ;
GRP_KAPACITETSGRAD_1 = 27903;
end;

else if KAPACITETSGRAD_1>=140 and KAPACITETSGRAD_1<200 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -4254363 ;
GRP_KAPACITETSGRAD_1 = 27903;
end;

else if KAPACITETSGRAD_1 >=200 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -11368832 ;
GRP_KAPACITETSGRAD_1 = 27904;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 5231596 ;
GRP_KAPACITETSGRAD_1 = 27899;
end;
end;
else if MISSING(KAPACITETSGRAD_1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 5231596 ;
GRP_KAPACITETSGRAD_1 = 27899;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 5231596 ;
GRP_KAPACITETSGRAD_1 = 27899;
end;


*------------------------------------------------------------*;
* Variable: ALDER_OFF_DATO1;
*------------------------------------------------------------*;
if  NOT MISSING(ALDER_OFF_DATO1) then do;
if ALDER_OFF_DATO1 in (1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4899380 ;
GRP_ALDER_OFF_DATO1 = 27848;
end;

else if ALDER_OFF_DATO1 in (2) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 2512733 ;
GRP_ALDER_OFF_DATO1 = 27849;
end;

else if ALDER_OFF_DATO1 in (3) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -2260560 ;
GRP_ALDER_OFF_DATO1 = 27850;
end;

else if ALDER_OFF_DATO1 in (4) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 2512733 ;
GRP_ALDER_OFF_DATO1 = 27849;
end;

else if ALDER_OFF_DATO1 in (5) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -2260560 ;
GRP_ALDER_OFF_DATO1 = 27850;
end;

else if ALDER_OFF_DATO1 in (6) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4899380 ;
GRP_ALDER_OFF_DATO1 = 27848;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4899380 ;
GRP_ALDER_OFF_DATO1 = 27848;
end;
end;
else if MISSING(ALDER_OFF_DATO1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4899380 ;
GRP_ALDER_OFF_DATO1 = 27848;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4899380 ;
GRP_ALDER_OFF_DATO1 = 27848;
end;


*------------------------------------------------------------*;
* Variable: RESULTAT_FOER_RENTER;
*------------------------------------------------------------*;
if  NOT MISSING(RESULTAT_FOER_RENTER) then do;
if RESULTAT_FOER_RENTER in (1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 8790565 ;
GRP_RESULTAT_FOER_RENTER = 27909;
end;

else if RESULTAT_FOER_RENTER in (2) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 2399620 ;
GRP_RESULTAT_FOER_RENTER = 27910;
end;

else if RESULTAT_FOER_RENTER in (3) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -3991327 ;
GRP_RESULTAT_FOER_RENTER = 27911;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -3991327 ;
GRP_RESULTAT_FOER_RENTER = 27911;
end;
end;
else if MISSING(RESULTAT_FOER_RENTER) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -3991327 ;
GRP_RESULTAT_FOER_RENTER = 27911;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -3991327 ;
GRP_RESULTAT_FOER_RENTER = 27911;
end;


*------------------------------------------------------------*;
* Variable: EGENKAPITAL_OG_SOLIDITET;
*------------------------------------------------------------*;
if  NOT MISSING(EGENKAPITAL_OG_SOLIDITET) then do;
if EGENKAPITAL_OG_SOLIDITET in (1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 9430403 ;
GRP_EGENKAPITAL_OG_SOLIDITET = 27891;
end;

else if EGENKAPITAL_OG_SOLIDITET in (2) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 7372889 ;
GRP_EGENKAPITAL_OG_SOLIDITET = 27892;
end;

else if EGENKAPITAL_OG_SOLIDITET in (3) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 5315375 ;
GRP_EGENKAPITAL_OG_SOLIDITET = 27893;
end;

else if EGENKAPITAL_OG_SOLIDITET in (4) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 1200346 ;
GRP_EGENKAPITAL_OG_SOLIDITET = 27894;
end;

else if EGENKAPITAL_OG_SOLIDITET in (5) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -2914682 ;
GRP_EGENKAPITAL_OG_SOLIDITET = 27895;
end;

else if EGENKAPITAL_OG_SOLIDITET in (6) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -7029710 ;
GRP_EGENKAPITAL_OG_SOLIDITET = 27896;
end;

else if EGENKAPITAL_OG_SOLIDITET in (7) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -9087224 ;
GRP_EGENKAPITAL_OG_SOLIDITET = 27897;
end;

else if EGENKAPITAL_OG_SOLIDITET in (8) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 9430403 ;
GRP_EGENKAPITAL_OG_SOLIDITET = 27891;
end;

else if EGENKAPITAL_OG_SOLIDITET in (9) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 7372889 ;
GRP_EGENKAPITAL_OG_SOLIDITET = 27892;
end;

else if EGENKAPITAL_OG_SOLIDITET in (10) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 5315375 ;
GRP_EGENKAPITAL_OG_SOLIDITET = 27893;
end;

else if EGENKAPITAL_OG_SOLIDITET in (11) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 1200346 ;
GRP_EGENKAPITAL_OG_SOLIDITET = 27894;
end;

else if EGENKAPITAL_OG_SOLIDITET in (12) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -2914682 ;
GRP_EGENKAPITAL_OG_SOLIDITET = 27895;
end;

else if EGENKAPITAL_OG_SOLIDITET in (13) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -7029710 ;
GRP_EGENKAPITAL_OG_SOLIDITET = 27896;
end;

else if EGENKAPITAL_OG_SOLIDITET in (14) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -9087224 ;
GRP_EGENKAPITAL_OG_SOLIDITET = 27897;
end;

else if EGENKAPITAL_OG_SOLIDITET in (15) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 9430403 ;
GRP_EGENKAPITAL_OG_SOLIDITET = 27891;
end;

else if EGENKAPITAL_OG_SOLIDITET in (16) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 7372889 ;
GRP_EGENKAPITAL_OG_SOLIDITET = 27892;
end;

else if EGENKAPITAL_OG_SOLIDITET in (17) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 3257860 ;
GRP_EGENKAPITAL_OG_SOLIDITET = 27898;
end;

else if EGENKAPITAL_OG_SOLIDITET in (18) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -7029710 ;
GRP_EGENKAPITAL_OG_SOLIDITET = 27896;
end;

else if EGENKAPITAL_OG_SOLIDITET in (19) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 9430403 ;
GRP_EGENKAPITAL_OG_SOLIDITET = 27891;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 9430403 ;
GRP_EGENKAPITAL_OG_SOLIDITET = 27891;
end;
end;
else if MISSING(EGENKAPITAL_OG_SOLIDITET) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 9430403 ;
GRP_EGENKAPITAL_OG_SOLIDITET = 27891;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 9430403 ;
GRP_EGENKAPITAL_OG_SOLIDITET = 27891;
end;


*------------------------------------------------------------*;
* Variable: LIKVID_GRAD_1_DELTA;
*------------------------------------------------------------*;
if  NOT MISSING(LIKVID_GRAD_1_DELTA) then do;
if LIKVID_GRAD_1_DELTA <=-25 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 6072173 ;
GRP_LIKVID_GRAD_1_DELTA = 27905;
end;

else if LIKVID_GRAD_1_DELTA>-25 and LIKVID_GRAD_1_DELTA<=-5 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 2171262 ;
GRP_LIKVID_GRAD_1_DELTA = 27906;
end;

else if LIKVID_GRAD_1_DELTA>-5 and LIKVID_GRAD_1_DELTA<=5 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -1729650 ;
GRP_LIKVID_GRAD_1_DELTA = 27907;
end;

else if LIKVID_GRAD_1_DELTA>5 and LIKVID_GRAD_1_DELTA<=20 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -5630561 ;
GRP_LIKVID_GRAD_1_DELTA = 27908;
end;

else if LIKVID_GRAD_1_DELTA >20 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + -5630561 ;
GRP_LIKVID_GRAD_1_DELTA = 27908;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 6072173 ;
GRP_LIKVID_GRAD_1_DELTA = 27905;
end;
end;
else if MISSING(LIKVID_GRAD_1_DELTA) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 6072173 ;
GRP_LIKVID_GRAD_1_DELTA = 27905;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 6072173 ;
GRP_LIKVID_GRAD_1_DELTA = 27905;
end;

SCORECARD_POINTS = EM_SCORECARD_POINTS;
run;