
FROM ruby:3.1.0-alpine


RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    nodejs \
    yarn \
    bash \
    git \
    tzdata \
    libxml2-dev \
    libxslt-dev


WORKDIR /app


COPY Gemfile Gemfile.lock ./


RUN bundle install


COPY . .


ENV PAYMENT_GATEWAY_API_KEY=<your_payment_gateway_api_key>
ENV PAYMENT_GATEWAY_SECRET_KEY=<your_payment_gateway_secret_key>


RUN RAILS_ENV=production bundle exec rake assets:precompile


EXPOSE 3000


CMD ["rails", "server", "-b", "0.0.0.0"]
