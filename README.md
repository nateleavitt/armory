## ARMORY - Central Config store for ETCD
This is an **experimental** config project.  The idea is that this will
be used for a basic config management service and stored in etcd to gain
the benefits of redundancy and reliability that etcd brings. This can be
used as a central config for many services


### Documentation
[click here for docs](https://github.com/nateleavitt/armory/blob/master/docs.md)


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

