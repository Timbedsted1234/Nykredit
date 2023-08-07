/*************************************************
	NAME: Start_dato_start_dttm_conv.sas
	DESC:	Code to transform SAS dat var: startdato to
			SAS datetime var dtid

**************************************************/
data one;        
	start_dato='09feb21'd;                                                                                                                       
   dtid=dhms(start_dato, 15, 30, 15);                                                                                                     
   put dtid;                                                                                                                              
   put dtid datetime.;       

   put start_dato;
	put start_dato date9.;                                                                                                             
                                                                                                                         
run;