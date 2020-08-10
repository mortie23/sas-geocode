#!/usr/bin/python3

import requests
import os
from dotenv import load_dotenv
import urllib.parse

# Environment Variable handling
load_dotenv()
token = os.getenv("token")
# JSON URL handling
addressesJson = '''
{"records":[{"attributes":{"OBJECTID":1,"Address":"380 New York St","Neighborhood":"","City":"Redlands","Subregion":"","Region":"CA"}}
,{"attributes":{"OBJECTID":2,"Address":"1 World Way","Neighborhood":"","City":"Los Angeles","Subregion":"","Region":"CA"}}]}
'''
addressesUrl = urllib.parse.quote(addressesJson)

url = "https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/geocodeAddresses"

payload = 'token=' + token \
  + '&addresses=' + addressesUrl \
  + '&f=json'
headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
}

response = requests.request("POST", url, headers=headers, data=payload)

print(response.text.encode('utf8'))
