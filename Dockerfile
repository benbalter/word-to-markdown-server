FROM ruby:3.0

ENV PORT=80
EXPOSE ${PORT}
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

RUN apt-get update

# Libre libreoffice
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:libreoffice/ppa
RUN apt-get install -y --no-install-recommends libreoffice-writer

RUN soffice --version

COPY Gemfile Gemfile.lock ./
RUN bundle config --local build.sassc --disable-march-tune-native
RUN bundle install

COPY . .

CMD ["bundle", "exec", "puma", "-C", "puma.rb"]
