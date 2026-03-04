FROM ruby:3.3.1-slim

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

COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

COPY . .

EXPOSE 3000

CMD ["bash", "-c", "bin/rails assets:precompile && bin/rails db:prepare && bin/rails server -b 0.0.0.0 -p 3000"]
