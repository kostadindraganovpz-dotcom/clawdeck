FROM ruby:3.3.1-slim

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  npm \
  git \
  curl \
  && npm install -g yarn \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Copy app
COPY . .

# Precompile assets
RUN SECRET_KEY_BASE=placeholder RAILS_ENV=production bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bash", "-c", "bin/rails db:prepare && bin/rails server -b 0.0.0.0 -p 3000"]
