## Documentation - Armory
This is the API documentation page for Armory, our central config
service. The following describe the resources that make up the v1 API.

### Overview
Here is the list of resources you will be able to access:

1. Service - This is the name of the service you are wanting to set/get
config for (ie.. usually your Github repo name
2. Environment - This allows you to have environment scope for your
config. Some examples would be 'testing', 'staging', 'production'.
3. Keys - This is the name and value of an individual setting. This is
stored in a key => value format.


All calls should be made using the following HTTP verbs: GET, POST, PUT,
DELETE and should be made requesting json in the `application/json`
header in your client.

1. GET is to get a resource
2. POST is to create a resource
3. PUT is to update a resource
4. DELETE is to delete the resource

### Current Version
Currently the API version is specified in the url of the api request. The
current versions is `v1` and should be requested as
`https://url-of-service.com/v1`. 

### Endpoints

* Important URL values
:service = is the name of the service
:env = is the name of the environment for the given service
:key = is the name of the key for the given environment and service


#### **Service**

* `GET /services` - will return an array of all services currently setup in Armory

```json
Response
Status: 200

{
 "result":["goldfish", "customerhub"]
}
```


* `POST /services` - will create a new service namespace in Armory
Required param: name

```json
Example
{ 
  "result":"goldfish" 
}
```
```json
Response
Status: 200

{
  "result":"goldfish"
}
```

* `GET /services/:service/envs` - will get return an array of all environments setup for the given service

Example
```json
{
  "result":["testing", "staging"]
}
```

#### **Environments**

* `POST /services/:service/envs` - will create a new env for the given
service

Required param: name

```json
Example
{
  "name":"production"
}
```
```json
Response
Status: 200

{
  "result":"production"
}
```
