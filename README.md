# CouchDB with geospatial index

## Usage
```
docker run -d kontrollanten/couchdb-hastings
```

## Run smoke tests
```
docker exec -w /couchdb/src/hastings/sample -t $(docker ps -q -f ancestor=kontrollanten/couchdb-hastings) python loader.py
<bound method Response.json of <Response [200]>>
```
