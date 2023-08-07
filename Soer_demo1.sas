/************************************************************
	NAME:	Soer_demo1.sas
	DESC:	Simple eksempler på SAS kode i SAS Studio 
*************************************************************/
data class;
	set sashelp.class;
run;

symbol1 i=rl color=red value=dot;
proc gplot data=class;
	plot height*weight;
run;
quit;
