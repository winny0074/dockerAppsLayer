#!/bin/bash

JRE_HOME=/usr/java/default
JAVA_HOME=/usr/java
JAVA_OPTS="-Xmx800m -Xms1024m"
export CATALINA_BASE=pl_catalina_base

if [[ -z $1 ]]; then
   echo 'you should specify the action:[start|stop|restart]'
   exit 0
fi

source /etc/profile.d/tomcat_home_env  #load catalina_home variable
bash $CATALINA_HOME/bin/catalina.sh $1
