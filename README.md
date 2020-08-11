# SAS geocode

Use SAS and some APIs to geocode some addresses.

## Prereqs

### Using WPS to replicate SAS runtime

You may have an enterprise instance of SAS and an Enterprise instance of ESRI APIs, but want to develop offline a solution.  ESRI have free APIs for development use.  SAS has SAS university, or you can use WPS.  

Get the community edition.  

[Download](https://www.worldprogramming.com/try-or-buy/editions/)

### Using Postman

Install Postman:

[Download](https://www.postman.com/downloads/)

## This easy free one

This method uses the publicly available ESRI API to find address candidates.  
At an enterprise you may have an internal version of this API?  

![Find Address Candidates](media/postman-findAddressCandidates.png)

GET: `https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/findAddressCandidates`  
Parameters: 
```ini
f='json'
singleLine='4730 Crystal Springs Dr, Los Angeles, CA 90027'
outFields='Match_addr,Addr_type'
```

#### Response

```json
{
  "spatialReference": {
    "wkid": 4326,
    "latestWkid": 4326
  },
  "candidates": [
    {
      "address": "4730 Crystal Springs Dr, Los Angeles, California, 90027",
      "location": {
        "x": -118.27290099965077,
        "y": 34.120139998439768
      },
      "score": 100,
      "attributes": {
        "Match_addr": "4730 Crystal Springs Dr, Los Angeles, California, 90027",
        "Addr_type": "PointAddress"
      },
      "extent": {
        "xmin": -118.27390099965078,
        "ymin": 34.119139998439771,
        "xmax": -118.27190099965077,
        "ymax": 34.121139998439766
      }
    },
    {
      "address": "4730 Crystal Springs Rd, Los Angeles, California, 90027",
      "location": {
        "x": -118.29234497561468,
        "y": 34.140624544224202
      },
      "score": 98.040000000000006,
      "attributes": {
        "Match_addr": "4730 Crystal Springs Rd, Los Angeles, California, 90027",
        "Addr_type": "StreetAddress"
      },
      "extent": {
        "xmin": -118.29334497561469,
        "ymin": 34.139624544224205,
        "xmax": -118.29134497561468,
        "ymax": 34.1416245442242
      }
    },
    {
      "address": "4730 Crystal Springs Rd, Los Angeles, California, 90027",
      "location": {
        "x": -118.29227308293807,
        "y": 34.140516730329004
      },
      "score": 98.040000000000006,
      "attributes": {
        "Match_addr": "4730 Crystal Springs Rd, Los Angeles, California, 90027",
        "Addr_type": "StreetAddress"
      },
      "extent": {
        "xmin": -118.29327308293807,
        "ymin": 34.139516730329007,
        "xmax": -118.29127308293806,
        "ymax": 34.141516730329002
      }
    }
  ]
}
```

### Now with SAS

Here is a way to do it manually. Surely you have a list of addresses in a table/file/dataset and you want to loop through these and generate the URL from the input data.  
So far this example hasn't built this level of automation.  Pull requests welcome.  

```sas
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
```

## Multiple Addresses (nested JSON input)

This method uses the publicly available ESRI API to geocode addresses in batch.  
It requires you to sign up for a developer account to get a token.  

![Geocode Address](media/postman-geocodeAddresses.png)

For this one we submit a POST request with a body using the `x-www-form-urlencoded` method.  

GET: `https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/geocodeAddresses`  
Sample Body: 
```ini
token='<your-token-goes-here>'
f='json'
addresses='<your-json-goes-here>'
```
Sample Addresses:
```json
{
  "records": [
    {
      "attributes": {
        "OBJECTID": 1,
        "Address": "380 New York St",
        "Neighborhood": "",
        "City": "Redlands",
        "Subregion": "",
        "Region": "CA"
      }
    },
    {
      "attributes": {
        "OBJECTID": 2,
        "Address": "1 World Way",
        "Neighborhood": "",
        "City": "Los Angeles",
        "Subregion": "",
        "Region": "CA"
      }
    }
  ]
}
```

#### Response

```json
{
  "spatialReference": {
    "wkid": 4326,
    "latestWkid": 4326
  },
  "locations": [
    {
      "address": "380 New York St, Redlands, California, 92373",
      "location": {
        "x": -117.19487199399998,
        "y": 34.057237000000043
      },
      "score": 100,
      "attributes": {
        "ResultID": 1,
        "Loc_name": "World",
        "Status": "M",
        "Score": 100,
        "Match_addr": "380 New York St, Redlands, California, 92373",
        "LongLabel": "380 New York St, Redlands, CA, 92373, USA",
        "ShortLabel": "380 New York St",
        "Addr_type": "PointAddress",
        "Type": "",
        "PlaceName": "",
        "Place_addr": "380 New York St, Redlands, California, 92373",
        "Phone": "",
        "URL": "",
        "Rank": 20,
        "AddBldg": "",
        "AddNum": "380",
        "AddNumFrom": "",
        "AddNumTo": "",
        "AddRange": "",
        "Side": "",
        "StPreDir": "",
        "StPreType": "",
        "StName": "New York",
        "StType": "St",
        "StDir": "",
        "BldgType": "",
        "BldgName": "",
        "LevelType": "",
        "LevelName": "",
        "UnitType": "",
        "UnitName": "",
        "SubAddr": "",
        "StAddr": "380 New York St",
        "Block": "",
        "Sector": "",
        "Nbrhd": "",
        "District": "",
        "City": "Redlands",
        "MetroArea": "",
        "Subregion": "San Bernardino County",
        "Region": "California",
        "RegionAbbr": "CA",
        "Territory": "",
        "Zone": "",
        "Postal": "92373",
        "PostalExt": "8100",
        "Country": "USA",
        "LangCode": "ENG",
        "Distance": 0,
        "X": -117.19567674081553,
        "Y": 34.05723247400357,
        "DisplayX": -117.19487199429184,
        "DisplayY": 34.057237000231282,
        "Xmin": -117.19587199429185,
        "Xmax": -117.19387199429184,
        "Ymin": 34.056237000231285,
        "Ymax": 34.05823700023128,
        "ExInfo": ""
      }
    },
    {
      "address": "1 World Way, Los Angeles, California, 90045",
      "location": {
        "x": -118.39846814499998,
        "y": 33.94432871600003
      },
      "score": 100,
      "attributes": {
        "ResultID": 2,
        "Loc_name": "World",
        "Status": "M",
        "Score": 100,
        "Match_addr": "1 World Way, Los Angeles, California, 90045",
        "LongLabel": "1 World Way, Los Angeles, CA, 90045, USA",
        "ShortLabel": "1 World Way",
        "Addr_type": "StreetAddress",
        "Type": "",
        "PlaceName": "",
        "Place_addr": "1 World Way, Los Angeles, California, 90045",
        "Phone": "",
        "URL": "",
        "Rank": 20,
        "AddBldg": "",
        "AddNum": "1",
        "AddNumFrom": "1",
        "AddNumTo": "99",
        "AddRange": "1-99",
        "Side": "R",
        "StPreDir": "",
        "StPreType": "",
        "StName": "World",
        "StType": "Way",
        "StDir": "",
        "BldgType": "",
        "BldgName": "",
        "LevelType": "",
        "LevelName": "",
        "UnitType": "",
        "UnitName": "",
        "SubAddr": "",
        "StAddr": "1 World Way",
        "Block": "",
        "Sector": "",
        "Nbrhd": "Westchester",
        "District": "",
        "City": "Los Angeles",
        "MetroArea": "Los Angeles Metro Area",
        "Subregion": "Los Angeles County",
        "Region": "California",
        "RegionAbbr": "CA",
        "Territory": "",
        "Zone": "",
        "Postal": "90045",
        "PostalExt": "",
        "Country": "USA",
        "LangCode": "ENG",
        "Distance": 0,
        "X": -118.39846814543318,
        "Y": 33.944328715953219,
        "DisplayX": -118.39846814543318,
        "DisplayY": 33.944328715953219,
        "Xmin": -118.39946814543319,
        "Xmax": -118.39746814543318,
        "Ymin": 33.943328715953221,
        "Ymax": 33.945328715953217,
        "ExInfo": ""
      }
    }
  ]
}
```

### Now with SAS

I really have no clue if there is an easier way to build up the input to this one, but hey! It works.  

```sas

*  Get the API Token;
%include "geocode\env.sas";

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
```