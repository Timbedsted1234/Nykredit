/*
Macro Name	: interpolation
Function	: This function computes validation score for each statistic present in the input data set and 
			  which is mapped to valdiation scale in validation score table.
Created by	: BIS Team
Date		: Apr 07, 2006
SAS Version	: 9.1

Called-by	:Screen showing Information statistic value and Weight of evidence 
			 
Calls		:inter (Internal Macro / Sub Function) 

Parameters	: 

input_ds		: Name of the input data set (Distance Stat data set, where values for Distance Statistic for given data are stored)
validation_score: Name of the data set where all the statistics are mapped to validation scale.
output_ds		: Name of the data set which stores value of validation score for each statistic.

Input Dataset(s) Format:

input_ds
-------------------------------------------------------------------------
Name			Type		Format
------------------------------------------------------------------------
_NAME_			Character	Default Format
VALUE*			Numeric		Default Format
------------------------------------------------------------------------
validation_score
-------------------------------------------------------------------------
Name		Type		Format
------------------------------------------------------------------------
Range		Character	Default Format 
Comment 	Character	Default Format 
Gradings 	Numeric		Default Format
D 			Numeric		Default Format
PH 			Numeric		Default Format
KS 			Numeric		Default Format
AR 			Numeric		Default Format
ROC 		Numeric		Default Format
INFO		Numeric		Default Format
KL			Numeric		Default Format
-----------------------------------------------------------------------------
Output Dataset(s) Format:
output_ds
-------------------------------------------------------------------------
Name			Type		Format
------------------------------------------------------------------------
VALUE*			Numeric		Default Format
Measure_nm		Character 	Default Format;
Grade 			Numeric			7.3;
------------------------------------------------------------------------

Logic:

1. Join the (transposed) input data set with the validation input table. 
2. Corresponding validation score value will be missing for the measure values from input data set.
3. We need to find out these missing values using sas procedures for missing values.
4. Inter macro is called to perform this job. Value obtained from this macro is stored in dataset name stored in output_ds
   along with its measure name actual value.

Notes:
1. It is assumed that data set of specified as input_ds is present and has necessarry required rights.
2. It is assumed that data set of specified as input_ds has valid specified fileds.
3. For all output datasets (Viz output_ds),it is assumend that
	a. it has valid name.
	b. Macro has necessary required rights to create the datasets with specified name @ specified location.
	c. Name of the data-set is unique OR if dataset with similar name already exists then it can be safely overwritten.
*/

%macro csbmva_interpolation(input_ds = ,validation_score=,output_ds=);



%let stat=.;
%let err_code=;
%let grade =.;
/*transposing the input table and adding values to be interploated as missing values*/

proc transpose data = &input_ds  out= temp1;
run;

data value_table;
	set temp1 (drop = _NAME_) &validation_score;
run;

proc sql noprint;
	select count(*) into :num_obs		/* i18nOK:Line */
	from &input_ds;

	select _name_ into :_name_1 - :_name_%sysfunc(ktrim(%sysfunc(kleft(&num_obs))))
	from &input_ds;
quit;

data &output_ds;
	length Measure_nm $15.;
	format Grade &CS_DEC_FMT.;
	stop;
run;

%do col_cnt=1 %to &num_obs;
	%let col_name=&&_name_&col_cnt;
	%put &col_name;
		%let stats = .;

		proc sql noprint;
		select temp1.&col_name into :stats from temp1;
		quit;

		data _null_;
			stat_val=input(strip("&stats"),20.);/*i18NOK:LINE */
			call symput('stats',stat_val);/*i18NOK:LINE */
		run;
		%put stats=&stats;
 

   %let validation_score1 = %sysfunc(kscan(&validation_score,2,"."));
	%if %sysevalf(%str("&stats") Ne %str("."))>0 %then 
		%do;
		%put ************************************&col_name = &stats**********;
/*			proc sql noprint;*/
/*			select gradings into :grade from &validation_score*/
/*			where &validation_score1..&col_name=&stats;*/
/*			quit;*/

			proc sql noprint;
			select gradings into :grade from &validation_score,temp1
			where &validation_score1..&col_name=temp1.&col_name;
			quit;
				
			%if (&grade eq .) %then
			%do;
				proc sql noprint;
				select min(&validation_score1..&col_name)into :MinGrade from &validation_score;
				quit;

			%end;

			%if (&grade eq .) %then
			%do;
				proc sql noprint;
				select max(&validation_score1..&col_name)into :MaxGrade from &validation_score;
				quit;
			%end;

		%if (&grade eq .) %then
		%do;
			%csbmva_interpolation_inter(varname=&col_name,input_ds=value_table,output_ds=valid_val);
/*			proc sql noprint;*/
/*				select gradings into :grade from valid_val*/
/*				where valid_val.&col_name=&stats;*/
/*			quit;*/
			proc sql noprint;
				select gradings format=BEST16. into :grade from valid_val,temp1
				where valid_val.&col_name=temp1.&col_name;
			quit;
/* 			%let grade=%sysfunc(ktrim(%sysfunc(kleft(&grade))));
			%if %str(&grade) eq %str() %then %let grade=.; */
			%if %str(&grade) eq %str() %then %let grade=.;
			%else %do;
				%let grade=%sysfunc(ktrim(%sysfunc(kleft(&grade))));
			%end;
		%end;
	%end;
	proc sql;
		insert into &output_ds values("&col_name",&grade);
	quit;
	%let grade =.;
/*****************************************************************/
%csbmva_errorhandler(err_code);
%if (&err_code ne 'NONE')%then %goto Error_Handler;/*i18NOK:LINE */
/*****************************************************************/
%end;
/* merge input and output tables*/
data temp_out;
merge &output_ds &input_ds;
run;
data &output_ds;
set  temp_out(drop = _name_);
run;
%return;
%if &err_code ne %then %do;
%put WARNING: &err_code.;
%end;
%Error_Handler:
%csbmva_defdata(input_ds=&input_ds,stat='Inter',/*i18NOK:LINE */
		out_graph_ds =,output_ds =&output_ds ,out_stat_ds=);
		


%mend csbmva_interpolation;

/*
Macro Name	: inter
Function	: Finds the missing value using interpolation method.
Created by	: BIS Team
Date		: Apr 07, 2006
SAS Version	: 9.1

Called-by	:Interpolation macro for every measure in the input table.
			 
Calls		: None

Parameters	: 

varname			: Name of the variable for which validation score is to be obtained
input_ds		: Name of the input data set
output_ds		: Name of the data set which stores data for graph of events vs non events.

Input Dataset(s) Format:
input_ds
-------------------------------------------------------------------------
Name		Type		Format
------------------------------------------------------------------------
Range		Character	Default Format 
Comment 	Character	Default Format 
Gradings 	Numeric		Default Format
D 			Numeric		Default Format
PH 			Numeric		Default Format
KS 			Numeric		Default Format
AR 			Numeric		Default Format
ROC 		Numeric		Default Format
INFO		Numeric		Default Format
KL			Numeric		Default Format
-----------------------------------------------------------------------------

Output Dataset(s) Format:
-------------------------------------------------------------------------
Name		Type		Format
------------------------------------------------------------------------
Gradings 	Numeric		Default Format
&varname 	Numeric		Default Format
------------------------------------------------------------------------
&varname can take value D,PH,KS,AR,ROC,INFO,KL

Logic:
1. Subset the dataset with given variables and gradings (Validation score) 
   Note that One value in the validation score will be missing. which we estimate in this macro.
2. Sort the data in assending order on values in column based on variable name. 
   Note:Sorted input is necessary for the proc expand procedure.
3. Using spline (natural)option of proc expand we estimate for missing validation score. 
   Estimated missing value is the corresponding value for actual measure value based on mapping 
   of corresponding to the validation score. 

Notes:
1. It is assumed that data set of specified as input_ds is present and has necessarry required rights.
2. It is assumed that data set of specified as input_ds has valid specified fileds.
3. For all output datasets (Viz output_ds),it is assumend that
	a. it has valid name.
	b. Macro has necessary required rights to create the datasets with specified name @ specified location.
	c. Name of the data-set is unique OR if dataset with similar name already exists then it can be safely overwritten.
4. Variable Name specified in varname should be present in the input data set and it should be of numeric type.
*/

%macro csbmva_interpolation_inter(varname=,input_ds=,output_ds=);



/*%put varname=&varname;*/
data temp_table;
	set &input_ds(keep = &varname Gradings);  /* keep relevant fields*/
run;

proc sort data = temp_table out= temp_table;
	by &varname;
run;
/* proc expand to calculate interpolated value*/
proc expand data=temp_table out=temp method=spline(natural);
	id &varname;
	convert Gradings;
run;
data &output_ds;
set temp;
run;



%mend csbmva_interpolation_inter;
