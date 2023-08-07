%macro deploy_to_production(FLOW_NAME, DESTINATION);
  %local CODE_FOLDER;

  data _null_;
    destination = strip(upcase(symget('DESTINATION')));
    call symputx('DESTINATION', destination);
  run;
  %if %superq(DESTINATION) eq MAS %then %do;
    %let CODE_FOLDER=%superq(MAS_FILES);
  %end;
  %else %if %superq(DESTINATION) eq CAS %then %do;
    %let CODE_FOLDER=%superq(CAS_FILES);
  %end;
  %else %do;
    %put ERROR: DESTINATION must be MAS or CAS.;
    %abort cancel;
  %end;

  /*************************************/
  /* Create token for prod             */
  /*************************************/
  filename pr_token temp;
  %client_credentials_logon(&VIYA_PROD., pr_token);

  /*************************************/
  /* Publish to prod                   */
  /*************************************/
  %publish_module(live_scoring, MAS, &VIYA_PROD., pr_token);
  filename pr_token clear;

  /*************************************/
  /* Copy ds2+json file to history     */
  /*************************************/
  data _null_;
    timestamp = prxchange('s/(\d\d\d\d)-(\d\d)-(\d\d)T(\d\d):(\d\d):(\d\d)$/$1$2$3_$4$5$6/io', 1, put(datetime(), IS8601DT19.));
    call symputx('TIMESTAMP', timestamp);
  run;

  filename ds2  filesrvc folderpath="%superq(CODE_FOLDER)" filename="%superq(FLOW_NAME).ds2" lrecl=4194304;
  filename json filesrvc folderpath="%superq(CODE_FOLDER)" filename="%superq(FLOW_NAME)_publish.json" lrecl=4194304;
  filename his_ds2 filesrvc folderpath="%superq(CODE_FOLDER)/history" filename="%superq(TIMESTAMP)_%superq(FLOW_NAME).ds2" lrecl=4194304;
  filename his_json filesrvc folderpath="%superq(CODE_FOLDER)/history" filename="%superq(TIMESTAMP)_%superq(FLOW_NAME)_publish.json" lrecl=4194304;

  data _null_;
    rc = fcopy('ds2', 'his_ds2');
    if rc=0 then putlog "Archived ds2 code as %superq(CODE_FOLDER)/history/%superq(TIMESTAMP)_%superq(FLOW_NAME).ds2";
    rc = fcopy('json', 'his_json');
    if rc=0 then putlog "Archived publish request as %superq(CODE_FOLDER)/history/%superq(TIMESTAMP)_%superq(FLOW_NAME)_publish.json";
  run;

  filename ds2  clear;
  filename json clear;
  filename his_ds2  clear;
  filename his_json clear;
%mend;



