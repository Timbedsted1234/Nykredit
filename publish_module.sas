%macro publish_module(FLOW_NAME, DESTINATION, VIYA, OAUTH_BEARER);
  %local CODE_FOLDER STATE PUBLISH_URI PUBLISH_LOG_URI;

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

  filename payload filesrvc folderpath="%superq(CODE_FOLDER)" filename="%superq(FLOW_NAME)_publish.json" lrecl=4194304;
  filename out temp;
  proc http
    method='POST'
    url="%superq(VIYA)/modelPublish/models"
    oauth_bearer=%superq(OAUTH_BEARER)
    query=('force'='true' 'reloadModelTable'='true')
    in=payload
    out=out
    ;
    headers
      'Accept'='application/vnd.sas.models.publishing.publish+json'
      'Content-type'='application/vnd.sas.models.publishing.request.asynchronous+json'
    ;
  quit;
  %prochttp_check_return(201);
  filename payload clear;

  libname out json fileref=out;
  proc sql noprint;
    select uri into:PUBLISH_URI     trimmed from out.items_links where rel='self';
    select uri into:PUBLISH_LOG_URI trimmed from out.items_links where rel='publishingLog';
    select state into :STATE        trimmed from out.items;
  quit;
  libname out clear;
  filename out clear;
  %put &=STATE;

  %do %while (%superq(STATE)=pending);
    data _null_;
      rc = sleep(2000);
    run;
    filename out temp;
    proc http
      method='GET'
      url="%superq(VIYA)%superq(PUBLISH_URI)"
      oauth_bearer=%superq(OAUTH_BEARER)
      out=out
      ;
    quit;
    %prochttp_check_return(200);
    libname out json fileref=out;
    proc sql noprint;
      select state into :STATE trimmed from out.root;
    quit;
    libname out clear;
    filename out clear;
    %put &=STATE;
  %end;

  filename out temp;
  proc http
    method='GET'
    url="%superq(VIYA)%superq(PUBLISH_LOG_URI)"
    oauth_bearer=%superq(OAUTH_BEARER)
    out=out
    ;
  quit;
  %prochttp_check_return(200);
  libname out json fileref=out;
  data _null_;
    set out.root;
    putlog 'c2a0'x;
    putlog 'Publish log:';
    putlog 'c2a0'x;
    do i = 1 to countw(log, '0a'x);
      line = scan(log, i, '0a'x);
      putlog line;
    end;
    putlog 'c2a0'x;
  run;
  libname out clear;
  filename out clear;

  %if %superq(DESTINATION)=MAS %then %do;
    %put ;
    %put MAS endpoint:;
    %put %superq(VIYA)/microanalyticScore/modules/%superq(FLOW_NAME)/steps/execute;
    %put ;
  %end;
%mend;
