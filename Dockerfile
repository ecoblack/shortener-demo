FROM ruby:2.7.2

RUN apt-get update -qq \
  && apt-get install -y \
    build-essential \
    libpq-dev \
    cron \
    nodejs \
    vim \
    postgresql-client \
    postgresql-client-common

RUN gem install bundler:2.4.13

ENV APP_HOME /horizoom-url-api
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY Gemfile /$APP_HOME/Gemfile
COPY Gemfile.lock /$APP_HOME/Gemfile.lock

# nokogiri  | ERROR: It looks like you're trying to use Nokogiri as a precompiled native gem on a system
#           app_1    |        with an unsupported version of glibc.
#           app_1    |
#           app_1    |   /lib/aarch64-linux-gnu/libm.so.6: version `GLIBC_2.29' not found (required by /bundle/vendor/ruby/2.7.0/gems/nokogiri-1.15.3-aarch64-linux/lib/nokogiri/2.7/nokogiri.so) - /bundle/vendor/ruby/2.7.0/gems/nokogiri-1.15.3-aarch64-linux/lib/nokogiri/2.7/nokogiri.s
RUN bundle config set force_ruby_platform true

COPY . /$APP_HOME
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]
