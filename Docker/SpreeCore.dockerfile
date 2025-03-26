
FROM ruby:3.1.0-alpine


RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    nodejs \
    yarn \
    bash \
    git \
    tzdata


WORKDIR /app


COPY Gemfile Gemfile.lock ./


RUN bundle install


COPY . .


RUN RAILS_ENV=production bundle exec rake assets:precompile


EXPOSE 3000



CMD ["rails", "server", "-b", "0.0.0.0"]
