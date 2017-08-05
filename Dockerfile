FROM ruby
RUN gem install \
  sidekiq \
  redis \
  mongo \
  json \
  activesupport \
  sinatra
EXPOSE 1234/udp
