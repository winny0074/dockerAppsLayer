######################################################################################
# Dockerfile to build ABC container images. It will run multiple tomcats
# Based on Ubuntu
######################################################################################
# Set the base image to Ubuntu
FROM ubuntu

# File Author / Maintainer
MAINTAINER Example Onlyme

# Create data folder and mount it under volume default path in host
RUN mkdir -p /abcData/scripts
VOLUME /volume/abcData

# Define arguments
ARG app1
ARG app2
ARG port1
ARG port2

# Add tomcat_install script file in container
COPY resources/tomcat_install.sh /abcData/scripts
COPY resources/tomcat_service.sh /abcData/scripts 
COPY resources/server.xml /abcData/scripts 
COPY resources/tomcat_home_env /etc/profile.d/

# update the repository source and install important package
RUN apt-get update && apt-get \
install -y curl && \
apt-get install -y zip unzip && \
apt-get install -y net-tools

# install jdk8
RUN apt-get install -y software-properties-common 
RUN add-apt-repository ppa:webupd8team/java && apt-get update 
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections 
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections 
RUN apt-get install -y oracle-java8-installer


#Run tomcat installation script and create tomcat instances
#The names after tomcat_install.sh script are names of tomcat instance that you want to create
#You can pass 0 or more name. If no name is set, the script will create a default tomcat: abcapo
RUN cd /abcData/scripts && ls -la && bash tomcat_install.sh app1 app2
#RUN ls -la

##################### INSTALLATION END #####################

# Expose tomcat http  port
# number of EXPOSE should be equal to the number of application
# e.g: as I have to tomcat abcinc1 and abcinc2, i have to EXPOSE two port
# the port numbe should increment starting from 0 (8080,8081)
#EXPOSE port1  
#EXPOSE port2

# Default port to execute the entrypoint (MongoDB)
#CMD ["--port 27017"]

#Start the server
#CMD ["/bin/sh","-c","echo welcom"]
