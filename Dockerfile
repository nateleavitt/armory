FROM infusionsoft/ubuntu-base
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
RUN /bin/bash -l -c rvm requirements
RUN /bin/bash -l -c rvm install 2.1.5
RUN /bin/bash -l -c gem update --system
RUN /bin/bash -l -c gem install bundler --no-ri --no-rdoc

RUN git clone 
RUN bundle install

EXPOSE 4567
CMD ["/usr/local/bin/foreman","start","-d","/root/sinatra"]
