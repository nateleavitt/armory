# base image
FROM ruby:2.1.5

# clone the repo
RUN git clone -b vagrant https://github.com/nateleavitt/figr-service.git /app/
WORKDIR /app
RUN bundle install

# expose port and start service
EXPOSE 4567
CMD ["bundle", "exec", "foreman", "start", "-d", "/app/", "-f", "/app/Procfile", "-p", "4567"]
