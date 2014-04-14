## ELVIS
This is an experimentational config project.  The idea is that this will
be used for a basic config management service.

REST

GET :app/:env = > will produce full json config
GET :app/:env/:key => will produce json value for given key<br />

POST :app/:env (params: {'key1':'val1', 'key2':'val2'}) => creates :key for all :envs<br />

UPDATE :app/:env/:key (params: 'val') = > updates key

All data will be stored using Redis

### Requirements
You need to have Redis installed ([instructions here](http://redis.io/topics/quickstart))

### Installation
```ruby
#Install requirements
bundle install
```

### Start Service
```ruby
#Start web server
ruby elvis.rb

#Start Redis
```
redis-server

### Examples
[Examples](https://github.com/nateleavitt/elvis/blob/master/examples.md)
