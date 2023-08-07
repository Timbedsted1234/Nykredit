/*
Macro Name	: csbmva_Distance_Stats
Function	: This macro calculates various distance measures like AUC, AR, 1-PH, D, KS, KL, Information statistic(I)
Created by	: BIS Team
Date		: Aug 07, 2010
SAS Version	:  9.2

Calls		:None

Parameters	: 

input			: Name of the input data set (Input data set is the Confusion matrix with each cut-off)
diststat		: Name of the data set which strores all distance measure values.
 
Input Dataset(s) Format:

--------------------------------------------------------------------------
Name				Type		Format
--------------------------------------------------------------------------
Pool_Name			Character 	Default Formatting	
Pool_Seq_no	 		Number		Default Formatting
Pool_Sk	 		Number		Default Formatting
score_time_sk           Number		Default Formatting
level_sk                Number		Default Formatting
Model_sk                 Number		Default Formatting
Model_rk                 Number		Default Formatting
No_Of_records_Actual	Number		Default Formatting
No_of_records_Dev	 	Number 		Default Formatting
estimated_PD	 				Number		Default Formatting
Max_Score_Points	 	Number		Default Formatting
No_Of_Actual_Bads	Number		Default Formatting	
--------------------------------------------------------------------------

Output Dataset(s) Format:
diststat
-------------------------------------------------------------------------
Name			Type		Format
------------------------------------------------------------------------
_NAME_			Character	Default Format
VALUE*			Numeric		Default Format
------------------------------------------------------------------------

Logic:
1.Compute Proportion of bads, propotion of goods for a pool wrt total bads and total goods respectively
2. Find out the median of the given data using SAS's univariate procedure.
3. Find out cumulative proportion of goods and bads and various measures
4. Find out Information Stat, KL stat and KS for pool using following formulae
	I_Stat = (proportion of bads - proportion of goods)* ln(proportion of bads/proportion of goods)
	KL_Stat = proportion of bads* ln(proportion of bads/proportion of goods)
	KS_stat = (proportion of bads - proportion of goods)
5. Use proc expand and Trapizoidal rule to compute AUC and AR 
6. Calculate Single Value based on pool based data obtained in step 4 & 5
7. Store these values in table with name stored in diststat variable.

Notes:
1. It is assumed that data set of specified as input_ds is present and has necessarry required rights.
2. It is assumed that data set of specified as input_ds has valid specified fileds.
3. For all output datasets (Viz output_graph_ds,output_stat_ds),it is assumend that
	a. it has valid name.
	b. Macro has necessary required rights to create the datasets with specified name @ specified location.
	c. Name of the data-set is unique OR if dataset with similar name already exists then it can be safely overwritten.

*/

%macro csbmva_distance_stats (input=, diststat=);

%let err_code=;
/*****************************************************************/
%csbmva_alldefaults_nodefaults(&input,NO_OF_RECORDS_ACTUAL,No_Of_Actual_Bads, err_code);
%if (&err_code ne 'NONE')%then %goto Error_Handler;/*i18NOK:LINE */
/*****************************************************************/
proc sql noprint;
		create table Distance_stats as 
		select MAX_SCORE_POINTS, No_Of_Actual_Bads/Sum(No_Of_Actual_Bads) as Prop_bads, 
(NO_OF_RECORDS_ACTUAL - No_Of_Actual_Bads) /(Sum(NO_OF_RECORDS_ACTUAL)- Sum(No_Of_Actual_Bads))  
as Prop_goods from &Input order by MAX_SCORE_POINTS ; 
quit;

proc univariate data = &Input noprint;
	   var MAX_SCORE_POINTS;
	   freq No_Of_Actual_Bads; 
	   output out=Work.Median
	          median=Median;
run;
/*****************************************************************/
%csbmva_errorhandler(err_code);

%if (&err_code ne 'NONE')%then %goto Error_Handler;/*i18NOK:LINE */
/*****************************************************************/

data Distance_stats; 
	retain	cum_prop_bads 0
			cum_prop_goods 0 
			ks  0 ;	
			format a b 8. ;
	set Distance_stats;
		cum_prop_bads = Sum(cum_prop_bads, prop_bads);
		cum_prop_goods = Sum(cum_prop_goods, prop_goods);
		if prop_goods = 0 then 
		do;
			A = .;
			B = .;
		end;
		else 
		do;
			A = prop_bads*log(prop_bads/prop_goods);
			B = (prop_bads -prop_goods)*log(prop_bads/prop_goods);
		end;
		ks = cum_prop_bads-cum_prop_goods;
run;

proc expand data= Distance_stats out=Distance_stats; 
	      id MAX_SCORE_POINTS;
	   convert cum_prop_goods = cum_prop_goods1  / transform=( lag 1 );
		  
run;
/*****************************************************************/
%csbmva_errorhandler(err_code);

%if (&err_code ne 'NONE')%then %goto Error_Handler;/*i18NOK:LINE */
/*****************************************************************/
data Distance_stats;
	set Distance_stats;
	MAX_SCORE_POINTS=input(put(MAX_SCORE_POINTS,20.4),20.);
		roc1 = prop_bads*sum(cum_prop_goods,cum_prop_goods1)/2;
run;

%let score_prev=0;
%let score_next=0;
proc sql  noprint;
		select Median format=20.4 into : Median from work.Median;
		select min(MAX_SCORE_POINTS) format=20.4, max(MAX_SCORE_POINTS) format=20.4 into :min_score, :max_score from Distance_stats;
		%put median=&median max=&max_score min=&min_score;
		%if &median = &min_score %then %do;
			%let score_prev=&median;
			select max(cum_prop_goods) into : cum_prob_prev from Distance_stats where MAX_SCORE_POINTS = &Median ;
		%end;
		%else %do;
			select max(MAX_SCORE_POINTS) format=20.4 into : score_Prev from Distance_stats where MAX_SCORE_POINTS < &Median; 
			select max(cum_prop_goods) into : cum_prob_prev from Distance_stats where MAX_SCORE_POINTS < &Median ;
		%end;
		%if &median = &max_score %then %let score_next=&median;
		%else %do;
			select min(MAX_SCORE_POINTS) format=20.4 into : score_Next from Distance_stats where MAX_SCORE_POINTS > &Median; 
		%end;
		select prop_goods into : prob_next from Distance_stats where MAX_SCORE_POINTS = &score_next;
		select sum(B) format=&CS_PERC_FMT. from Distance_stats;
quit;
%put median=&median prev=&score_prev next=&score_next prob_next=&prob_next cum_prev=&cum_prob_prev;
proc sql noprint;
		select sum(prop_goods*MAX_SCORE_POINTS)into: Sbar_Goods from distance_stats;
		select sum(prop_bads*MAX_SCORE_POINTS)into: Sbar_bads from distance_stats;
		select sum (prop_bads*MAX_SCORE_POINTS*MAX_SCORE_POINTS) into: SI_sq_bads  from distance_stats; 
		select sum (prop_goods*MAX_SCORE_POINTS*MAX_SCORE_POINTS) into: SI_sq_goods from distance_stats;
		select sum (NO_OF_RECORDS_ACTUAL) into:Total_acc from &Input;
		select sum (No_Of_Actual_Bads) into:Bads from &Input;
		select sum (NO_OF_RECORDS_ACTUAL-No_Of_Actual_Bads) into:Goods from &Input;
		select sum(B)  into :INFO from Distance_stats;
		select sum(A)  into :KL from Distance_stats;
		
		/* Start of CS4.3 HF2 */

/*This is statistics are no more caculated in this macro. They have invidual macros*/
/*		select max(%sysfunc(sasmsg(smd_ds.bismsg,crs.measure_nm.measure_nm_ks.1, noquote))) format=&CS_PERC_FMT. into :KS from Distance_stats;*/
/*		select 1-sum(roc1) format=&CS_PERC_FMT. into :ROC from Distance_stats;*/
/*		select 1-2*sum(roc1) format=&CS_PERC_FMT. into :AR from Distance_stats;*/

/* End of CS4.3 HF2 */ 
quit; 
%put info=*********&info***********************;
data &Diststat;
/* Start of CS4.3 HF2 */
/*The extra format of Percentage6.2 need not require */
		ph = (1.0 - (&cum_prob_prev + ((&Median - &score_Prev)/(&score_Next - &score_Prev))* &prob_next));
		Var_bad =  &SI_sq_bads - (&Sbar_bads * &Sbar_bads); 
		Var_good = &SI_sq_goods - (&Sbar_goods* &Sbar_goods);
		ds= ABS(&Sbar_Goods - &Sbar_bads)/SQRT( (&Goods * Var_good + &bads * var_bad)/ &Total_acc);
/*		PH = put(PH, &CS_PERC_FMT.);*/
/*		D = put(D, &CS_PERC_FMT.);*/
		/*%sysfunc(sasmsg(smd_ds.bismsg,crs.measure_nm.measure_nm_ph.1, noquote))=
%sysfunc(sasmsg(smd_ds.bismsg,crs.measure_nm.measure_nm_ph.1, noquote));
		%sysfunc(sasmsg(smd_ds.bismsg,crs.measure_nm.measure_nm_d.1, noquote))=
%sysfunc(sasmsg(smd_ds.bismsg,crs.measure_nm.measure_nm_d.1, noquote));*/
		is= &INFO;
		kl  =&KL;

/*		%sysfunc(sasmsg(smd_ds.bismsg,crs.measure_nm.measure_nm_roc.1, noquote)) = input(%sysfunc(ktrim(%sysfunc(kleft("&ROC")))),&CS_PERC_FMT.);*/
/*		%sysfunc(sasmsg(smd_ds.bismsg,crs.measure_nm.measure_nm_ar.1, noquote)) =input(%sysfunc(ktrim(%sysfunc(kleft("&AR")))),&CS_PERC_FMT.);*/
/*		%sysfunc(sasmsg(smd_ds.bismsg,crs.measure_nm.measure_nm_ks.1, noquote)) = input(%sysfunc(ktrim(%sysfunc(kleft("&KS")))),&CS_PERC_FMT.);*/
/* End of CS4.3 HF2 */
		drop Var_bad Var_good;
run;

proc transpose data = &Diststat out = &Diststat ;
		var _all_;
quit;
%return;

%if &err_code ne %then %do;
%put WARNING: &err_code.;
%end;
/*****************************************************************/
%Error_Handler:
%csbmva_defdata(input_ds=&input,stat='Distance',/*i18NOK:LINE */
		out_graph_ds =,output_ds = ,out_stat_ds=&diststat);
		
%mend csbmva_distance_stats;
