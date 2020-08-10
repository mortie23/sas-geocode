#!/usr/bin/python3

import requests

url = "https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/findAddressCandidates?f=json&singleLine=4730 Crystal Springs Dr, Los Angeles, CA 90027&outFields=Match_addr,Addr_type"

payload = {}
headers= {}

response = requests.request("GET", url, headers=headers, data = payload)

print(response.text.encode('utf8'))