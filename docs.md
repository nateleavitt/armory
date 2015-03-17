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

#### **Service**

##### Create new service

```
POST /v1/
```
Example
```json
{ 
  "service":"goldfish" 
}
```
Response
```json
Status: 201 Created

{
  "service":"goldfish"
}
```
