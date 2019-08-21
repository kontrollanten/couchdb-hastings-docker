# CouchDB with geospatial index
Use CouchDB with geojson and spatial indexes.

## Setup
```
docker run -d kontrollanten/couchdb-hastings
```

## Run smoke tests
```
docker exec -w /couchdb/src/hastings/sample -t $(docker ps -q -f ancestor=kontrollanten/couchdb-hastings) python loader.py
<bound method Response.json of <Response [200]>>
```
## Usage

### Create your geo json database
```
curl -X POST localhost:5984/shelters
```

### Import some geo data
```
curl -X POST -H "Content-Type: application/json" -d '
{
  "geometry": {
    "type": "Point",
    "coordinates": [59.37131802330678, 18.16711393757631]
  },
  "properties": {
    "name": "Secret room",
    "address": "Underground"
  }
}
' localhost:5984/shelters
```

### Create a spatial index
```
curl -X POST -H "Content-Type: application/json" -d '
{
  "_id": "_design/SpatialView",
  "st_indexes" : {
    "shelter_positions": {
      "index" : "function(doc) { if (doc.geometry) { st_index(doc.geometry); } }"
    }
  }
}' localhost:5984/shelters
```

### Query geo data
```
curl -X GET localhost:5984/shelters/_design/SpatialView/_geo/shelter_positions?bbox=59.26,18.02,59.49,18.32

{
  "bookmark": "g1AAAALDeJyNkrtKA0EUQJdoIWojpEll8APCPDKvQjcg2S8QK1HnaQhRC7HWJlWwMQHL-Ak2ahkFwTYfIJjGxs4ijQjrjUGx2g0D82CGw-EwrSiKFhpzLlqxx6e24UwNE1FBMHALrgpH8zBH57CkadpvNgqHcCzrIFmVwEvDPZcSca6qgmBDkeAcIZXEvZPSwdLjOINsajCbPcD-UZGilmlCtPXSBsUlogQzIokVTBidxN3BzVq__Zbr-zD1ff0lU8KQpwhEreOws4Zq7CR1PhBDlUjizu6mYBcbWb77E9-zmXwDVs6ZJL5sf-7c17-yqOUJNZ6JqhXCtAoVxi-dUnE5t8JoWiHNr6CCdT997yrF295zBllHZvUf0gXvidETsFeUcW2UQBBVq8AcDfARulvbT8OrxVzZ66nsIF9WBOEUA_LwY330Xm9-AyjxyZs",
  "rows": [
    {
      "id": "1ef78a34dacc85eee8657e625286ec3e",
      "rev": "1-2d5ed349b3dda7973751532a0f7cfb1e",
      "geometry": {
        "type": "Point",
        "coordinates": [
          59.37131802330678,
          18.16711393757631
        ]
      }
    }
  ]
}
```
