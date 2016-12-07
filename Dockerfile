# Base image 
FROM ruby:2.3.1

ARG buildnum=none
ARG traviscommit=none
ARG travisjobid=none
ARG author=none
ARG dockerimage=none
ARG date=none

MAINTAINER jeremy.pumphrey@nih.gov

RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

ENV INSTALL_PATH /usr/app
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

ENV RAILS_ENV test

# Install gems 
COPY Gemfile $INSTALL_PATH/
RUN gem install bundler && bundle install

COPY . . 
RUN ruby -v; rails -v; bundler -v; gem -v
RUN pwd;ls -alt $INSTALL_PATH

#Add a file with build number and date for /version to use
RUN echo "TravisBuild#:" > $INSTALL_PATH/build_number.html 	&& \ 
	echo $buildnum >> $INSTALL_PATH/build_number.html	&& \ 
	echo "Commit#:" >> $INSTALL_PATH/build_number.html 	&& \ 
	echo $traviscommit >> $INSTALL_PATH/build_number.html 	&& \ 
	echo "TravisJob#:" >> $INSTALL_PATH/build_number.html 	&& \ 
	echo $travisjobid >> $INSTALL_PATH/build_number.html 	&& \ 
	echo "Author:" >> $INSTALL_PATH/build_number.html	&& \ 
	echo $author >> $INSTALL_PATH/build_number.html		&& \ 
	echo "Build Time:" >> $INSTALL_PATH/build_number.html 	&& \ 
	echo $date >> $INSTALL_PATH/build_number.html		&& \ 
	echo "Docker:" >> $INSTALL_PATH/build_number.html 	&& \ 
	echo $dockerimage:$date >> $INSTALL_PATH/build_number.html
RUN cat $INSTALL_PATH/build_number.html

#Insert script to change localhost to docker-compose names
ADD https://raw.githubusercontent.com/CBIIT/match-docker/master/docker-compose-env.sh .
RUN chmod 755 docker-compose-env.sh && ls -alt $INSTALL_PATH

# Default command 
CMD ./docker-compose-env.sh && rails server --binding 0.0.0.0
#CMD ["rails", "server", "--binding", "0.0.0.0"]
