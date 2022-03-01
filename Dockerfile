FROM ruby:3.0.3

RUN apt-get update \
  && apt-get install -y curl apt-transport-https wget \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install -y yarn

RUN apt-get update -qq \
  && apt-get install -y build-essential libpq-dev nodejs yarn default-mysql-client graphviz
RUN mkdir /trade
WORKDIR /trade
COPY Gemfile /trade/Gemfile
COPY Gemfile.lock /trade/Gemfile.lock
RUN bundle install
COPY . /trade

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image.
CMD ["rails", "server", "-b", "0.0.0.0"]
