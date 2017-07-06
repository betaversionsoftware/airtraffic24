FROM ruby
RUN gem install sidekiq redis
EXPOSE 1234/udp
