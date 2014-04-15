## ELVIS
This is an **experimental** config project.  The idea is that this will
be used for a basic config management service.

REST
---

GET<br />
:app/:env = > will produce full json config<br />
:app/:env/:key => will produce json value for given key

POST<br />
:app/:env (params: {'key1':'val1', 'key2':'val2'}) => adds key/vals to
config

UPDATE<br />
:app/:env/:key (params: 'val') = > updates key

**All data will be stored using Redis**

### Requirements
1. Bundler `gem install bundler`
2. Redis ([instructions here](http://redis.io/topics/quickstart)) up and running. Run `redis-server` once installed

### Installation
```ruby
#Install requirements
bundle install
```

### Start Service
```ruby
#Start web server
ruby elvis.rb
```

### Todo's
1. Add authentication
2. Add multiple 'store' options (only Redis right now)
3. Add development, test, and production settings

### Examples for REST calls
[Examples](https://github.com/nateleavitt/elvis/blob/master/examples.md)
