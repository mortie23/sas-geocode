*
Author: Christopher Mortimer
Date:   2020-08-10
Desc:   Calling ESRI geocode addresses API
;

*  Get the API Token;
%include "geocode\env.sas";

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

* Build the in;
filename indata temp;
data addresses;
  length jsondata $32767. urldata $32767. putString $32767.;
  file indata;
  jsondata='
{"records":[{"attributes":{"OBJECTID":1,"Address":"380 New York St","Neighborhood":"","City":"Redlands","Subregion":"","Region":"CA"}}
,{"attributes":{"OBJECTID":2,"Address":"1 World Way","Neighborhood":"","City":"Los Angeles","Subregion":"","Region":"CA"}}]}';
     urldata=urlencode(strip(jsondata));
     f='pjson';
  category='';
  sourceCountry='';
  outSR='';
  putString=cats('f=',f,'&token=',token,'&addresses=',urldata,'&category=',category,'&sourceCountry=',sourceCountry,'&outSR=',outSR);
  put putString;
run;
data _null_;
  infile indata;
  input;
  put _infile_;
run;

*	Make the call;
filename ga "&pwd.\geocodeAddresses.json" lrecl=100000000;
filename ga_h "&pwd.\geocodeAddresses.header";
proc http 
 method="POST"
 url='https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/geocogeAddresses?'
 in=indata
 out=ga
 headerout=ga_h;
 headers "Content-Type"="application/x-www-form-urlencoded";
run;
