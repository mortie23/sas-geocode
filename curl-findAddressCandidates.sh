
#!/bin/bash

curl --location --request GET 'https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/findAddressCandidates?f=json&singleLine=4730%20Crystal%20Springs%20Dr,%20Los%20Angeles,%20CA%2090027&outFields=Match_addr,Addr_type'
