/* cas mySession terminate; */
cas mySession sessopts=(timeout=3500000);
caslib _all_ assign;
options casdatalimit=20000M;

PROC FEDSQL SESSREF=mySession;
DROP TABLE  CASUSER.TEST FORCE;
CREATE TABLE CASUSER.TEST  AS SELECT 
START_DATO
,SLUT_DATO
,COUNT(KUNDENR) AS TEST 
FROM RAT_DATA.STAMOPLYSNINGER
GROUP BY START_DATO,SLUT_DATO
; 
QUIT; 


 %LET START_PERIODAG = 2018-03-01;  
 %LET SLUT_PERIODAG = 2023-01-31;  

/* %LET START_PERIODAG = 2022-02-01;  */
/* %LET SLUT_PERIODAG = 2022-04-10;  */

%LET SQL_START_PERIODAG=%STR(%')&START_PERIODAG.%STR(%');
%LET SQL_SLUT_PERIODAG=%STR(%')&SLUT_PERIODAG.%STR(%');

/*Laver relationstabellen på dagsbasis  */
PROC FEDSQL SESSREF=mySession;
drop table CASUSER.RELATIONER_FULD FORCE;
CREATE TABLE CASUSER.RELATIONER_FULD AS SELECT 
DAG.DATO
,REL.*
FROM (SELECT DATO FROM RAT_DATA.DAGE 

WHERE DATO < &SQL_SLUT_PERIODAG. and &SQL_START_PERIODAG. <DATO AND BKDAG_MND_ULTIMO=1
)
AS DAG

INNER JOIN (
SELECT 
KUNDENR
,NAVN
,CVRNR
,VIRKSOMHEDSNAVN
,SLSKFORM 
,SLSKFORM_TXT 
,EJERFORHOLD 
,EJERFORHOLD_TXT 
,DB07
,EJERANDELPCT 
,EJERANDELPCT_KORR
,ENGAGEMENT_KREDIT_VIRKSOMHED
,ANTAL_EJERE
,START_DATO
,SLUT_DATO


FROM RAT_DATA.RELATIONER 

WHERE START_DATO < &SQL_SLUT_PERIODAG. and &SQL_START_PERIODAG. <SLUT_DATO 
	  AND (ENGAGEMENT_KREDIT_VIRKSOMHED=. OR ENGAGEMENT_KREDIT_VIRKSOMHED<=250000 )
	  )
AS REL
ON REL.START_DATO<= DAG.DATO AND DAG.DATO<REL.SLUT_DATO
;
QUIT; 


/*Laver økonomitabellen og egenkapital på dagsbasis ud*/
PROC FEDSQL SESSREF=mySession;
drop table CASUSER.OKONOMI_DAGLIG FORCE;
CREATE TABLE CASUSER.OKONOMI_DAGLIG AS SELECT 
DAG.DATO
,OKO.*
FROM (SELECT DATO FROM RAT_DATA.DAGE 

WHERE DATO < &SQL_SLUT_PERIODAG. and &SQL_START_PERIODAG. <DATO AND BKDAG_MND_ULTIMO=1
)
AS DAG

INNER JOIN (
SELECT 
*

FROM RAT_DATA.OKONOMI

WHERE START_DATO < &SQL_SLUT_PERIODAG. and &SQL_START_PERIODAG. <SLUT_DATO 
)
AS OKO
/* ON DAG.DATO between ADF.START_DATO and ADF.SLUT_DATO-1 */
ON OKO.START_DATO <= DAG.DATO AND DAG.DATO < OKO.SLUT_DATO
;
QUIT; 

/*Henter egenkapitalen ud, som skal oveni økonomi-data  */
PROC FEDSQL SESSREF=mySession;
drop table CASUSER.REGNSKABER_DAGLIG FORCE;
CREATE TABLE CASUSER.REGNSKABER_DAGLIG AS SELECT 
DAG.DATO
,RGN.KUNDENR
,RGN.EGENKAPITAL_IALT
FROM (SELECT DATO FROM RAT_DATA.DAGE 

WHERE DATO < &SQL_SLUT_PERIODAG. and &SQL_START_PERIODAG. <DATO AND BKDAG_MND_ULTIMO=1
)
AS DAG

INNER JOIN (
SELECT 
KUNDENR
,EGENKAPITAL_IALT
,START_DATO
,SLUT_DATO
FROM RAT_DATA.REGNSKABER

WHERE START_DATO < &SQL_SLUT_PERIODAG. and &SQL_START_PERIODAG. <SLUT_DATO 
)
AS RGN
ON RGN.START_DATO <= DAG.DATO AND DAG.DATO < RGN.SLUT_DATO

HAVING EGENKAPITAL_IALT NOT IN (0 , .)
;
QUIT; 


/*Joiner egenkapitalen på relationstabellen */
/*Hvis egenkapitalen er negativ tages det hele med over, hvis den er positiv, så:   */
	/*A/S og ApS tager vi 50%. Det samme med Holding. KA/S behandles som ApS  */
	/*EMV og I/S og ApS tager vi 40%. K/S  behandles som I/S*/
PROC FEDSQL SESSREF=mySession;
drop table CASUSER.REGNSKABER_OVERFOERT FORCE;
CREATE TABLE CASUSER.REGNSKABER_OVERFOERT AS SELECT 
REL.DATO
,REL.KUNDENR
/* ,EGENKAPITAL_IALT */
/* ,EJERANDELPCT  */
/* ,EJERANDELPCT_KORR */
/* ,SLSKFORM  */
/* ,SLSKFORM_TXT  */
/* ,EJERFORHOLD  */
/* ,EJERFORHOLD_TXT */


,CASE WHEN EGENKAPITAL_IALT<0 THEN EGENKAPITAL_IALT*EJERANDELPCT_KORR/100 
	  WHEN EJERFORHOLD IN  (31, 32, 33) THEN EGENKAPITAL_IALT*EJERANDELPCT_KORR/100*0.4 
	  WHEN EJERFORHOLD IN (34, 35, 36, 999) THEN EGENKAPITAL_IALT*EJERANDELPCT_KORR/100*0.5
	  END AS FORMUE_BRUTTO
,CASE WHEN EGENKAPITAL_IALT<0 THEN EGENKAPITAL_IALT*EJERANDELPCT_KORR/100 
	  WHEN EJERFORHOLD IN  (31, 32, 33) THEN EGENKAPITAL_IALT*EJERANDELPCT_KORR/100*0.4 
	  WHEN EJERFORHOLD IN (34, 35, 36, 999) THEN EGENKAPITAL_IALT*EJERANDELPCT_KORR/100*0.5
	  END AS FORMUE_NETTO
 

FROM CASUSER.RELATIONER_FULD AS REL

LEFT JOIN CASUSER.REGNSKABER_DAGLIG AS RGN
ON REL.CVRNR=RGN.KUNDENR AND REL.DATO=RGN.DATO

WHERE EGENKAPITAL_IALT NOT IN (0 , .) and EJERANDELPCT_KORR NOT IN (0 , .)
/* WHERE OVERTRK_BLB>0 */
;
QUIT; 

/*Lægger egenkapitalen fra relationen (virksomheden) sammen med den private formue */
DATA CASUSER.OKONOMI_TOTAL  ( REPLACE=yes); 
SET CASUSER.OKONOMI_DAGLIG CASUSER.REGNSKABER_OVERFOERT; 
RUN; 


PROC SQL; 
CREATE TABLE TEST AS SELECT 
KUNDENR
,COUNT(KUNDENR) AS TALT 
FROM CASUSER.OKONOMI_TOTAL
GROUP BY KUNDENR
ORDER BY TALT DESC
; 
QUIT; 

PROC SQL; 
CREATE TABLE TEST AS SELECT 
COUNT(KUNDENR) AS TALT 
FROM RAT_DATA.OKONOMI
WHERE start_dato<="01FEB2022"d<SLUT_DATO
; 
QUIT; 

PROC FEDSQL SESSREF=mySession;
DROP TABLE  CASUSER.OKONOMI_KORR FORCE;
CREATE TABLE CASUSER.OKONOMI_KORR  AS SELECT 
KUNDENR
,DATO
,MAX(BEREGNINGS_ID) AS BEREGNINGS_ID
,MAX(BEREGNINGS_ID_STRING) AS BEREGNINGS_ID_STRING
,MAX(STATUSKODE) AS STATUSKODE
,MAX(IKRAFT_FRA_TMS) AS IKRAFT_FRA_TMS
,MAX(OPR_TMS) AS OPR_TMS
,MAX(AKTIVERING_TMS) AS AKTIVERING_TMS
,MAX(SLUT_TMS) AS SLUT_TMS
/* ,MAX(ALDER_SR_MND) AS ALDER_SR_MND */
,MAX(AKTIV_SR_FLAG) AS AKTIV_SR_FLAG
,MAX(BSK) AS BSK
,MAX(OPRETTELSES_EKSPID) AS OPRETTELSES_EKSPID
,MAX(GIFT) AS GIFT
,MAX(BEREGNINGS_START_D) AS BEREGNINGS_START_D
,MAX(BOPAELSKOMMUNE) AS BOPAELSKOMMUNE
,MAX(FORMUEOPG_DANNET) AS FORMUEOPG_DANNET
,MAX(GAELDSFAKTOR) AS GAELDSFAKTOR
,MAX(PRIMAER_KUNDE) AS PRIMAER_KUNDE
,MAX(PENSIONIST) AS PENSIONIST
,MAX(MEDL_AF_FOLKEKIRKE) AS MEDL_AF_FOLKEKIRKE
,MAX(ANT_AF_BOERN) AS ANT_AF_BOERN
,MAX(VIRKSOMHEDS_BESKAT) AS VIRKSOMHEDS_BESKAT
,MAX(EGEN_VIRKSOMHED_J) AS EGEN_VIRKSOMHED_J
,MAX(INVOLV_KONKURS_K) AS INVOLV_KONKURS_K
,MAX(KAU_FORPLIGT) AS KAU_FORPLIGT
,MAX(REST_ANPART) AS REST_ANPART
,MAX(BOLIG_UDG_AKTUEL) AS BOLIG_UDG_AKTUEL
,MAX(OPS_UDG_AKTUEL) AS OPS_UDG_AKTUEL
,MAX(TOTAL_UDG_AKTUEL) AS TOTAL_UDG_AKTUEL
,MAX(INDKOMST_STDFIN) AS INDKOMST_STDFIN
,MAX(EJSK_INDKOMST_STDFIN) AS EJSK_INDKOMST_STDFIN
,MAX(INDK_EFT_SKAT_STDFIN) AS INDK_EFT_SKAT_STDFIN
,MAX(BOLIG_UDG_STDFIN) AS BOLIG_UDG_STDFIN
,MAX(OPS_UDG_STDFIN) AS OPS_UDG_STDFIN
,MAX(TOTAL_UDG_STDFIN) AS TOTAL_UDG_STDFIN
,MAX(INDKOMST_STRESSET) AS INDKOMST_STRESSET
,MAX(EJSK_INDKOMST_STRESSET) AS EJSK_INDKOMST_STRESSET
,MAX(INDK_EFT_SKAT_STRESSET) AS INDK_EFT_SKAT_STRESSET
,MAX(BOLIG_UDG_STRESSET) AS BOLIG_UDG_STRESSET
,MAX(OPS_UDG_STRESSET) AS OPS_UDG_STRESSET
,MAX(TOTAL_UDG_STRESSET) AS TOTAL_UDG_STRESSET
,MAX(INDKOMST_PERSON_AKTUEL) AS INDKOMST_PERSON_AKTUEL
,MAX(EJSK_INDKOMST_PERSON_AKTUEL) AS EJSK_INDKOMST_PERSON_AKTUEL
,MAX(INDK_EFT_SKAT_PERSON_AKTUEL) AS INDK_EFT_SKAT_PERSON_AKTUEL
,MAX(INDKOMST_PERSON_STDFIN) AS INDKOMST_PERSON_STDFIN
,MAX(EJSK_INDKOMST_PERSON_STDFIN) AS EJSK_INDKOMST_PERSON_STDFIN
,MAX(INDK_EFT_SKAT_PERSON_STDFIN) AS INDK_EFT_SKAT_PERSON_STDFIN
,MAX(INDKOMST_PERSON_STRESSET) AS INDKOMST_PERSON_STRESSET
,MAX(EJSK_INDKOMST_PERSON_STRESSET) AS EJSK_INDKOMST_PERSON_STRESSET
,MAX(INDK_EFT_SKAT_PERSON_STRESSET) AS INDK_EFT_SKAT_PERSON_STRESSET
,MAX(EJENDOM_AKTIV) AS EJENDOM_AKTIV
,MAX(TRANSPORT_AKTIV) AS TRANSPORT_AKTIV
,MAX(INDLAAN) AS INDLAAN
,MAX(AABNE_DEPOT) AS AABNE_DEPOT
,MAX(OPSPARING) AS OPSPARING
,MAX(PENSION) AS PENSION
,MAX(ANDEN_FORMUE) AS ANDEN_FORMUE
,MAX(EJENDOM_GAELD) AS EJENDOM_GAELD
,MAX(TRANSPORT_GAELD) AS TRANSPORT_GAELD
,MAX(UDLAAN) AS UDLAAN
,MAX(ANDEN_GAELD) AS ANDEN_GAELD
,MAX(GAELD) AS GAELD
,MAX(BANK_LAAN_KTO) AS BANK_LAAN_KTO
,MAX(SU_LAAN) AS SU_LAAN
,MAX(BANK_LAAN) AS BANK_LAAN
,MAX(OVR_LAAN) AS OVR_LAAN
,MAX(OVR_LAAN_ANTAL) AS OVR_LAAN_ANTAL
,MAX(BOLIG_UDLAEG) AS BOLIG_UDLAEG
,MAX(BOLIG_UDLAEG_ANTAL) AS BOLIG_UDLAEG_ANTAL
,MAX(FORMUE_AAR_1) AS FORMUE_AAR_1
,MAX(FORMUE_AAR_2) AS FORMUE_AAR_2
,MAX(FORMUE_AAR_3) AS FORMUE_AAR_3
,MAX(FORMUE_AAR_4) AS FORMUE_AAR_4
,MAX(FORMUE_AAR_5) AS FORMUE_AAR_5
,MAX(EJENDOMSTYPE) AS EJENDOMSTYPE
,MAX(EJENDOMSTYPE_TXT) AS EJENDOMSTYPE_TXT
,MAX(BOLIGFORM) AS BOLIGFORM
,MAX(BOLIGFORM_TXT) AS BOLIGFORM_TXT
,MAX(SR_BORN_ANTAL) AS SR_BORN_ANTAL
,MAX(SR_VOKSNE_ANTAL) AS SR_VOKSNE_ANTAL
,MAX(RAADIGHEDSBELOB_AKTUEL) AS RAADIGHEDSBELOB_AKTUEL
,MAX(RAADIGHEDSBELOB_STDFIN) AS RAADIGHEDSBELOB_STDFIN
,MAX(RAADIGHEDSBELOB_STRESSET) AS RAADIGHEDSBELOB_STRESSET
,SUM(FORMUE_BRUTTO) AS FORMUE_BRUTTO
,SUM(FORMUE_NETTO) AS FORMUE_NETTO
,MAX(INDKOMST_BRUTTO) AS INDKOMST_BRUTTO
,MAX(INDKOMST_NETTO) AS INDKOMST_NETTO
,MAX(GAELDSFAKTOR_BEREGNET_FLG) AS GAELDSFAKTOR_BEREGNET_FLG
,MAX(VOKSNE_ANTAL) AS VOKSNE_ANTAL
,MAX(BORN_ANTAL) AS BORN_ANTAL
,MAX(VOKSNE_BORN_KILDE) AS VOKSNE_BORN_KILDE
,MAX(RAADIGHEDSBELOB_MND) AS RAADIGHEDSBELOB_MND
,MAX(RAADIGHEDSBELOB_TYPE) AS RAADIGHEDSBELOB_TYPE
,MAX(RAAD_OPFYLD_GRAD) AS RAAD_OPFYLD_GRAD9
,MAX(RAADIGHEDSBELOB_KRAV) AS RAADIGHEDSBELOB_KRAV

FROM CASUSER.OKONOMI_TOTAL

GROUP BY KUNDENR, DATO

HAVING MAX(BEREGNINGS_ID_STRING) <> ''
;
QUIT; 

/*Danner datoer */
DATA CASUSER.OKONOMI_KORR ( REPLACE=yes); 
SET CASUSER.OKONOMI_KORR; 

/*Beregner SR-ALDER, da den ikke er lavet i data. Beregnes på samme måde som i S&R-data  */
ALDER_SR_MND=YRDIF(DATEPART(AKTIVERING_TMS),DATO,'ACT/ACT')*12;


/*Hvis vi kører ultimo  */
START_DATO=intnx('month',dato,-1,'E') ; 
SLUT_DATO=intnx('month',dato,0,'E') ;

 
/* Hvis vi kører dagligt */
/* START_DATO=DATO;  */
/* SLUT_DATO=intnx('day',dato,+1);  */

		
start_dttm=dhms(start_dato,0,0,0) ;
slut_dttm=dhms(SLUT_DATO,23,59,59)-86400  ;
format START_DATO SLUT_DATO DATE9. slut_dttm start_dttm datetime20. ;
run;

/*Uploader til RAT_DATA  */
%LET VIYA_LIBRARY=RAT_DATA; 
%LET TABEL_NAVN=OKONOMI_KORR; 

	proc casutil  incaslib="casuser" outcaslib="&VIYA_LIBRARY." ;    
		save casdata="&TABEL_NAVN." replace; 
		DROPTABLE CASDATA="&TABEL_NAVN." INCASLIB="&VIYA_LIBRARY." QUIET;
		load casdata="&TABEL_NAVN..sashdat" 
		casout="&TABEL_NAVN." 	
		incaslib="&VIYA_LIBRARY."  promote;
	run;


