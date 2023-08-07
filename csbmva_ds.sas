/*
Macro Name	: csbmva_ds
Function	: This macro calculates various distance measures like AUC, AR, 1-PH, D, KS, KL, Information statistic(I)
Created by	: BIS Team
Date		: Aug 07, 2010
SAS Version	:  9.2


Parameters	: 

input_ds		: Name of the input data set 
output_ds	: Name of the data set which stores data for graph or measure values.
flag        : It takes 1 or 2 .the flag =1 means that output_ds  stores data for graphs on the screen. 
                 the flag =2 means that output_ds stores data for measure values.
 
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
No_of_events_actual	Number		Default Formatting	
--------------------------------------------------------------------------


Output Dataset Format:

output_ds:(when stores data for measure value)
--------------------------------------------------------------------------
Name					Type	Format
--------------------------------------------------------------------------
_NAME_			Character	Default Format
VALUE*			Numeric		Default Format
------------------------------------------------------------------------

Output Dataset Format:

output_ds:(when stores data for graph)
--------------------------------------------------------------------------
Name					Type	Format
--------------------------------------------------------------------------
Pool_Seq_no       Numeric		Default Format
Max_Score_Points  Numeric		Default Format
Prop_bads_act     Numeric		Default Format
Prop_bads_est     Numeric		Default Format
Prop_goods        Numeric		Default Format


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
3. For all output datasets it is assumend that
	a. it has valid name.
	b. Macro has necessary required rights to create the datasets with specified name @ specified location.
	c. Name of the data-set is unique OR if dataset with similar name already exists then it can be safely overwritten.

*/
options mlogic mprint;
%macro csbmva_ds (input_ds=, output_ds=, flag=,max_range_value_colname=,est_result_col_name=,seq_no_colname=,seq_name_colname=,risk_incr_with_value_incr_flg=);

%if &flag= 1 %then %do;
data _NULL_;

name=put(time(),mmss8.1);

name1=kscan(name,1,":.");

name2=kscan(name,2,":.");

name3=kscan(name,3,":.");

name4=ktrim(kleft(name1))||ktrim(kleft(name2))||ktrim(kleft(name3));/*i18NOK:LINE */

call symput('log_name',"&LOG_PATH_CS"||"&sysmacroname"||ktrim(kleft(name4))||".log");/*i18NOK:LINE */

run;

data input_data;
set &input_ds;
if &est_result_col_name=0 then &est_result_col_name= &EST_PDVAL_FOR0.;
if &est_result_col_name=1 then &est_result_col_name= &EST_PDVAL_FOR1.;
run;

proc sql noprint;
create table &output_ds as 
select &seq_no_colname., &max_range_value_colname.,
No_of_events_actual/Sum(No_of_events_actual) as Prop_events_act, 
(no_of_records_actual - No_of_events_actual) /(Sum(no_of_records_actual)- Sum(No_of_events_actual))  
as Prop_non_events,
 (&est_result_col_name.*no_of_records_actual)/(sum(&est_result_col_name.*no_of_records_actual)) as prop_events_est
from input_data order by &seq_no_colname., &max_range_value_colname. ; 
quit;




%end;

%if &flag =2 %then %do;


%let err_code=;
/*****************************************************************/
%csbmva_alldefaults_nodefaults(&input_ds,NO_OF_RECORDS_ACTUAL,No_of_events_actual, err_code);
%if (&err_code ne 'NONE')%then %goto Error_Handler;/*i18NOK:LINE */
/*****************************************************************/
proc sql noprint;
	select sum(&max_range_value_colname.) into: sum_score_points
	from &input_ds;
quit;
%if &sum_score_points=. %then %do;

proc sql noprint;
		create table Distance_stats as 
		select &max_range_value_colname., No_of_events_actual/Sum(No_of_events_actual) as Prop_events, 
(NO_OF_RECORDS_ACTUAL - No_of_events_actual) /(Sum(NO_OF_RECORDS_ACTUAL)- Sum(No_of_events_actual))  
as Prop_non_events from &Input_ds order by &max_range_value_colname. ; 
quit;

proc univariate data = &Input_ds noprint;
	   var &max_range_value_colname.;
	   freq No_of_events_actual; 
	   output out=Work.Median
	          median=Median;
run;
/*****************************************************************/
%csbmva_errorhandler(err_code);

%if (&err_code ne 'NONE')%then %goto Error_Handler;/*i18NOK:LINE */
/*****************************************************************/

data Distance_stats; 
	retain	cum_prop_events 0
			cum_prop_nevents 0 
			ks  0 ;	
			format a b 8. ;
	set Distance_stats;
		cum_prop_events = Sum(cum_prop_events, prop_events);
		cum_prop_nevents = Sum(cum_prop_nevents, prop_non_events);
		if prop_non_events > 0 and prop_events > 0 then 
		do;
			A = prop_events*log(prop_events/prop_non_events);
			B = (prop_events -prop_non_events)*log(prop_events/prop_non_events);
		end;
		else 
		do;
			A = .;
			B = .;
		end;
		ks = cum_prop_events-cum_prop_nevents;
run;
proc sql;
	select sum(B)  into :INFO from Distance_stats;
	select sum(A)  into :KL from Distance_stats;
quit;
data &output_ds;
		ph = .;
		ds= .;
		is= &INFO;
		kl  =&KL;

%end;
%else %do;
proc sql noprint;
		create table Distance_stats as 
		select &max_range_value_colname., No_of_events_actual/Sum(No_of_events_actual) as Prop_events, 
(NO_OF_RECORDS_ACTUAL - No_of_events_actual) /(Sum(NO_OF_RECORDS_ACTUAL)- Sum(No_of_events_actual))  
as Prop_non_events from &Input_ds order by &max_range_value_colname. ; 
quit;

proc univariate data = &Input_ds noprint;
	   var &max_range_value_colname.;
	   freq No_of_events_actual; 
	   output out=Work.Median
	          median=Median;
run;
/*****************************************************************/
%csbmva_errorhandler(err_code);

%if (&err_code ne 'NONE')%then %goto Error_Handler;/*i18NOK:LINE */
/*****************************************************************/

data Distance_stats; 
	retain	cum_prop_events 0
			cum_prop_nevents 0 
			ks  0 ;	
			format a b 8. ;
	set Distance_stats;
		cum_prop_events = Sum(cum_prop_events, prop_events);
		cum_prop_nevents = Sum(cum_prop_nevents, prop_non_events);
		if prop_non_events > 0 and prop_events > 0 then 
		do;
			A = prop_events*log(prop_events/prop_non_events);
			B = (prop_events -prop_non_events)*log(prop_events/prop_non_events);
		end;
		else 
		do;
			A = .;
			B = .;
		end;
		ks = cum_prop_events-cum_prop_nevents;
run;

data Distance_stats;
  set Distance_stats;
  if &max_range_value_colname. =. then delete;
run;

data distance_stats;
set distance_stats;
cum_prop_nevents1=lag1(cum_prop_nevents);
run;


%csbmva_errorhandler(err_code);

%if (&err_code ne 'NONE')%then %goto Error_Handler; /* I18NOK:LINE */
/*****************************************************************/
data Distance_stats;
	set Distance_stats;
	&max_range_value_colname.=input(put(&max_range_value_colname.,20.5),16.);
	roc1 = prop_events*sum(cum_prop_nevents,cum_prop_nevents1)/2;
run;

%let score_prev=0;
%let score_next=0;
proc sql  noprint;
		select Median format=20.4 into : Median from work.Median;
		select min(&max_range_value_colname.) format=20.4, max(&max_range_value_colname.) format=20.4 into :min_score, :max_score from Distance_stats;
		%put median=&median max=&max_score min=&min_score;
 %if %sysevalf(&median = &min_score) %then %do;
			%let score_prev=&median;
			select max(cum_prop_nevents) into : cum_prob_prev from Distance_stats where &max_range_value_colname. = &Median ;
		%end;
		%else %do;
			select max(&max_range_value_colname.) format=20.4 into : score_Prev from Distance_stats where &max_range_value_colname. < &Median; 
			select max(cum_prop_nevents) into : cum_prob_prev from Distance_stats where &max_range_value_colname. < &Median ;
		%end;
 %if %sysevalf(&median = &max_score) %then %let score_next=&median;
		%else %do;
			select min(&max_range_value_colname.) format=20.4 into : score_Next from Distance_stats where &max_range_value_colname. > &Median; 
		%end;
		select prop_non_events into : prob_next from Distance_stats where &max_range_value_colname. = &score_next;
		select sum(B) format=&CS_PERC_FMT. from Distance_stats;
quit;
%put median=&median prev=&score_prev next=&score_next prob_next=&prob_next cum_prev=&cum_prob_prev;
proc sql noprint;
		select sum(prop_non_events*&max_range_value_colname.)into: Sbar_Goods from distance_stats;
		select sum(prop_events*&max_range_value_colname.)into: Sbar_bads from distance_stats;
		select sum (prop_events*&max_range_value_colname.*&max_range_value_colname.) into: SI_sq_bads  from distance_stats; 
		select sum (prop_non_events*&max_range_value_colname.*&max_range_value_colname.) into: SI_sq_goods from distance_stats;
		select sum (NO_OF_RECORDS_ACTUAL) into:Total_acc from &Input_ds;
		select sum (No_of_events_actual) into:Bads from &Input_ds;
		select sum (NO_OF_RECORDS_ACTUAL-No_of_events_actual) into:Goods from &Input_ds;
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
data &output_ds;
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
%end;
proc transpose data = &output_ds out = &output_ds ;
		var _all_;
quit;
%return;

%if &err_code ne %then %do;
%put WARNING: &err_code.;
%end;
/*****************************************************************/
%Error_Handler:
%csbmva_defdata(input_ds=&input_ds,stat='Distance',/*i18NOK:LINE */
		out_graph_ds =,output_ds = ,out_stat_ds=&output_ds);

		%end;

%mend csbmva_ds;
