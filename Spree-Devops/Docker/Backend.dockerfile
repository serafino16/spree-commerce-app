
FROM ruby:3.0


RUN apt-get update -qq && apt-get install -y nodejs postgresql-client


WORKDIR /app

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./


RUN bundle install


COPY . .

# Precompile assets (for production environment)
RUN RAILS_ENV=production bundle exec rake assets:precompile


EXPOSE 3000

# Start the Rails server
CMD ["rails", "s", "-b", "0.0.0.0"]
