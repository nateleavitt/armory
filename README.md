## ELVIS
===
This is an experimentational config project.  The idea is that this will
be used for a basic config management service.

REST

GET :app/:env/:key => will produce json/yaml formatted value
GET :app/:env = > will produce full json/yaml config

POST :app/:env (params: key: :value) => creates :key for all :envs
POST :app (params: env: :value) = > creates a new :env

All data will be stored using Redis
