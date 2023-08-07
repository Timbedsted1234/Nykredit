filename saspgm filesrvc folderpath='/ABD/DevOps/saspgm';
%include saspgm(autoexec.sas);
filename saspgm clear;

/* Deploy live_scoring til MAS TEST */
%deploy_to_test(/ABD/decisions/live/Live scoring, live_scoring, MAS);

/* Deploy live_scoring til MAS PROD */
*%deploy_to_production(live_scoring, MAS);
