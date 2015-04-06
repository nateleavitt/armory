## Documentation - Armory
This is the API documentation page for Armory, our central config
service. The following describe the resources that make up the v1 API.

### Overview
Here is the list of resources you will be able to access:

* [Service](#service) - This is the name of the service you are wanting to set/get
config for (ie.. usually your Github repo name
* [Environment](#envo) - This allows you to have environment scope for your
config. Some examples would be 'testing', 'staging', 'production'.
* [Config](#config) - This will return a map of key:values for the given service
and environment
* [Key](#key) - This is the value of an individual setting


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

Important URL values
* :service = is the name of the service
* :env = is the name of the environment for the given service
* :key = is the name of the key for the given environment and service


#### **<style id="service">Service</style>**

* `GET /services` - will return an array of all services currently setup in Armory

```json
Response
Status: 200

{
 "result":["goldfish", "customerhub"]
}
```


* `POST /services` - will create a new service namespace in Armory

```json
Example
Required param: value

{
  "value":"goldfish"
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

```json
Example

{
  "result":["testing", "staging"]
}
```

#### **<style id="envo">Environments</style>**

* `POST /services/:service/envs` - will create a new env for the given service

```json
Example
Required param: value

{
  "value":"production"
}
```
```json
Response
Status: 200

{
  "result":"production"
}
```

#### **<style id="config">Config</style>**

* `GET /services/:service/envs/:env/config` - this will return the entire map of config for the given service and environment

```json
Response
Status: 200

{
  "result":{"api_key":"123123123123","username":"johndoe"}
}
```

* `POST /services/:service/envs/:env/config` - this allows you to create new keys:values of config settings

```json
Example

{
  "api_url":"http://test.com","api_password":"123qwe"
}
```

```json
Response
Status: 200

{
  "result":{"api_url":"http://test.com","api_password":"123qwe"}
}
```

#### **<style id="key">Key</style>**

* `GET /services/:service/envs/:env/config/:key` - will return the value of the given key

```json
Response
Status: 200

{
  "result":"123123123123"
}
```

* `PUT /services/:service/envs/:env/config/:key` - will allow you to update the given key

```json
Example
Required param: value

{
  "value":"987987987987"
}
```

```json
Response
Status: 200

{
  "result":"987987987987"
}
```

### Errors

All errors will respond back with a json object in the following format:

```json
Error Response

{
  "result":"error", "message":"Key not found!"
}
```
