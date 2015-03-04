# base image
FROM ruby:2.2.0

# clone the repo
RUN git clone https://github.com/nateleavitt/armory.git /app/
WORKDIR /app
RUN bundle install

# expose port and start service
EXPOSE 4567
CMD ["bundle", "exec", "foreman", "start", "-d", "/app/", "-f", "/app/Procfile", "-p", "4567"]
