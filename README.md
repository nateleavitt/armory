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
you must create a json oject with the keys of 'name' and 'keys' object. Keys will include an array of key
objects. These key objects will have a name and value for the keys.

Example: 
```json
   {
     "name":"production",
     "keys":[
       {
         "name":"api_key",
         "value":"123qwe123qwe"
       },
       {
         "name":"aws_location",
         "value":"aws.amazon.com"
       }
     ]
   }
```
config

UPDATE<br />
:app/:env/:key (params: 'val') = > updates key

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
