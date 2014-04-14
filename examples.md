### Examples
===

POST to add key,gals
`curl -v -H "Accept: application/json" -H "Content-type:
application/json" -X POST -d '{"key1":"value1", "key2":"value2"}'
http://localhost:4567/customerhub/development`

UPDATE to update key,val
`curl -v -H "Accept:application/json" -H "Content-type:
application/json" -X UPDATE -d '{"key1":"newkey1"}'
http://localhost:4567/customerhub/development`
