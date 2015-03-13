## ARMORY - Central Config store for ETCD
This is an **experimental** config project.  The idea is that this will
be used for a basic config management service and stored in etcd to gain
the benefits of redundancy and reliability that etcd brings. This can be
used as a central config for many services


REST

GET<br />
:app/:env = > will produce full json config<br />
:app/:env/:key => will produce json value for given key

POST<br />
:app/:env 
when creating new keys you post them as a json object like the
following:
`{"api_key":"123qwe123qwe"}`

Example: 
```json
   {
    "staging": {
      "api_key":"123qwe123qwe",
      "aws_location":"aws.amazon.com"
    },
    "production": {
      "api_key":"123qwe123qwe",
      "aws_location":"aws.amazon.com"
    }
   }
```
config

UPDATE<br />
:app/:env/:key 
json to update a key should be sent as

`{"value":"value_of_key"}`

**All data will be stored using ETCD**

### Requirements
1. Bundler `gem install bundler`
2. ETCD - https://github.com/coreos/etcd

### Installation
```bash
#Download source
git clone git@github.com:nateleavitt/armory.git
#Install requirements
bundle install
```

### Start Service
```ruby
#Start web server
ruby armory.rb
```

### Todo's
1. Add ACL
2. Create a CLI for Armory

### Examples for REST calls
[Examples](https://github.com/nateleavitt/armory-service/blob/master/examples.md)
