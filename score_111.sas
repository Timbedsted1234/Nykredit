data &m_output_table_nm;
set &m_scoring_abt_table_nm;

*------------------------------------------------------------*;
* DABT JUDGEMENTAL SCORE CODE;
*------------------------------------------------------------*;

EM_SCORECARD_POINTS = 0;

*------------------------------------------------------------*;
* Variable: REVISION_ANMAERK_TYPE_1;
*------------------------------------------------------------*;
if  NOT MISSING(REVISION_ANMAERK_TYPE_1) then do;
if REVISION_ANMAERK_TYPE_1 in ("REV") then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_REVISION_ANMAERK_TYPE_1 = 32508;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 57 ;
GRP_REVISION_ANMAERK_TYPE_1 = 32509;
end;
end;
else if MISSING(REVISION_ANMAERK_TYPE_1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 57 ;
GRP_REVISION_ANMAERK_TYPE_1 = 32509;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 57 ;
GRP_REVISION_ANMAERK_TYPE_1 = 32509;
end;


*------------------------------------------------------------*;
* Variable: SOLIDITETSGRAD_1;
*------------------------------------------------------------*;
if  NOT MISSING(SOLIDITETSGRAD_1) then do;
if SOLIDITETSGRAD_1 <-70 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_SOLIDITETSGRAD_1 = 32510;
end;

else if SOLIDITETSGRAD_1>=-70 and SOLIDITETSGRAD_1<-10 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 5 ;
GRP_SOLIDITETSGRAD_1 = 32511;
end;

else if SOLIDITETSGRAD_1>=-10 and SOLIDITETSGRAD_1<10 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 12 ;
GRP_SOLIDITETSGRAD_1 = 32512;
end;

else if SOLIDITETSGRAD_1>=10 and SOLIDITETSGRAD_1<15 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 19 ;
GRP_SOLIDITETSGRAD_1 = 32513;
end;

else if SOLIDITETSGRAD_1>=15 and SOLIDITETSGRAD_1<20 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 22 ;
GRP_SOLIDITETSGRAD_1 = 32514;
end;

else if SOLIDITETSGRAD_1>=20 and SOLIDITETSGRAD_1<40 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 27 ;
GRP_SOLIDITETSGRAD_1 = 32515;
end;

else if SOLIDITETSGRAD_1>=40 and SOLIDITETSGRAD_1<70 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 35 ;
GRP_SOLIDITETSGRAD_1 = 32516;
end;

else if SOLIDITETSGRAD_1 >=70 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 41 ;
GRP_SOLIDITETSGRAD_1 = 32517;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_SOLIDITETSGRAD_1 = 32510;
end;
end;
else if MISSING(SOLIDITETSGRAD_1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_SOLIDITETSGRAD_1 = 32510;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_SOLIDITETSGRAD_1 = 32510;
end;


*------------------------------------------------------------*;
* Variable: RENTEDAEKNINGSGRAD_1;
*------------------------------------------------------------*;
if  NOT MISSING(RENTEDAEKNINGSGRAD_1) then do;
if RENTEDAEKNINGSGRAD_1 <=0 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_RENTEDAEKNINGSGRAD_1 = 32531;
end;

else if RENTEDAEKNINGSGRAD_1>0 and RENTEDAEKNINGSGRAD_1<100 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 15 ;
GRP_RENTEDAEKNINGSGRAD_1 = 32532;
end;

else if RENTEDAEKNINGSGRAD_1>=100 and RENTEDAEKNINGSGRAD_1<300 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 22 ;
GRP_RENTEDAEKNINGSGRAD_1 = 32533;
end;

else if RENTEDAEKNINGSGRAD_1>=300 and RENTEDAEKNINGSGRAD_1<500 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 24 ;
GRP_RENTEDAEKNINGSGRAD_1 = 32534;
end;

else if RENTEDAEKNINGSGRAD_1>=500 and RENTEDAEKNINGSGRAD_1<1200 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 37 ;
GRP_RENTEDAEKNINGSGRAD_1 = 32535;
end;

else if RENTEDAEKNINGSGRAD_1>=1200 and RENTEDAEKNINGSGRAD_1<=2300 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 50 ;
GRP_RENTEDAEKNINGSGRAD_1 = 32536;
end;

else if RENTEDAEKNINGSGRAD_1 >2300 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 67 ;
GRP_RENTEDAEKNINGSGRAD_1 = 32537;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_RENTEDAEKNINGSGRAD_1 = 32531;
end;
end;
else if MISSING(RENTEDAEKNINGSGRAD_1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_RENTEDAEKNINGSGRAD_1 = 32531;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_RENTEDAEKNINGSGRAD_1 = 32531;
end;


*------------------------------------------------------------*;
* Variable: INDTJENINGSGRAD_1;
*------------------------------------------------------------*;
if  NOT MISSING(INDTJENINGSGRAD_1) then do;
if INDTJENINGSGRAD_1 <11 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 14 ;
GRP_INDTJENINGSGRAD_1 = 32504;
end;

else if INDTJENINGSGRAD_1>=11 and INDTJENINGSGRAD_1<27 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 64 ;
GRP_INDTJENINGSGRAD_1 = 32505;
end;

else if INDTJENINGSGRAD_1 >=27 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 39 ;
GRP_INDTJENINGSGRAD_1 = 32506;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 24 ;
GRP_INDTJENINGSGRAD_1 = 32507;
end;
end;
else if MISSING(INDTJENINGSGRAD_1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 24 ;
GRP_INDTJENINGSGRAD_1 = 32507;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 24 ;
GRP_INDTJENINGSGRAD_1 = 32507;
end;


*------------------------------------------------------------*;
* Variable: FIN_OMKOST_VS_PASSIVER_1;
*------------------------------------------------------------*;
if  NOT MISSING(FIN_OMKOST_VS_PASSIVER_1) then do;
if FIN_OMKOST_VS_PASSIVER_1 <1 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 42 ;
GRP_FIN_OMKOST_VS_PASSIVER_1 = 32518;
end;

else if FIN_OMKOST_VS_PASSIVER_1>=1 and FIN_OMKOST_VS_PASSIVER_1<2 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 33 ;
GRP_FIN_OMKOST_VS_PASSIVER_1 = 32519;
end;

else if FIN_OMKOST_VS_PASSIVER_1>=2 and FIN_OMKOST_VS_PASSIVER_1<3 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 29 ;
GRP_FIN_OMKOST_VS_PASSIVER_1 = 32520;
end;

else if FIN_OMKOST_VS_PASSIVER_1>=3 and FIN_OMKOST_VS_PASSIVER_1<4 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 22 ;
GRP_FIN_OMKOST_VS_PASSIVER_1 = 32521;
end;

else if FIN_OMKOST_VS_PASSIVER_1>=4 and FIN_OMKOST_VS_PASSIVER_1<5.5 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 17 ;
GRP_FIN_OMKOST_VS_PASSIVER_1 = 32522;
end;

else if FIN_OMKOST_VS_PASSIVER_1>=5.5 and FIN_OMKOST_VS_PASSIVER_1<6.5 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 12 ;
GRP_FIN_OMKOST_VS_PASSIVER_1 = 32523;
end;

else if FIN_OMKOST_VS_PASSIVER_1>=6.5 and FIN_OMKOST_VS_PASSIVER_1<9 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 7 ;
GRP_FIN_OMKOST_VS_PASSIVER_1 = 32524;
end;

else if FIN_OMKOST_VS_PASSIVER_1>=9 and FIN_OMKOST_VS_PASSIVER_1<57.5 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 4 ;
GRP_FIN_OMKOST_VS_PASSIVER_1 = 32525;
end;

else if FIN_OMKOST_VS_PASSIVER_1 >=57.5 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_FIN_OMKOST_VS_PASSIVER_1 = 32526;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_FIN_OMKOST_VS_PASSIVER_1 = 32526;
end;
end;
else if MISSING(FIN_OMKOST_VS_PASSIVER_1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_FIN_OMKOST_VS_PASSIVER_1 = 32526;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_FIN_OMKOST_VS_PASSIVER_1 = 32526;
end;


*------------------------------------------------------------*;
* Variable: EGENKAPITAL_IALT_1;
*------------------------------------------------------------*;
if  NOT MISSING(EGENKAPITAL_IALT_1) then do;
if EGENKAPITAL_IALT_1 <-2000 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 595 ;
GRP_EGENKAPITAL_IALT_1 = 32499;
end;

else if EGENKAPITAL_IALT_1>=-2000 and EGENKAPITAL_IALT_1<-400 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 616 ;
GRP_EGENKAPITAL_IALT_1 = 32500;
end;

else if EGENKAPITAL_IALT_1>=-400 and EGENKAPITAL_IALT_1<=0 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 630 ;
GRP_EGENKAPITAL_IALT_1 = 32501;
end;

else if EGENKAPITAL_IALT_1 >0 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 642 ;
GRP_EGENKAPITAL_IALT_1 = 32502;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 625 ;
GRP_EGENKAPITAL_IALT_1 = 32503;
end;
end;
else if MISSING(EGENKAPITAL_IALT_1) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 625 ;
GRP_EGENKAPITAL_IALT_1 = 32503;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 625 ;
GRP_EGENKAPITAL_IALT_1 = 32503;
end;


*------------------------------------------------------------*;
* Variable: GAELDSGRAD_1_DELTA;
*------------------------------------------------------------*;
if  NOT MISSING(GAELDSGRAD_1_DELTA) then do;
if GAELDSGRAD_1_DELTA <0 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 44 ;
GRP_GAELDSGRAD_1_DELTA = 32527;
end;

else if GAELDSGRAD_1_DELTA>=0 and GAELDSGRAD_1_DELTA<40 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 20 ;
GRP_GAELDSGRAD_1_DELTA = 32528;
end;

else if GAELDSGRAD_1_DELTA >=40 then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 10 ;
GRP_GAELDSGRAD_1_DELTA = 32529;
end;

else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_GAELDSGRAD_1_DELTA = 32530;
end;
end;
else if MISSING(GAELDSGRAD_1_DELTA) then do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_GAELDSGRAD_1_DELTA = 32530;
end;
else do;
EM_SCORECARD_POINTS = EM_SCORECARD_POINTS + 0 ;
GRP_GAELDSGRAD_1_DELTA = 32530;
end;

SCORECARD_POINTS = EM_SCORECARD_POINTS;
run;