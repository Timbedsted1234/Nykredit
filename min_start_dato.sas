proc fedsql  sessref=mysession;
select 	min(start_dato) as mininmum_dato, 
		max(slut_dato) as maksimum_dato

	from KKM.PRGD_STAMOPL_HIST
;


quit;
