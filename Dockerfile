#
# jpodeszwik/rpi-java Dockerfile
#
 
FROM sdhibit/rpi-raspbian 


RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y g++ build-essential libxslt1-dev libxml2-dev \
  python-dev libmysqlclient-dev redis-server mysql-server nginx

  # Install git 1.7.6+
RUN apt-get -y install python-software-properties
RUN apt-get install -y git

RUN apt-get install -y wget curl

RUN useradd --create-home barkeep
  # Install ruby 1.9.3-p194

ADD install_ruby.sh /bin/
RUN su - barkeep -c "/bin/install_ruby.sh"


RUN apt-get install -y ruby-eventmachine
ADD install_barkeep.sh /bin/
RUN su - barkeep -c "/bin/install_barkeep.sh"

  # Configure a reverse proxy webserver (nginx) to Barkeep
RUN   rm /etc/nginx/sites-enabled/default && \
    cp ~/barkeep/config/system_setup_files/nginx_site.prod.conf /etc/nginx/sites-enabled/barkeep

  # Create database and run migrations
RUN   mysqladmin -u root --password='' create barkeep && \
    cd ~/barkeep && ./script/run_migrations.rb

  # Create upstart scripts
RUN   cd ~/barkeep &&\
    foreman export upstart upstart_scripts -a barkeep -l /var/log/barkeep -u $USER -f Procfile &&\
    mv upstart_scripts/* /etc/init &&\
    cp environment.prod.rb environment.rb &&\
    cp environment.prod.sh environment.sh

RUN start barkeep

