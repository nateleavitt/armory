# base image
FROM infusionsoft/ubuntu-base

# install needed libs
RUN apt-get update && apt-get install -y \
  build-essential \
  zlib1g-dev \
  libssl-dev \
  libreadline-dev \
  libyaml-dev \
  libxml2-dev \
  libxslt-dev \
  curl \
  git-core

# install RVM, Ruby, and Bundler
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN curl -L https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.1.5"
RUN /bin/bash -l -c "rvm rubygems current"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

# clone the repo
RUN /bin/bash -l -c "git clone -b vagrant https://github.com/nateleavitt/figr-service.git /app/"
RUN /bin/bash -l -c "cd /app; bundle install"

# expose port and start service
EXPOSE 4567
CMD ["/usr/local/bin/foreman","start","-d","/root/sinatra"]
