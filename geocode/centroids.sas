*  Use the free python service to get the centroids of suburbs;
%let _service=http://v0.postcodeapi.com.au/suburbs.json?q=;
%let _term=%sysfunc(urlencode(%str(kambah)));
%put &_term.;

*  Build the service call;
data _null_;
  service="&_service.";
  term="&_term.";
  service_call=service||term;
  call symputx('service_call',service_call);
run;
%put &service_call.;

*  Local file handles;
filename cent "&pwd.\centroid.json" lrecl=100000000;
filename cent_h "&pwd.\centroid-h.json";
*  Use HTTP get to pull to local;
proc http
  url="&service_call."
  method="GET"
  out=cent
  headerout=cent_h;
run;