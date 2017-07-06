FROM ruby
RUN gem install sidekiq redis mongo
EXPOSE 1234/udp
