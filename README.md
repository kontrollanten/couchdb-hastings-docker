# CouchDB with geospatial index

## Usage
```
git clone git@github.com:kontrollanten/couchdb-hastings-docker.git
cd couchdb-hastings-docker
docker build -t couchdb-hastings
docker run -d couchdb-hastings
```

## Run smoke tests
```
docker exec -w /couchdb/src/hastings/sample -t $(docker ps -q -f ancestor=couchdb-hastings) python loader.py
<bound method Response.json of <Response [200]>>
```
