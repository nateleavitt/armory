FROM ruby:2.2.0

EXPOSE 5100

# Used for service discovery
ENV SERVICE_NAME armory

# clone the repo
ADD ./ /app/
WORKDIR /app
RUN bundle install

# expose port and start service
CMD ["bundle", "exec", "foreman", "start", "-d", "/app/", "-f", "/app/Procfile" ]
