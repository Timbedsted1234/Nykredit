options LINESIZE=MAX;

%let VIYA_TEST=https://abdtest.ondemand.sas.com;
%let VIYA_PROD=https://abdprod.ondemand.sas.com;

%let CAS_FILES = /ABD/DevOps/CAS;
%let MAS_FILES = /ABD/DevOps/MAS;

%let CAS_DESTINATION = stdPublishDest_CAS;
%let MAS_DESTINATION = maslocal;

/* Load macros */
filename _macro_ filesrvc folderpath='/ABD/DevOps/saspgm';
%include _macro_(deploy_to_test.sas);
%include _macro_(deploy_to_production.sas);
%include _macro_(get_module_code.sas);
%include _macro_(publish_module.sas);
%include _macro_(prochttp_check_return.sas);
%include _macro_(client_credentials_logon.sas);
filename _macro_ clear;
