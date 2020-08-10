*
Author: Christopher Mortimer
Date:   2020-06-18
Desc:   Calling a geocoding API

Notes:
		Old: http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/findAddressCandidates?<PARAMETERS>
		New: https://developers.arcgis.com/features/geocoding/
		New: https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/findAddressCandidates
		     ?f=json 
		     &singleLine=4730%20Crystal%20Springs%20Dr,%20Los%20Angeles,%20CA%2090027
		     &outFields=Match_addr,Addr_type
;
*
https://communities.sas.com/t5/SAS-Programming/How-to-make-a-PROC-HTTP-Post-request-by-passing-a-JSON-message/td-p/476946
;

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

*	Make the call;
filename fac "&pwd.\findAddressCandidates.json" lrecl=100000000;
filename fac_h "&pwd.\findAddressCandidates.header";
proc http 
 method="GET"
 url='https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/findAddressCandidates?f=json&singleLine=4730%20Crystal%20Springs%20Dr,%20Los%20Angeles,%20CA%2090027&outFields=Match_addr,Addr_type'
 out=fac
 headerout=fac_h;
run;
