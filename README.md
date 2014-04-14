## ELVIS
This is an experimentational config project.  The idea is that this will
be used for a basic config management service.

REST

GET :app/:env/:key => will produce json/yaml formatted value<br />
GET :app/:env = > will produce full json/yaml config

POST :app/:env (params: key: :value) => creates :key for all :envs<br />
POST :app (params: env: :value) = > creates a new :env

All data will be stored using Redis

### Installation
`#Install requirements
bundle install`

### Start Service
`#Start server
ruby elvis.rb`

### Examples
[Examples](https://github.com/nateleavitt/elvis/blob/master/examples.md)
