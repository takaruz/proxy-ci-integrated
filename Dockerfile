FROM php:5.6-apache

MAINTAINER Pongpat Poapetch <p.poapetch@gmail.com>

# Insert this line before "RUN apt-get update" to dynamically
# replace httpredir.debian.org with a single working domain
# in attempt to "prevent" the "Error reading from server" error.
# RUN sed -i "s/httpredir.debian.org/mirrors.tuna.tsinghua.edu.cn/" /etc/apt/sources.list

RUN echo "deb http://mirror.kku.ac.th/debian jessie main" > /etc/apt/sources.list
RUN echo "deb http://mirror.kku.ac.th/debian jessie-updates main" >> /etc/apt/sources.list
RUN echo "deb http://security.debian.org jessie/updates main" >> /etc/apt/sources.list

# for openjdk-8 src
RUN echo "deb http://ftp.de.debian.org/debian jessie-backports main" >> /etc/apt/sources.list

# Update library
RUN apt-get -y update

# Install require packages
RUN apt-get install -y libcurl4-openssl-dev
RUN apt-get install -y php5-curl php5-dev php5-mysql
RUN apt-get install -y vim wget unzip python git zip
RUN apt-get install -y openjdk-8-jre

# Install mongodb extension
# RUN pecl install mongodb

# Install php-extension (.so) from helper binary
RUN docker-php-ext-install curl && \
    docker-php-ext-install mbstring && \
    docker-php-ext-install tokenizer && \
    docker-php-ext-install zip
RUN docker-php-ext-install pdo && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install mysqli
    #docker-php-ext-enable mongodb

# Enable mod rewrite and ssl
RUN a2enmod rewrite && a2enmod ssl

# mod user www-data to id 1000 (fix bug on mac osx)
#RUN usermod -u 1000 www-data

# set terminal in container to xterm
RUN echo "export TERM=xterm" >> /root/.bashrc

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# install sonar-runner
RUN wget http://repo1.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist/2.4/sonar-runner-dist-2.4.zip -P /opt
RUN unzip /opt/sonar-runner-dist-2.4.zip -d /opt
RUN mv /opt/sonar-runner-2.4 /opt/sonar-runner

# expose port 80
EXPOSE 80
