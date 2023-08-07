%macro get_module_code(DECISION_PATH, FLOW_NAME, DESTINATION, VIYA, OAUTH_BEARER);
  %local FOLDER_PATH FILTER DECISION_URI CODE_FOLDER DESTINATION_NAME QUERY;

  data _null_;
    destination = strip(upcase(symget('DESTINATION')));
    call symputx('DESTINATION', destination);
  run;

  %if %superq(DESTINATION) eq MAS %then %do;
    %let DESTINATION_NAME=%superq(MAS_DESTINATION);
    %let CODE_FOLDER=%superq(MAS_FILES);
    %let QUERY = (
      'rootPackageName'="%superq(FLOW_NAME)"
      'lookupMode'='PACKAGE'
      'traversedPathFlag'='false'
      'isGeneratingRuleFiredColumn'='false'
      'codeTarget'='microAnalyticService'
    );
  %end;
  %else %if %superq(DESTINATION) eq CAS %then %do;
    %let DESTINATION_NAME=%superq(CAS_DESTINATION);
    %let CODE_FOLDER=%superq(CAS_FILES);
    %let QUERY = (
      'lookupMode'='FORMAT'
      'traversedPathFlag'='false'
      'isGeneratingRuleFiredColumn'='false'
      'codeTarget'='casFull'
    );
  %end;
  %else %do;
    %put ERROR: DESTINATION must be MAS or CAS.;
    %abort cancel;
  %end;

  /*********************************/
  /* Get decision URI              */
  /*********************************/
  data _null_;
    length decision_path decision_name folder_path filter $512;
    decision_path = strip(symget('DECISION_PATH'));
    decision_name = scan(decision_path, -1, '/');
    folder_path = substr(decision_path, 1, length(decision_path) - length(decision_name));
    filter = cats('and(eq(name,', quote(trim(decision_name)), '),eq(contentType,"decision"))');
    call symputx('FOLDER_PATH', folder_path);
    call symputx('FILTER', filter);
  run;

  filename out temp;
  proc http
    method='GET'
    url="%superq(VIYA)/folders/folders/@item"
    query=('path'="%superq(FOLDER_PATH)")
    oauth_bearer=%superq(OAUTH_BEARER)
    out=out
    ;
  quit;
  %prochttp_check_return(200);

  libname out json fileref=out;
  proc sql noprint;
    select uri into:MEMBERS_URI trimmed from out.links where rel='members';
  quit;
  libname out clear;
  filename out clear;

  filename out temp;
  proc http
    method='GET'
    url="%superq(VIYA)%superq(MEMBERS_URI)"
    query=('filter'="%superq(FILTER)")
    oauth_bearer=%superq(OAUTH_BEARER)
    out=out
    ;
  quit;
  %prochttp_check_return(200);

  libname out json fileref=out;
  proc sql noprint;
    select uri into:DECISION_URI trimmed from out.items;
  quit;
  libname out clear;
  filename out clear;

  %put &=DECISION_URI;

  /*********************************/
  /* Get decision DS2 code         */
  /*********************************/
  filename tmp_ds2 temp lrecl=4194304;
  proc http
    method='GET'
    url="%superq(VIYA)%superq(DECISION_URI)/code"
    query=&QUERY.
    oauth_bearer=%superq(OAUTH_BEARER)
    out=tmp_ds2
    ;
  quit;
  %prochttp_check_return(200);

  /*********************************/
  /* Create publish JSON           */
  /*********************************/
  filename tmp_json temp lrecl=4194304;
  filename py_code temp;
  data _null_;
   file py_code;
   put "from pathlib import Path";
   put "from datetime import datetime";
   put "import json";
   put "utc_now = datetime.utcnow().isoformat(sep=' ', timespec='seconds')";
   put "flow_name = SAS.symget('FLOW_NAME')";
   put "viya = SAS.symget('VIYA')";
   put "destination_name = SAS.symget('DESTINATION_NAME')";
   put "decision_path = SAS.symget('DECISION_PATH')";
   put "ds2_file = SAS.sasfnc('pathname', 'tmp_ds2')";
   put "json_file = SAS.sasfnc('pathname', 'tmp_json')";
   put "ds2_code = Path(ds2_file).read_text()";
   put "publish_request = {";
   put "  'name': flow_name,";
   put "  'destinationName': destination_name,";
   put "  'notes': f'{utc_now} UTC. Sourced from {viya} decision: {decision_path}',";
   put "  'modelContents': [{";
   put "    'overwrite'   : True,";
   put "    'modelName'   : flow_name,";
   put "    'codeType'    : 'ds2',";
   put "    'code'        : ds2_code,";
   put "    'publishLevel': 'decision',";
   put "  }]";
   put "}";
   put "Path(json_file).write_text(json.dumps(publish_request, indent=1))";
  run;

  proc python restart terminate infile=py_code;
  quit;
  filename py_code clear;

  /*************************************/
  /* Copy ds2+json file to SAS content */
  /*************************************/
  filename ds2  filesrvc folderpath="%superq(CODE_FOLDER)" filename="%superq(FLOW_NAME).ds2" lrecl=4194304;
  filename json filesrvc folderpath="%superq(CODE_FOLDER)" filename="%superq(FLOW_NAME)_publish.json" lrecl=4194304;

  data _null_;
    rc = fcopy('tmp_ds2', 'ds2');
    if rc=0 then putlog "Generated %superq(CODE_FOLDER)/%superq(FLOW_NAME).ds2 from %superq(DECISION_PATH)";
    rc = fcopy('tmp_json', 'json');
    if rc=0 then putlog "Generated %superq(CODE_FOLDER)/%superq(FLOW_NAME)_publish.json from %superq(DECISION_PATH)";
  run;

  filename tmp_ds2 clear;
  filename tmp_json clear;
  filename ds2 clear;
  filename json clear;
%mend;
