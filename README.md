# gnadeAppsLayer
This docker builds an image with multi tomcat instances.  


#
# OVERVIEW
# 

This docker allows you to create one or more tomcat instances. By default it will reacte two(tomcat-gnade1, tomcat-gnade2). You can add or change these instances.

# FILES STRUCTURE
 - Dockerfile:

   This dockerfile is configured to receive tomcat instances names through arguments(agrs). By default, only two args were configured. You can either add, remove or change names. 
Therefor, docker-compe.yml will be providing these args values. The args names should match in both docker-compse.yml and this Dockerfile 
 
 - resources:

   -- server.xml : it is a conf/server.xml template used to set proper tomcat port for each created instance.

   -- tomcat_home_env : define an ENV for catalina_home

   -- tomcat_install.sh : tomcat installation script

   -- tomcat_service.sh : tomcat service init script


