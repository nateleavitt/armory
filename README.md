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
3. create a `.env` file with the following contents:

```yaml
DOCKER_HOST 127.0.0.1
ADMIN_USER admin # update this value
ADMIN_PASSWORD admin_password # update this value
```

### Installation
```bash
# Download source
git clone git@github.com:nateleavitt/armory.git
# Install requirements
bundle install
```

### Start Service

**Docker**

The provided Dockerfile will start up the service as a container

**Manual**

This service was created to be run with Docker on CoreOS. However you
can also manually run it locally on your machine. To do so, follow the
steps below:

```bash
# Start ETCD & Puma Server using foreman
foreman start
```

### Todo's
1. Add ACL
2. Create a CLI for Armory

