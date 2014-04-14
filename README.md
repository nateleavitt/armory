## ELVIS
This is an experimentational config project.  The idea is that this will
be used for a basic config management service.

REST

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
You need to have Redis installed ([instructions here](http://redis.io/topics/quickstart)) and running

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

### Examples
[Examples](https://github.com/nateleavitt/elvis/blob/master/examples.md)
