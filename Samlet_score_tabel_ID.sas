/**********************************************************
	NAME:	Samlet_score_tabel_ID.sas
	DESC:	Samler alle scoreværdier for alle delmodeller
			som så kan behandles i SAS ID
**********************************************************/
/**************************
DEBUG
%let scor_date=30JUN2022;
cas mySession sessopts=(timeout=3500000);
caslib _all_ assign;
***************************/


/* segment data */
proc fedsql sessref=mysession;
	create table casuser.SEGMENT as	
	select 	DISTINCT ID 
			,INDLAEST, KUNDENR, DEL_MODPARTS_ID, MODPARTS_ID, SEGMENT, UNDERSEGMENT
			,OKONOMI_MODEL
    		,ADF_MODEL
    		,RGN_MODEL
    		,MATRIX_MODEL
	from sandbox.prse_segmentering
	;
quit;

* tjekker vi ikke har dubletter *;
proc sort data=casuser.segment  nodupkey dupout=casuser.segment_dups;
	by kundenr;
run;

/*  INSERT KODE TIL SCORING HER 
	UDFØRES I DAN_SCORE_RESULTS_ID.SASFILE
*/

data casuser.kredit_politikker;
	set rm_mdl.kredit_politikker;
	keep RKI_ANMAERKNINGER
KNDSPKODE
UDLAEG_BLB
SLSK_STATUS
CVR_STATUS
EGENKAPITAL_IALT_1
RESULTAT_FOERSKAT_1
RESULTAT_FOERSKAT_2
KONSOLIDERING_1
KONSOLIDERING_2
MDR_TIL_NAESTE_OFF
ENGAGEMENT_10000_FLAG
FORMUE_NETTO
PRIVAT_SOLIDITET
RAAD_OPFYLD_GRAD
SR_ALDER_MND
INDLAAN_SUM_MEAN_3MND
DEPOT_FRIEMIDL_SUM_MEAN_3MND
UDLAAN_SUM_MEAN_3MND_12MND
KREOMS_MINUS_DEBOMS_MEAN_12M
ALDER
kundenr
;
run;

proc sort data=casuser.kredit_politikker  nodupkey dupout=casuser.kredit_politikker_dups;
	by kundenr;
run;


proc fedsql sessref=mysession;
	create table casuser.segment_politikker as		
		select a.*
				,b.RKI_ANMAERKNINGER
				,b.KNDSPKODE
				,b.UDLAEG_BLB
				,b.SLSK_STATUS
				,b.CVR_STATUS
				,b.EGENKAPITAL_IALT_1
				,b.RESULTAT_FOERSKAT_1
				,b.RESULTAT_FOERSKAT_2
				,b.KONSOLIDERING_1
				,b.KONSOLIDERING_2
				,b.MDR_TIL_NAESTE_OFF    
				,b.ENGAGEMENT_10000_FLAG
				,b.FORMUE_NETTO
				,b.PRIVAT_SOLIDITET
				,b.RAAD_OPFYLD_GRAD
				,b.SR_ALDER_MND
				,b.INDLAAN_SUM_MEAN_3MND
				,b.DEPOT_FRIEMIDL_SUM_MEAN_3MND		
				,b.UDLAAN_SUM_MEAN_3MND_12MND
				,b.KREOMS_MINUS_DEBOMS_MEAN_12M		
				,b.ALDER
		from casuser.SEGMENT a, casuser.kredit_politikker b
		where a.kundenr=b.kundenr
	;
quit;


proc sort data=casuser.segment_politikker  nodupkey dupout=casuser.segment_politikker_dups;
	by kundenr;
run;

/* Givet succesfuld scoring, så sæt alle delresultater sammen */
PROC FEDSQL SESSREF=MYSESSION;
	create table casuser.DELRESULTATER as 
	select 
		coalesce(a.kundenr,b.kundenr,c.kundenr,d.kundenr,e.kundenr,f.kundenr) 												as kundenr
		
		,coalesce(A.adf_model_rk,b.adf_model_rk,c.adf_model_rk,f.adf_model_rk) 											as adf_model_rk
		,coalesce(A.rgn_model_rk,b.rgn_model_rk,c.rgn_model_rk,f.rgn_model_rk) 												as rgn_model_rk
		,coalesce(A.adfaerd_model_rk,b.adfaerd_model_rk,c.adfaerd_model_rk,e.adfaerd_model_rk,f.adfaerd_model_rk) 			as adfaerd_model_rk
		,coalesce(A.regnskab_model_rk,b.regnskab_model_rk,c.regnskab_model_rk,f.regnskab_model_rk) 							as regnskab_model_rk
		,coalesce(d.matrix_model_rk,e.matrix_model_rk,f.matrix_model_rk) 													as matrix_model_rk
		,e.okonomi_model_rk


		,coalesce(A.adf_proj_rk,b.adf_proj_rk,c.adf_proj_rk,f.adf_proj_rk) 													as adf_proj_rk
		,coalesce(A.rgn_proj_rk,b.rgn_proj_rk,c.rgn_proj_rk,f.rgn_proj_rk) 													as rgn_proj_rk
		,coalesce(A.adfaerd_proj_rk,b.adfaerd_proj_rk,c.adfaerd_proj_rk,e.adfaerd_proj_rk,f.adfaerd_proj_rk) 				as adfaerd_proj_rk
		,coalesce(A.regnskab_proj_rk,b.regnskab_proj_rk,c.regnskab_proj_rk,f.regnskab_proj_rk) 								as regnskab_proj_rk
		,coalesce(d.matrix_proj_rk,e.matrix_proj_rk,f.matrix_proj_rk) 														as matrix_proj_rk		
		,e.okonomi_proj_rk
		
		,coalesce(a.stift_alder,b.stift_alder,d.stift_alder,f.stift_alder) 													as STIFT_ALDER
		,coalesce(a.RGN_SLUT_DATO_1,b.RGN_SLUT_DATO_1,d.RGN_SLUT_DATO_1,f.RGN_SLUT_DATO_1) 									as RGN_SLUT_DATO_1
		,coalesce(a.OVERTRAEK_EJ_KRITISK,b.OVERTRAEK_EJ_KRITISK,d.OVERTRAEK_EJ_KRITISK,e.OVERTRAEK_EJ_KRITISK,f.OVERTRAEK_EJ_KRITISK) 				as OVERTRAEK_EJ_KRITISK 

		,A.EMV_EKSPERT_ADF_SCR
		,A.EMV_EKSPERT_RGN_SCR
		,A.EMV_ADFAERD_SCR
		,A.EMV_REGNSKAB_SCR

		,b.HOLDING_EKSPERT_ADF_SCR
		,B.HOLDING_EKSPERT_RGN_SCR
		,b.HOLDING_ADFAERD_SCR
		,b.HOLDING_REGNSKAB_SCR

		,c.ANDELSBOLIG_EKSPERT_ADF_SCR
		,c.ANDELSBOLIG_EKSPERT_RGN_SCR
		,c.ANDELSBOLIG_ADFAERD_SCR
		,c.ANDELSBOLIG_REGNSKAB_SCR

		,d.MATRIX_PANTEBREV_SCR
		,d.MATRIX_INTERN_SCR
		,d.MATRIX_EJERFORENING_SCR
		,d.MATRIX_ANSVARLIGT_LAAN_SCR
		,e.MATRIX_REST_PRIVAT_SCR
		,f.MATRIX_REST_ERHVERV_SCR

		,e.PRIVAT_ADFAERD_SCR
		,e.PRIVAT_OKONOMI_SCR
		
		,f.ERHVERV_EKSPERT_ADF_SCR
		,f.ERHVERV_EKSPERT_RGN_SCR
		,f.ERHVERV_ADFAERD_SCR
		,f.ERHVERV_REGNSKAB_SCR

		,coalesce(a.scorecard_points,b.scorecard_points,c.scorecard_points,d.scorecard_points,e.scorecard_points,f.scorecard_points) as scorecard_points
		,coalesce(a.scoring_date,b.scoring_date,c.scoring_date,d.scoring_date,e.scoring_date,f.scoring_date) as scoring_date
		,coalesce(a.scoring_dttm,b.scoring_dttm,c.scoring_dttm,d.scoring_dttm,e.scoring_dttm,f.scoring_dttm) as scoring_dttm
	from scoring.EMV 					a
	full join scoring.HOLDING 			b   	ON   b.kundenr=a.kundenr
	full join scoring.ANDELSBOLIG 		c 		ON   c.kundenr=a.kundenr  OR c.kundenr=b.kundenr
	full join scoring.MATRIX  			d  		ON   d.kundenr=a.kundenr  OR d.kundenr=b.kundenr  OR d.kundenr=c.kundenr
	full join scoring.PRIVAT  			e  		ON   e.kundenr=a.kundenr  OR e.kundenr=b.kundenr  OR e.kundenr=c.kundenr OR e.kundenr=d.kundenr
	full join scoring.ERHVERV  			f  		ON   f.kundenr=a.kundenr  OR f.kundenr=b.kundenr  OR f.kundenr=c.kundenr OR f.kundenr=d.kundenr OR f.kundenr=e.kundenr
	;
quit; 

proc sort data=casuser.delresultater  nodupkey dupout=casuser.delresultater_dups;
	by kundenr;
run;


* Så er vi klar til den denlige tabel: segment<->kredit_politikker<->delresultater *;
proc fedsql  sessref=mySession;
	create table casuser.score_values as	
	select  	a.RKI_ANMAERKNINGER
				,a.KNDSPKODE
				,a.UDLAEG_BLB
				,a.SLSK_STATUS
				,a.CVR_STATUS
				,a.EGENKAPITAL_IALT_1
				,a.RESULTAT_FOERSKAT_1
				,a.RESULTAT_FOERSKAT_2
				,a.KONSOLIDERING_1
				,a.KONSOLIDERING_2
				,a.MDR_TIL_NAESTE_OFF
				,a.ENGAGEMENT_10000_FLAG
				,a.FORMUE_NETTO
				,a.PRIVAT_SOLIDITET
				,a.RAAD_OPFYLD_GRAD
				,a.SR_ALDER_MND
				,a.INDLAAN_SUM_MEAN_3MND
				,a.DEPOT_FRIEMIDL_SUM_MEAN_3MND
				,a.UDLAAN_SUM_MEAN_3MND_12MND
				,a.KREOMS_MINUS_DEBOMS_MEAN_12M
				,a.ALDER
				,a.ID 
				,a.INDLAEST
				,a.DEL_MODPARTS_ID
				,a.MODPARTS_ID
				,a.SEGMENT
				,a.UNDERSEGMENT
				,a.OKONOMI_MODEL
    			,a.ADF_MODEL
    			,a.RGN_MODEL
    			,a.MATRIX_MODEL
				, b.*
	from 	casuser.segment_politikker a, 
			casuser.DELRESULTATER b
	where a.kundenr=b.kundenr
;
quit;

  
* pæne formater på date og datetime vars *;
proc casutil incaslib="casuser" outcaslib="casuser";

	altertable casdata="score_values"
		columns =
	{
		{name="RGN_SLUT_DATO_1" format="date9"}
		{name="INDLAEST" format="datetime20"}
		{name="SCORING_DTTM" format="datetime20"}
		{name="SCORING_DATE" format="date9"}
	};
quit;

Proc casutil  incaslib="casuser" outcaslib="scoring" ;    
	save casdata="score_values" replace; 
	DROPTABLE CASDATA="score_values" INCASLIB="scoring" QUIET;
	load casdata="score_values.sashdat" 
		casout="score_values" 	incaslib="scoring"  promote;
run;  

cas mysession terminate;
	

			