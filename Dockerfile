ARG IMAGE=intersystemsdc/iris-community:2020.3.0.221.0-zpm
ARG IMAGE=intersystemsdc/iris-community:2020.4.0.524.0-zpm
ARG IMAGE=intersystemsdc/iris-community
ARG IMAGE=intersystemsdc/iris-community:2021.1.0.215.3-zpm
ARG IMAGE=intersystems/irishealth:2020.1.0.215.0.20737
FROM $IMAGE
ENV _HTTPD_DIR /etc/apache2
USER root   

# Install GateWay 
RUN apt-get update 

RUN apt-get install -y apache2 debconf-utils sudo && a2enmod ssl && \
/bin/echo -e $ISC_PACKAGE_MGRUSER\\tALL=\(ALL\)\\tNOPASSWD: ALL >> /etc/sudoers &&\
sudo -u $ISC_PACKAGE_MGRUSER sudo echo enabled passwordless sudo-ing for $ISC_PACKAGE_MGRUSER

# Generate self signed certificate
RUN echo '* libraries/restart-without-asking boolean true' | debconf-set-selections && apt-get install -y openssl 
RUN mkdir $_HTTPD_DIR/ssl && openssl req -x509 -nodes -days 1 -newkey rsa:2048 -subj /CN=* -keyout $_HTTPD_DIR/ssl/server.key -out $_HTTPD_DIR/ssl/server.crt

RUN apt-get clean 

#Enable CSPGateway
COPY ./cspgateway/ /opt/cspgateway/bin
RUN cp /usr/irissys/csp/bin/CSPa24.so /opt/cspgateway/bin
RUN cp /usr/irissys/csp/bin/CSPa24Sys.so /opt/cspgateway/bin
RUN cp /usr/irissys/csp/bin/libz.so /opt/cspgateway/bin

RUN a2enmod ssl 

COPY httpd-csp.conf $_HTTPD_DIR/sites-available

RUN a2ensite httpd-csp && update-rc.d apache2 enable

WORKDIR /opt/irisapp
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp
USER ${ISC_PACKAGE_MGRUSER}

COPY --chown=${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} Installer.cls .
COPY --chown=${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} src src
COPY --chown=${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} module.xml .
COPY --chown=${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} i2020d1.script /tmp/iris.script

# Install 
# $ISC_PACKAGE_INSTANCENAME name of the iris instance on docker, default IRIS, valued by InterSystems
# First start the instance quietly
RUN sudo service apache2 start && iris start $ISC_PACKAGE_INSTANCENAME quietly \
    && iris session IRIS < /tmp/iris.script \
    && iris stop $ISC_PACKAGE_INSTANCENAME quietly && sudo service apache2 stop
