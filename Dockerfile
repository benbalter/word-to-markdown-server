FROM ruby:2.5

RUN bundle config --global frozen 1

WORKDIR /usr/src/app

RUN apt-get update

# Libre libreoffice
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:libreoffice/ppa
RUN apt-get install -y --no-install-recommends \
    libreoffice-writer \
    libxinerama-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libxdamage-dev \
    libsm6 \
    libice6

RUN soffice --version

# Nokogiri
ENV NOKOGIRI_USE_SYSTEM_LIBRARIES 1
RUN apt-get install -y libxml2 libxml2-dev libxslt1-dev

# Needed for ExecJS
RUN apt-get install -y nodejs

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 5000

CMD ["bundle", "exec", "rackup", "config.ru", "--host", "0.0.0.0", "--port", "5000"]
