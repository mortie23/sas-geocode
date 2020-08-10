*
Author: Christopher Mortimer
Date:   2020-06-18
Desc:   Calling a geocoding API
;
*
https://communities.sas.com/t5/SAS-Programming/How-to-make-a-PROC-HTTP-Post-request-by-passing-a-JSON-message/td-p/476946
;
%let service=http://dummy.restapiexample.com/api/v1/create;
filename data_in temp;
data _null_;
  file data_in;
  input;
  put _infile_;
datalines;
{"name":"test","salary":"123","age":"23"}
;
run;
filename resp temp;
proc http 
 method="GET"
 url="&service."
 in=data_in
 out=resp; 
run;
data result;
  infile resp dlm='~' lrecl=32767;
  length resp $32767.;
  input resp $;
run;
proc print;
run;


/*
Output
{"status":"success","data":{"name":"test","salary":"123","age":"23","id":57}} 
*/