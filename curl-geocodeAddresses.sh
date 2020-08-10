#!/bin/bash

. .env

curl --location --request POST 'https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/geocodeAddresses' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'token="'"${token}"'"' \
--data-urlencode 'addresses={
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
' \
--data-urlencode 'f=json'