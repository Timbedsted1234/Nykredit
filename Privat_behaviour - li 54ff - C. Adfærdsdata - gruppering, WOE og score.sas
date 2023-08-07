*********
*********
* Input *
*********
*********;



*'tid-med-risikoprodukt-md'n=-1 sendes ikke fra DWH til Mainframe *;

proc sort data=dm126dp.stg_pd_priv_behav_f_dataset out=adf1;
where day_eom>=&start_dato_ymd. and day_eom<=&slut_dato_ymd. and 'tid-med-risikoprodukt-md'n ne -1;
by 'fk-kontakt-id'n;
run;


data adf1 (drop='ejendomvaerdi-inf'n);
set adf1;

ejendomvaerdi_inf_old='ejendomvaerdi-inf'n;
run;

data adf1 (drop=ejendomvaerdi_inf_old);
set adf1;

* Der sættes loft på værdier inden afsendelse til Mainframe *;
'gaeldsfaktor-proxy'n=min('gaeldsfaktor-proxy'n,99999.99);
'likv-midl-udv7'n=min('likv-midl-udv7'n,99999.99);

*day_eom_date = input(put(day_eom,8.), yymmdd8.);
*format day_eom_date yymmdd10.;

* Landsdele omdøbes på mainframe *;
* æ, ø og å er på Mainframen lavet til ae, oe og aa, da Hugin ikke kan klare æ, ø og å. *;
* Teksten bliver også forkortet på mainframen, da teksten ikke må være længere end 20 i Hugin *;

if landsdel='Byen København' then landsdel='Byen Koebenhavn';
else if landsdel='Københavns omegn' then landsdel='Koebenhavnsomegn';
else if landsdel='Nordsjælland' then landsdel='Nordsjaelland';
else if landsdel='Østjylland' then landsdel='Oestjylland';
else if landsdel='Østsjælland' then landsdel='Oestsjaelland';
else if landsdel='Vest- og Sydsjælland' then landsdel='Vest-og Sydsjaelland';


if ejendomvaerdi_inf_old=-1 then do;
	if ltv=-1 then 'ejendomvaerdi-inf'n=-1;
	else 'ejendomvaerdi-inf'n=-2;
end;
else 'ejendomvaerdi-inf'n=ejendomvaerdi_inf_old;
run;



****************************
****************************
* Krydsvariable og grupper *
****************************
****************************;

* Formater *;
* Gruppenumre til tekst *;

proc format;


******************************************************
* Antal dage i overtræk/restance 3000 kr, 12 måneder *
******************************************************;

value AntOvertrkRest_3000_sum12_h
.,low-<0 = 1
0-<3     = 2
3-<5     = 3
5-<9     = 4
9-<16    = 5
16-<32   = 6
32-<66   = 7
66-<100  = 8
100-<150 = 9
150-high = 10
; 

value AntOvertrkRest_3000_sum12_h_txt
1="Mangler eller negativ"
2="Under 3"
3="[3;5)"
4="[5;9)"
5="[9;16)"
6="[16;32)"
7="[32;66)"
8="[66;100)"
9="[100;150)"
10="Over 150"
;

value AntOvertrkRest_3000_sum12_h_woe
1=-4.020
2=0.395
3=-0.018
4=-0.379
5=-0.699
6=-1.212
7=-2.115
8=-2.562
9=-3.269
10=-4.020
;


****************************************************
* Antal dage i overtræk/restance 750 kr, 3 måneder *
****************************************************;

value AntOvertrkRest_750_sum3_h
.,low-<0 = 1
0-<3     = 2
3-<6     = 3
6-<9     = 4
9-<16    = 5
16-<28   = 6
28-high =  7
;

value AntOvertrkRest_750_sum3_h_txt
1="Mangler eller negativ"
2="Under 3"
3="[3 ; 6)"
4="[6 ; 9)"
5="[9 ; 16)"
6="[16 ; 28)"
7="Over 28"
;

value AntOvertrkRest_750_sum3_h_woe
1=-2.627
2=0.509
3=-0.376
4=-0.737
5=-0.985
6=-1.398
7=-2.627
;



**************************************************
* Alder krydset med Gennemsnitlig likvide midler *
**************************************************;

* Alder *;

value alder
.,low-<0 = 1
0-<29    = 2
29-<55    = 3
55-high  = 4
;

/*
value alder_txt
1="Mangler eller negativ"
2="Under 29"
3="[29;55)"
4="Over 55"
;
*/
value alder_txt
1="-inf-0"
2="0-29"
3="29-55"
4="55-inf"
;


* Gennemsnitlig likvide midler gruppering 1 *;

value likv_midl_gns3n_a
.,low-<0            = 1
0-<1298.97          = 2
1298.97-<28650.52   = 3
28650.52-high        = 4
;

value likv_midl_gns3_a_txt
1="-inf-0"
2="0-1299"
3="1299-28651"
4="28651-inf"
;

* Gennemsnitlig likvide midler gruppering 2 *;

value likv_midl_gns3n_b
.,low-<0            = 1
0-<1298.97          = 2
1298.97-<28650.52   = 3
28650.52-<46874.58  = 4
46874.58-<82506.34  = 5
82506.34-<142177.10 = 6
142177.10-high      = 7
;

value likv_midl_gns3_b_txt
1="-inf-0"
2="0-1299"
3="1299-28651"
4="28651-46875"
5="46875-82506"
6="82506-142177"
7="142177-inf"
;



* WOE for krydset variabel *;
value $alder_likvmidl_woe
"1_1"=-0.562
"1_2"=-1.817
"1_3"=-0.836
"1_4"=0.284
"1_5"=0.688
"1_6"=1.640
"1_7"=2.093
"2_1"=-0.562
"2_2"=-1.026
"2_3"=0.050
"2_4"=2.093
"3_1"=-0.145
"3_2"=-1.817
"3_3"=-0.836
"3_4"=0.284
"3_5"=1.049
"3_6"=2.096
"3_7"=2.561
"4_1"=0.186
"4_2"=-1.560
"4_3"=-0.566
"4_4"=0.649
"4_5"=0.688
"4_6"=1.640
"4_7"=2.708
;




************************
* Samlet ejendomsværdi *
************************;

value ejdvaerdi_samlet_inf
.,low-<-1        = 1
-1-<0         	 = 2
0-<477758        = 3
477758-<579383   = 4
579383-<719169   = 5
719169-<828069   = 6
828069-<1200721  = 7
1200721-<1469180 = 8
1469180-<1944650 = 9
1944650-<2147796 = 10
2147796-high     = 11
;

value ejdvaerdi_samlet_inf_txt
1="Anden årsag end ejendomsværdi mangler"
2="Ejendomsværdien mangler "
3="Under 477.758,01"
4="[477.758,01 ; 579.383,28)"
5="[579.383,28 ; 719.168,53)"
6="[719.168,53 ; 828.069,34)"
7="[828.069,34 ; 1.200.720,70)"
8="[1.200.720,70 ; 1.469.179,69)"
9="[1.469.179,69 ; 1.944.649,83)"
10="[1.944.649,83 ; 2.147.795,90)"
11="Over 2.147.795,90"
;

value ejdvaerdi_samlet_inf_woe
1=-0.330
2=-1.186
3=-1.186
4=-1.053
5=-0.716
6=-0.502
7=-0.147
8=0.206
9=0.367
10=0.575
11=0.732
;



*******
* LTV *
*******;

value ltv
-3=1
-2=2
-1=3
0-<0.24=4
0.24-<0.43=5
0.43-<0.66=6
0.66-<0.81=7
0.81-<0.99=8
0.99-<1.06=9
1.06-high=10
other=1 /*Negative. findes ikke i data fra DWH */
;

value ltv_txt
1="Ingen boliglån"
2="Andelsbolig"
3="Ejendomsværdi mangler"
4="[0 ; 0,24)"
5="[0,24 ; 0,43)"
6="[0,43 ; 0,66)"
7="[0,66 ; 0,81)"
8="[0,81 ; 0,99)"
9="[0,99 ; 1,06)"
10="Over 1,06"
;

value ltv_woe
1=-0.373
2=0.806
3=-0.989
4=1.068
5=0.780
6=0.471
7=0.223
8=-0.230
9=-0.508
10=-0.989
;


****************************************************************************************
* Samlet udlån / kreditomsætning over 12 mdr. (Gældsfaktor proxy) x landsdel og "helkunde / ikke-helkunde" *
****************************************************************************************;


* Landsdel *;
value $landsdel
'Byen Koebenhavn','Koebenhavnsomegn','Nordsjaelland'=1
.,'Ukendt'=2
'Bornholm','Fyn','Nordjylland','Sydjylland','Vest-og Sydsjaelland','Vestjylland','Oestjylland','Oestsjaelland'=3
;

value landsdel_txt
1='KBH NOR'
2='Ukendt'
3='ANDET'
;

* Gældsfaktor_proxy *;

value Gaeldsfaktor_proxy
-1=1
.,low-<-1,-1<-<0   = 2
0-<0.01    = 3
0.01-<0.34 = 4
0.34-<0.83 = 5
0.83-<2.04 = 6
2.04-<2.59 = 7
2.59-<4.21 = 8
4.21-<4.99 = 9
4.99-<7.01 = 10
7.01-high  = 11
;

value Gaeldsfaktor_proxy_txt
1="Mangler Samlet udlån"
2="Ingen værdi"
3="Under 0,01"
4="[0,01 ; 0,34)"
5="[0,34 ; 0,83)"
6="[0,83 ; 2,04)"
7="[2,04 ; 2,59)"
8="[2,59 ; 4,21)"
9="[4,21 ; 4,99)"
10="[4,99 ; 7,01)"
11="Over 7,01"
;


* WOE for den sammensatte variabel: Helkunde, landsdel, Gældsfaktor_proxy*;
value $helkunde_landsdel_gf_woe
'J_1_01'=-0.674
'J_1_02'=-0.330
'J_1_03'=1.618
'J_1_04'=-0.279
'J_1_05'=0.541
'J_1_06'=1.153
'J_1_07'=1.002
'J_1_08'=1.088
'J_1_09'=0.961
'J_1_10'=0.466
'J_1_11'=-0.330
'J_2_01'=-0.674
'J_2_02'=-0.216
'J_2_03'=1.204
'J_2_04'=-0.611
'J_2_05'=-0.067
'J_2_06'=0.432
'J_2_07'=0.275
'J_2_08'=0.066
'J_2_09'=-0.145
'J_2_10'=-0.388
'J_2_11'=-0.674
'J_3_01'=-0.674
'J_3_02'=-0.216
'J_3_03'=1.204
'J_3_04'=-0.611
'J_3_05'=-0.067
'J_3_06'=0.432
'J_3_07'=0.275
'J_3_08'=0.066
'J_3_09'=-0.145
'J_3_10'=-0.388
'J_3_11'=-0.674
'N_0_00'=-0.280
'M_0_00'=-0.674
;


**************************************
* Likvide midler udvikling 6 måneder *
**************************************;

value likv_midl_udv7n
.,low-<-1   = 1
-1-<-0.95 = 2
-0.95-<-0.63 =3 
-0.63-<-0.30 = 4
-0.30-<-0.14 = 5
-0.14-<-0.01 = 6
-0.01-<0.16 = 7
0.16-<0.30 = 8
0.30-<0.64 = 9
0.64-<2.54 = 10
2.54-high = 11
;

value likv_midl_udv7_txt
1="Mangler"
2="Under -0,95"
3="[-0,95 ; -0,63)"
4="[-0,63 ; -0,30)"
5="[-0,30 ; -0,14)"
6="[-0,14 ; -0,01)"
7="[-0,01 ; 0,16)"
8="[0,16 ; 0,30)"
9="[0,30 ; 0,64)"
10="[0,64 ; 2,54)"
11="Over 2,54"
;

value likv_midl_udv7_woe
1=-0.362
2=-2.077
3=-0.883
4=-0.143
5=0.321
6=0.815
7=1.153
8=0.734
9=0.553
10=0.039
11=-0.390
;



*************************************************************************
* Mindste månedlig kreditomsætning over 12 måneder krydset med helkunde *
*************************************************************************;


* Mindste månedlig kreditomsætning over 12 måneder - Gruppering 1 *;

value Minkred_a
.,low-<0           = 1
0-<980.47          = 2
980.47-<4198.24    = 3
4198.24-<14628.14  = 4
14628.14-<19541.08 = 5
19541.08-<24924.80 = 6
24924.8-<32708.83  = 7
32708.83-<37987.80 = 8
37987.80-high      = 9
;

value MinKred_a_txt
1="Ingen værdi"
2="Under 980,47"
3="[980,47 ; 4.198,24)"
4="[4.198,24 ; 14.628,14)"
5="[14.628,14 ; 19.541,08)"
6="[19.541,08 ; 24.924,80)"
7="[24.924,8 ; 32.708,83)"
8="[32.708,83 ; 37.987,80)"
9="Over 37.987,80"
;

* Mindste månedlig kreditomsætning over 12 måneder - Gruppering 2 *;

value Minkred_b
.,low-<0           = 1
0-<980.47          = 2
980.47-<4198.24    = 3
4198.24-high  = 4
;

value MinKred_b_txt
1="Ingen værdi"
2="Under 980,47"
3="[980,47 ; 4.198,24)"
4="Over 4.198,24"
;


* WOE for krydsvariablen mellem helkunde og mindste månedlig kreditomsætning *;

value $helkunde_minkred_woe
'J_1'=-0.274
'J_2'=-0.274
'J_3'=-0.124
'J_4'=0.049
'J_5'=0.245
'J_6'=0.486
'J_7'=0.808
'J_8'=1.052
'J_9'=1.295
'N_1'=0.025
'N_2'=-0.736
'N_3'=-0.069
'N_4'=0.971
'M_0'=-0.736
;



/*
value alder_X_likv_midl_gns3_inf_txt
1="Mangler"
2="Under 29; Mangler"
3="Under 29; Under 1.298,97"
4="Under 29; [1.298,97 ; 28.650,52)"
5="Under 29; Over 28.650,52"
6="[29;55); Mangler"
7="[29;55); Under 1.298,97"
8="[29;55); [1.298,97 ; 28.650,52)"
9="[29;55); [28.650,52 ; 46.874,58)"
10="[29;55); [46.874,58 ; 82.506,34)"
11="[29;55); [82.506,34 ; 142.177,10)"
12="[29;55); Over 142.177,10"
13="Over 55; Mangler"
14="Over 55; Under 1.298,97"
15="Over 55; [1.298,97 ; 28.650,52)"
16="Over 55; [28.650,52 ; 46.874,58)"
17="Over 55; [46.874,58 ; 82.506,34)"
18="Over 55; [82.506,34 ; 142.177,10)"
19="Over 55; Over 142.177,10"
;



value ejdvaerdi_samlet_inf_txt
1="Mangler"
2="Under 477.758,01"
3="[477.758,01 ; 579.383,28)"
4="[579.383,28 ; 719.168,53)"
5="[719.168,53 ; 828.069,34)"
6="[828.069,34 ; 1.200.720,70)"
7="[1.200.720,70 ; 1.469.179,69)"
8="[1.469.179,69 ; 1.944.649,83)"
9="[1.944.649,83 ; 2.147.795,90)"
10="Over 2.147.795,90"
;

value LIKV_MIDL_udv7_txt
1="Mangler"
2="Under -0,95"
3="[-0,95 ; -0,63)"
4="[-0,63 ; -0,30)"
5="[-0,30 ; -0,14)"
6="[-0,14 ; -0,01)"
7="[-0,01 ; 0,16)"
8="[0,16 ; 0,30)"
9="[0,30 ; 0,64)"
10="[0,64 ; 2,54)"
11="Over 2,54"
;

value AktLandsd_X_Udl_Rel_Kred12_h_txt
1="Mangler"
2="Helkunde;KBH;Mangler"
3="Helkunde;KBH;Under 0,01"
4="Helkunde;KBH;[0,01 ; 0,34)"
5="Helkunde;KBH;[0,34 ; 0,83)"
6="Helkunde;KBH;[0,83 ; 2,04)"
7="Helkunde;KBH; [2,04 ; 2,59)"
8="Helkunde;KBH;[2,59 ; 4,21)"
9="Helkunde;KBH;[4,21 ; 4,99)"
10="Helkunde;KBH;[4,99 ; 7,01)"
11="Helkunde;KBH;Over 7,01"
12="Helkunde;ej KBH;Mangler"
13="Helkunde;ej KBH;Under 0,01"
14="Helkunde;ej KBH;[0,01 ; 0,34)"
15="Helkunde;ej KBH;[0,34 ; 0,83)"
16="Helkunde;ej KBH;[0,83 ; 2,04)"
17="Helkunde;ej KBH;[2,04 ; 2,59)"
18="Helkunde;ej KBH;[2,59 ; 4,21)"
19="Helkunde;ej KBH;[4,21 ; 4,99)"
20="Helkunde;ej KBH;[4,99 ; 7,01)"
21="Helkunde;ej KBH;Over 7,01"
22="Ikke helkunde"
;

value LTV_Samlet_txt
1="Ingen boliglån"
2="Andelsbolig"
3="Ejendomsværdi mangler"
4="[0 ; 0,24)"
5="[0,24 ; 0,43)"
6="[0,43 ; 0,66)"
7="[0,66 ; 0,81)"
8="[0,81 ; 0,99)"
9="[0,99 ; 1,06)"
10="Over 1,06"
;

value Akt_X_kreditoms_mi12_h_inf_txt
1="Mangler"
2="Ikke-helkunde;Ren realkredit"
3="Ikke-helkunde;Under 980,47"
4="Ikke-helkunde;[980,47 ; 4.198,24)"
5="Ikke-helkunde;Over 4.198,24"
6="Helkunde;Under 980,47"
7="Helkunde;[980,47 ; 4.198,24)"
8="Helkunde;[4.198,24 ; 14.628,14)"
9="Helkunde;[14.628,14 ; 19.541,08)"
10="Helkunde;[19.541,08 ; 24.924,80)"
11="Helkunde;[24.924,8 ; 32.708,83)"
12="Helkunde;[32.708,83 ; 37.987,80)"
13="Helkunde;Over 37.987,80"
;
*/

run;


data adf1;
set adf1;

* Antal dage i overtræk/restance 3000 kr, 12 måneder *;
AntOvertrkRest_3000_sum12_grp=put('ant-overtrk-rest-3000-sum12'n,AntOvertrkRest_3000_sum12_h.)*1;
Attr_AntOvertrkRest_3000_sum12=put(AntOvertrkRest_3000_sum12_grp,AntOvertrkRest_3000_sum12_h_txt.);
WOE_AntOvertrkRest_3000_sum12=put(AntOvertrkRest_3000_sum12_grp,AntOvertrkRest_3000_sum12_h_woe.)*1;


* Antal dage i overtræk/restance 750 kr, 3 måneder *;
AntOvertrkRest_750_sum3_grp=put('ant-overtrk-rest-750-sum3'n,AntOvertrkRest_750_sum3_h.)*1;
Attr_AntOvertrkRest_750_sum3=put(AntOvertrkRest_750_sum3_grp,AntOvertrkRest_750_sum3_h_txt.);
WOE_AntOvertrkRest_750_sum3=put(AntOvertrkRest_750_sum3_grp,AntOvertrkRest_750_sum3_h_woe.)*1;


* Alder krydset med Gennemsnitlig likvide midler *;
alder_grp=put(alder,alder.)*1;
alder_grp_txt=put(alder_grp,alder_txt.);
/*if alder_grp=1 then do;
  likv_midl_gns3_grp=0;
  likv_midl_gns3_grp_txt='ALLE';
end;
else*/ if alder_grp=2 then do;
  likv_midl_gns3_grp=put('likv-midl-gns3-inf'n,likv_midl_gns3n_a.)*1;
  likv_midl_gns3_grp_txt=put(likv_midl_gns3_grp,likv_midl_gns3_a_txt.);
end;
else do;
  likv_midl_gns3_grp=put('likv-midl-gns3-inf'n,likv_midl_gns3n_b.)*1;
  likv_midl_gns3_grp_txt=put(likv_midl_gns3_grp,likv_midl_gns3_b_txt.);
end;

Likv_midl_gns3_inf_X_Alder=cats(alder_grp,'_',likv_midl_gns3_grp);
Attr_Likv_midl_gns3_inf_X_Alder=cat(trim(likv_midl_gns3_grp_txt),'; ',trim(alder_grp_txt));
WOE_Likv_midl_gns3_inf_X_Alder=put(Likv_midl_gns3_inf_X_Alder,$alder_likvmidl_woe.)*1;


* Samlet ejendomsværdi *;
ejdvaerdi_samlet_inf_grp=put('ejendomvaerdi-inf'n,ejdvaerdi_samlet_inf.)*1;
Attr_Ejendomsvaerdi_inf=put(ejdvaerdi_samlet_inf_grp,ejdvaerdi_samlet_inf_txt.);
WOE_Ejendomsvaerdi_inf=put(ejdvaerdi_samlet_inf_grp,ejdvaerdi_samlet_inf_woe.)*1;


* LTV *;
ltv_grp=put(ltv,ltv.)*1;
Attr_LTV=put(ltv_grp,ltv_txt.);
WOE_LTV=put(ltv_grp,ltv_woe.)*1;


* Samlet udlån / kreditomsætning over 12 mdr. (Gældsfaktor proxy) x landsdel og "helkunde / ikke-helkunde" *;
if helkunde='J' then do;
  landsdel_grp=put(landsdel,$landsdel.)*1;
  landsdel_grp_txt=put(landsdel_grp,landsdel_txt.);
  gaeldsfaktor_proxy_grp=put('gaeldsfaktor-proxy'n,gaeldsfaktor_proxy.)*1;
  gaeldsfaktor_proxy_grp_txt=put(gaeldsfaktor_proxy_grp,Gaeldsfaktor_proxy_txt.);
end;
else do;
  landsdel_grp=0;
  landsdel_grp_txt='ALLE';
  gaeldsfaktor_proxy_grp=0;
  gaeldsfaktor_proxy_grp_txt='ALLE';
end;
GF_proxy_X_Landsdel_X_Helkunde=cats(helkunde,'_',landsdel_grp,'_',put(gaeldsfaktor_proxy_grp,z2.));
Attr_GF_proxy_X_Landsdel_X_Helku=cat(trim(gaeldsfaktor_proxy_grp_txt),'; ',trim(landsdel_grp_txt),'; ',trim(helkunde));
WOE_GF_proxy_X_Landsdel_X_Helkun=put(GF_proxy_X_Landsdel_X_Helkunde,$helkunde_landsdel_gf_woe.)*1;


* Likvide midler udvikling 6 måneder *;
Likv_midl_udv7_grp=put('likv-midl-udv7'n,likv_midl_udv7n.)*1;
Attr_Likv_midl_udv7=put(Likv_midl_udv7_grp,likv_midl_udv7_txt.);
WOE_Likv_midl_udv7=put(Likv_midl_udv7_grp,likv_midl_udv7_woe.)*1;


* Mindste månedlig kreditomsætning over 12 måneder krydset med helkunde *;
if helkunde='J' then do;
  Kreditoms_min12_inf_grp=put('kreditoms-min12-inf'n,Minkred_a.)*1;
  Kreditoms_min12_inf_grp_txt=put(Kreditoms_min12_inf_grp,MinKred_a_txt.);
end;
else if helkunde='N' then do;
  Kreditoms_min12_inf_grp=put('kreditoms-min12-inf'n,Minkred_b.)*1;
  Kreditoms_min12_inf_grp_txt=put(Kreditoms_min12_inf_grp,MinKred_b_txt.);
end;
else do;
  Kreditoms_min12_inf_grp=0;
  Kreditoms_min12_inf_grp_txt='ALLE';
end;

Kreditoms_min12_inf_X_Helkunde=cats(helkunde,'_',Kreditoms_min12_inf_grp);
Attr_Kreditoms_min12_inf_X_Helku=cat(trim(Kreditoms_min12_inf_grp_txt),'; ',trim(Helkunde));
WOE_Kreditoms_min12_inf_X_Helkun=put(Kreditoms_min12_inf_X_Helkunde,$helkunde_minkred_woe.)*1;



*********
*********
* Score *
*********
*********;

Behaviour_score=
-1*(-4.376
-0.612*WOE_AntOvertrkRest_3000_sum12
-0.502*WOE_AntOvertrkRest_750_sum3
-0.519*WOE_Likv_midl_gns3_inf_X_Alder
-0.831*WOE_Ejendomsvaerdi_inf
-0.604*WOE_LTV
-0.720*WOE_GF_proxy_X_Landsdel_X_Helkun
-0.414*WOE_Likv_midl_udv7
-0.369*WOE_Kreditoms_min12_inf_X_Helkun
);

run;