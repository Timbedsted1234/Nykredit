%macro client_credentials_logon(VIYA, TOKEN_FILEREF);
  %local CLIENT_ID CLIENT_SECRET;

  %let CLIENT_ID=abd-mas-rest;
  %let CLIENT_SECRET=CNgNMXFqx4HVFdhJEPjsVVska;

  filename out temp;
  proc http
    method='POST'
    url="%superq(VIYA)/SASLogon/oauth/token"
    webusername="%superq(CLIENT_ID)"
    webpassword="%superq(CLIENT_SECRET)"
    in='grant_type=client_credentials'
    out=out
    ;
    headers 'Content-type'='application/x-www-form-urlencoded';
  quit;
  %prochttp_check_return(200);

  libname out json fileref=out;

  data _null_;
    set out.root;
    fid = fopen(symget('TOKEN_FILEREF'), 'o', 0, 'b');
    rc = fput(fid, strip(access_token));
    rc = fwrite(fid);
    rc = fclose(fid);
  run;

  libname out clear;
  filename out clear;
%mend;