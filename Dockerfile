FROM ruby
RUN gem install \
  redis \
  mongo \
  json \
  activesupport \
  sinatra \
  bunny
