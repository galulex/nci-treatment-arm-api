# Base image 
FROM ruby:2.2.4

ENV RAILS_VERSION 4.2.5
ENV HOME /home/rails/myapp 
WORKDIR $HOME 

# see update.sh for why all "apt-get install"s have to stay as one long line
RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*

# see http://guides.rubyonrails.org/command_line.html#rails-dbconsole
#RUN apt-get update && apt-get install -y mysql-client postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*

# Install gems 
ADD Gemfile* $HOME/ 
RUN bundle install 

# Add the app code 
ADD . $HOME 

RUN gem install rails --version "$RAILS_VERSION"

# Default command 
CMD ["rails", "server", "--binding", "0.0.0.0"]
