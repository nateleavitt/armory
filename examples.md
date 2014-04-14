## Examples
#### Note - app/env should be substituted for your application and environment

POST to add key,gals
```
curl -v -H "Accept: application/json" -H "Content-type: application/json" 
-X POST -d '{"key1":"value1", "key2":"value2"}' http://localhost:4567/app/env
```

UPDATE to update key,val
```
curl -v -H "Accept:application/json" -H "Content-type: application/json" 
-X PUT -d '{"val":"newkey1.2"}' http://localhost:4567/customerhub/development/key1
```
