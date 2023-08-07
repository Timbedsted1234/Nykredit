*** Input data *************************************************;

*** Endeligt adfærdsdata ***;
%let Endelig_adf_data=adf1;

%let Ren_indlaan='REN-INDLAAN-KUNDE'n;
%let Tid_risk_prod='TID-MED-RISIKOPRODUKT-MD'n;

*** Endeligt ansøgningsdata ***;
%let Endelig_ans_data=APP_inputvar_woe;

%let Score_dato=BEC_APPL_SCORE_DATO;		* Scoretidspunkt (til beregning af tid siden scoretidspunkt i md);
%let Score_tid=BEC_OPRET_TIMESTAMP;		* Scoretidspunkt (til beregning af tid siden scoretidspunkt i md);
%let Udbet_dato=BEC_FOERSTE_UDBETALING;		* Udbetalingstidspunkt ( til beregning af tid siden udbetaling i md);

*** Til kalibrering ***;
%let K=0.0308;
%let K_moc=0.2280;


*** Kobling af data og klargøring til sammenvægtning *******************************;

* MJEL opdatering 2022-12-16: Vælger først udfra seneste scoretidspunkt før der vælges udfra seneste oprettelsesdato *;
* MJEL opdatering 2022-12-16: Tilføjet same til de intnx-funktioner. Konsekvens: Antal observationer med værdier i bec_laanesagnr i datasættet samlet_data_1 stiger fra 56779 til 58263. *;
* MJEL opdatering 2022-12-20: Fletning på adfærdsdata sker nu også på ratingrelation *;
* EMKR opdatering 2023-03-08: Fejl i sammenvægtningen for nye kunder mellem 6-23 md rettet *;
* AMLS opdatering 2023-03-30: Fejl i Applikation_udb_alder_md, der kan antage negative værdier;
* MJEL opdatering 2023-04-13: Ansøgningsdata flettes på portefølje og ikke på adfærdsdata (dvs. der kommer kontakter der har ansøgning, men ikke adfærdsdata). *;
* MJEL opdatering 2023-04-13: Ansøgninger på scoredatoen tages med. (a.day_eom_date > input(put(ans.&Score_dato.,8.), Yymmdd10.) ændres til a.day_eom_date >= input(put(ans.&Score_dato.,8.), Yymmdd10.)*;
* MJEL opdatering 2023-04-13: Rettet kode for fejlkode 1029 *;


proc sql;
create table samlet_data_1 as
select a.*,
	   ip.BEC_INTERESSENTNR,
	   adf.* , 
	   ans.*,
	   intck('month', input(put(ans.&Score_dato.,8.), Yymmdd10.), input(put(a.day_eom,8.), Yymmdd10.), 'C') as Applikation_score_alder_md,
	   intck('month', input(put(ans.&Udbet_dato.,8.), Yymmdd10.), input(put(a.day_eom,8.), Yymmdd10.), 'C') as Applikation_udb_alder_md
from bestand_mm3 a
	 left join &Endelig_adf_data. adf on a.nkk_kontakt_ratrel=adf.'fk-kontakt-id'n
	 								  and a.day_eom=adf.day_eom
	 left join dm126dp.D_IP ip on a.nkk_kontakt=ip.nkk_kontakt 
							   and a.day_eom>=ip.valid_from and a.day_eom<ip.valid_to
/*
     left join &Endelig_ans_data. ans on input(ip.BEC_INTERESSENTNR,15.)=ans.BEC_KUNDE_NUMMER
	 								  and adf.day_eom_date > input(put(ans.&Score_dato.,8.), Yymmdd10.)
									  and ((adf.day_eom_date <= intnx('month',input(put(ans.&Score_dato.,8.), Yymmdd10.),12,'same') and ans.&udbet_dato.=.)
										   or adf.day_eom_date <= intnx('year',input(put(ans.&udbet_dato.,8.), Yymmdd10.),2,'same'))
*/
	 left join &Endelig_ans_data. ans on input(ip.BEC_INTERESSENTNR,15.)=ans.BEC_KUNDE_NUMMER
	 								  and a.day_eom_date >= input(put(ans.&Score_dato.,8.), Yymmdd10.)
									  and ((a.day_eom_date <= intnx('month',input(put(ans.&Score_dato.,8.), Yymmdd10.),12,'same') and ans.&udbet_dato.=.)
										   or a.day_eom_date <= intnx('year',input(put(ans.&udbet_dato.,8.), Yymmdd10.),2,'same'))

							   group by a.nkk_kontakt, a.day_eom
having ans.&Score_dato.=max(ans.&Score_dato.)
;quit;

proc sql;
create table samlet_data as
select *
from samlet_data_1
group by nkk_kontakt, day_eom
having &Score_tid.=max(&Score_tid.)
;
quit;


*** Fejlkoder inden kald af netværk ***;
data samlet_2_fejlkoder;
set samlet_data;

	return_code=-1;

	* EMV / PMV uden ratingrelation (ny fejlkode 1031) *;
	* - Denne springer vi over, da de fanges af Erhverv (fejlkode 1032), og data til at bestemme fejlkode 1031 ikke findes *;

    * Erhverv *;
	if fk_cpr_cvr_type=2 and rating_relation_nkk_id in (0,.) then return_code=1032;

	* Manglende samtykke (fejlkode 1023) *;
	* - Denne springer vi over: Det drejer sig kun om 300-400 kunder, og de vil være tydelige at skille ud i fbm test (da de får fejlkode 1023 i TOLs kode) *;

	* Under 18 år (fejlkode 1022) *;
	else if alder<18 and alder not in (-1,.) then return_code=1022;		/*Alder fra behavior */

	* Kunden har ingen aktive lån, konti med aktivitet eller lånesager (fejlkode 1024) *;
	else if coalesce(&Tid_risk_prod.,-1)=-1 and BEC_LAANESAGNR=. then return_code=1024;

	* Kunden er ren indlånskunde og har ingen ansøgning (fejlkode 1025) *;
	else if &Ren_indlaan.="J" and BEC_LAANESAGNR=. then return_code=1025;

run;

data input_til_netvaerk;
set samlet_2_fejlkoder;

	if Applikation_score_alder_md^=. and coalesce(Applikation_udb_alder_md,-1)<0 then Applikation_udb_alder_md=0;

	*where return_code=-1 and fejlkode_nuv_min=0;	*Filter fjernet for at beholde et stort datasæt der kan køres analyser på;
run;


*** Sammenvægtning og kalibrering ********************************************************;
data samv_netvaerk;
set input_til_netvaerk;

* Rene indlånskunder ses som ny kunde ;
	if &ren_indlaan.="J" then Tid_risk_prod_just=-1;		/*TJEK REN INDLAAN værdier*/
		else Tid_risk_prod_just=&Tid_risk_prod.;

* Eksisterende / ny kunde ;
	if Tid_risk_prod_just-coalesce(Applikation_score_alder_md,0)>12 then 
		Ny_eller_eksist_app="Eksisterende";
	else
		Ny_eller_eksist_app="Ny";

* Sammenvægtning ;
	if applikation_score_alder_md=. then do;
		Samvaegt_app_pct=0;
		samvaegt_grp="Ingen Ansoegning";
		end;
	else do;
		if Tid_risk_prod_just-coalesce(Applikation_score_alder_md,0)>12 then do;		*Eksisterende kunde;
			if Applikation_udb_alder_md >= 0 and Applikation_udb_alder_md <= 23 then do;
				Samvaegt_app_pct=min (max (50 * (1 - Applikation_udb_alder_md / 24), 0), 50) / 100;
				samvaegt_grp="EKS_<=23";
				end;
			else do;
				Samvaegt_app_pct=0;
				samvaegt_grp="EKS_>=24";
				end;
			end;
		else do;															*Ny kunde;
			if Applikation_udb_alder_md <= 5 and Applikation_udb_alder_md >= 0 then do;
				Samvaegt_app_pct=1;
				samvaegt_grp="NY<=5";
				end;
			else if Applikation_udb_alder_md >= 6 and Applikation_udb_alder_md <= 23 then do;
				Samvaegt_app_pct=min (max ((1 - (Applikation_udb_alder_md-5) / (24 - 5)) * 100, 0), 100) / 100;
				samvaegt_grp="NY_6<=23";
				end;
			else do;
				Samvaegt_app_pct=0;
				samvaegt_grp="NY>=24";
				end;
			end;
		end;

* Fejlkoder i netværk;
    if return_code=-1 then do;
	  * Kunden har ingen aktive lån, konti med aktivitet eller lånesager (fejlkode 1024) *;
	  if &Tid_risk_prod. in (-1,.) and Samvaegt_app_pct>0 and Samvaegt_app_pct<1 then Return_code=1029;

	  * Kunden er ren indlånskunde og har ingen ansøgning (fejlkode 1025) *;
	  else if &Ren_indlaan.="J" and Samvaegt_app_pct>0 and Samvaegt_app_pct<1 then Return_code=1030;
    end;
* Resterende knuder i netværk;
	PD_App=exp(-Application_score)/(exp(-Application_score)+1);
	PD_beh=exp(-Behaviour_score)/(exp(-Behaviour_score)+1);

	Samvaegt_PD=Samvaegt_app_pct * coalesce(PD_App,0) + (1 - Samvaegt_app_pct) * coalesce(PD_Beh,0);
	if 'NYK-REALKREDIT-KUNDE'n="J" and Groenland^="J" and International^="J" then 
				Ajd_samvaegt_PD=min(Samvaegt_PD+0.004,1);		
		else 	Ajd_samvaegt_PD=min(Samvaegt_PD+0.0004,1);

	X_samvaegt_score=-log (Ajd_samvaegt_PD / (1 - Ajd_samvaegt_PD));

	K_score_neutral_AP_PD=&K.;
	X_Neutral_AP_score=X_Samvaegt_score - K_score_neutral_AP_PD;
	Neutral_AP_PD=1 / (1 + exp (X_Neutral_AP_score));

	K_score_PD=&K_moc.;
	X_AP_score=X_Samvaegt_score - K_score_PD;
	PD_temp=1 / (1 + exp (X_AP_score));

	if Return_code = -1 then PD_f=min (PD_temp, 1);
		else PD_f=-1;
run;

