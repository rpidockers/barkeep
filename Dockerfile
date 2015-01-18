#
# jpodeszwik/rpi-java Dockerfile
#
 
FROM sdhibit/rpi-raspbian 

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y g++ build-essential libxslt1-dev libxml2-dev \
  python-dev libmysqlclient-dev redis-server mysql-server nginx

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

# Create database and run migrations
RUN /etc/init.d/mysql start && \
    mysqladmin -u root --password='' create barkeep && \
    su - barkeep -c ". ~/.profile && cd barkeep && ./script/run_migrations.rb" && \
    /etc/init.d/mysql stop

# Create upstart scripts
RUN cd ~barkeep/barkeep &&\
    cp environment.prod.rb environment.rb && \
    cp environment.prod.sh environment.sh

RUN apt-get install -y nodejs

RUN apt-get install -y ca-certificates

RUN apt-get install -y locales && \
    sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen && \
    locale-gen && \
    echo 'export LC_ALL=en_US.UTF-8' >> ~barkeep/.profile

ADD run.sh /bin/

CMD run.sh

