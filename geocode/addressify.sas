*  Get the current working directory (note this is for windows);
filename pwd pipe "echo %cd%";
data _null_;
  infile pwd;
  input;
  put _infile_;
  pwd=tranwrd(_infile_,'0d'x,'');
  call symputx('pwd',pwd);
run;
%put pwd: &pwd.;
libname geocode "&pwd.";

%include "./geocode/api-key.sas";

%let _service=https://api.addressify.com.au/addresspro/info?;
%let _api_key=&api_key.;
%let _term=%sysfunc(urlencode(%str(1 smith street, kambah act 2902)));
%put &_term.;

*  Build the service call;
data _null_;
  service="&_service.";
  api_key="&_api_key.";
  term="&_term.";
  service_call=service||'api_key='||api_key||'&term='||term;
  call symputx('service_call',service_call);
run;
  
*  Local file handles;
filename resp "&pwd.\resp.json" lrecl=100000000;
filename resp_h "&pwd.\resp-h.json";
*  Use HTTP get to pull to local;
proc http
  url="&service_call."
  method="GET"
  out=resp
  headerout=resp_h;
run;