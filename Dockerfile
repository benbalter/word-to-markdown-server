FROM ruby:3.2.2

ENV PORT=80
ENV RACK_ENV=production
ENV BETA_SERVER="https://beta.word2md.com"

EXPOSE ${PORT}
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

RUN apt-get update

RUN apt update && apt upgrade
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:libreoffice/ppa -y
RUN apt-get install -y --no-install-recommends libreoffice-writer

COPY Gemfile Gemfile.lock ./
RUN bundle config set --local without 'development test'
RUN bundle install

COPY public/ ./public/
COPY views/ ./views/
COPY docs/ ./docs/
COPY config.ru puma.rb server.rb Procfile ./

CMD ["bundle", "exec", "puma", "-C", "puma.rb"]
