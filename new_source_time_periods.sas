/********************************************************************
	name: 	new_source_time_periods.sas
	desc:	Create new tiemperiods 4mb, 5bm and 6mb for AL 
			uderdefined scorecards
*********************************************************************/

*  APDM -> WORK *;
filename apdmxpt filesrvc folderpath="/Public" filename= "apdm.xpt" debug=http recfm=n;
proc cimport library=work file=apdmxpt;
run;

data new_source_time_period;
	set work.source_time_period;
	if _n_=1 then stop;
run;
data new_source_time_period;
	 	
Time_Period_Sk=1000003;
		Time_Frequency_Sk=1;
		Time_Period_From=4;
		Time_Period_To=4;
		Time_Period_Cd='4MB';
		Time_Period_Short_Nm='4 Months Back';
		Time_Period_Desc='4 Months Back';
		created_dttm=datetime();
		last_processed_dttm=datetime();
		created_by_user='sdktvb';
		last_processed_by_user='sdktvb';
		output;
		Time_Period_Sk=1000004;
		Time_Frequency_Sk=1;
		Time_Period_From=5;
		Time_Period_To=5;
		Time_Period_Cd='5MB';
		Time_Period_Short_Nm='5 Months Back';
		Time_Period_Desc='5 Months Back';
		created_dttm=datetime();
		last_processed_dttm=datetime();
		created_by_user='sdktvb';
		last_processed_by_user='sdktvb';
		output;		 
run;
proc append data=new_source_time_period  base=apdm.source_time_period force;
run;

* APDM -> SAS STudio *;
filename apdmxpt filesrvc folderpath="/Public" filename="apdm.xpt" debug=http recfm=n;
proc cport library=apdm file=apdmxpt;
run;
