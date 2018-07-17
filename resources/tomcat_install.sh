#!/bin/bash

#--------------------------------------
# This script will setup multi tomcat instance
# - CATELINA_HOME = /srv/tomcat/current
# - CATELINA_BASE = /opt/tomcat
#--------------------------------------
# download tomcat 

server_path='/srv/tomcat'
ln='current'
CATELINA_HOME=$server_path/$ln
CATELINA_BASE=/opt/tomcat
echo "CATELINA_HOME : "$CATELINA_HOME 

if ! [ -d $CATELINA_HOME ]; then

  echo "create CATELINA_HOME"
  tmp='/temp'
  version='8.5.32'
  server='apache-tomcat'
  if ! [ -d $tmp ]; then
    mkdir $tmp
  fi
  
  cd $tmp

  #download tomcat 
  mkdir -p $server_path 
  echo 'download tomcat form' http://apache.mirror.globo.tech/tomcat/tomcat-8/v$version/bin/$server-$version.zip
  curl -o $tmp/$server-$version.zip  http://apache.mirror.globo.tech/tomcat/tomcat-8/v$version/bin/$server-$version.zip && ls -la && mv $server-$version.zip $server_path 
  unzip $server_path/$server-$version.zip -d $server_path/$server-$version 
  ln -s $server_path/$server-$version $CATELINA_HOME 
  mv $CATELINA_HOME/$server-$version/* $CATELINA_HOME 
  rm -rf $CATELINA_HOME/$server-$version

  cd ..
  rm -rf $tmp  
  rm -rf $server_path/$server-$version.zip 

fi

# add a tomcat instance

args=("$@") #get arguments passed

if [ ${#args[@]} -eq 0 ]; then
   #if no argument set, ask one or set a default
   read -p 'Give your instance name :' tomcat_instance
   if [ -z $tomcat_instance ]; then
       tomcat_instance=abcapp
   fi
   args[0]=$tomcat_instance
fi

touch /tmp/out.log
echo "Number of tomcat(s) to create: ${#args[@]} : (${args[@]})"
argNbr=${#args[@]}
for name in ${args[@]}
do
   tomcat_instance=$name
   echo "-- start creating "$tomcat_instance" tomcat instance ---"
   tmp=$CATELINA_BASE/$tomcat_instance
   if [ -d $tmp ]; then
      echo 'The instance : '$tmp' already exist'
      exit 1
   fi


   mkdir -p $tmp
   mkdir $tmp/conf 
   mkdir $tmp/logs 
   mkdir $tmp/temp 
   mkdir $tmp/webapps 
   mkdir $tmp/work

   #cp $CATELINA_HOME/conf/server.xml $tmp/conf/
   cp /abcData/scripts/server.xml $tmp/conf/
   cp $CATELINA_HOME/conf/web.xml $tmp/conf/
   cp $CATELINA_HOME/conf/tomcat-users.xml $tmp/conf/
   cp -r $CATELINA_HOME/conf/Catalina $tmp/conf/

   #cp  $CATELINA_HOME/logs/catalina.out $CATELINA_BASE/$tomcat_instance/logs/catalina.out
   touch $tmp/logs/catalina.out
   cp -r $CATELINA_HOME/webapps/ROOT $tmp/webapps/
   cp -r $CATELINA_HOME/webapps/host-manager $tmp/webapps/
   cp -r $CATELINA_HOME/webapps/manager $tmp/webapps/


   #create service file
   cp /abcData/scripts/tomcat_service.sh /etc/init.d/tomcat_$tomcat_instance
   echo 'Create service : '/etc/init.d/tomcat_$tomcat_instance
   sed -irne "s@pl_catalina_base@$tmp@g" /etc/init.d/tomcat_$tomcat_instance && echo 'your service was created successfully :).\n !!! Don't forget to change your instant's port number in :'$tmp/conf/server.xml

   port_shutdown=800"$((argNbr-1))"
   port_http=808"$((argNbr-1))"
   port_ajp=900"$((argNbr-1))"
   
   echo port_shutdown : $port_shutdown
   echo port_http : $port_http
   echo port_ajp : $port_ajp

   sed -irne "s@port_shutdown@$port_shutdown@g" $tmp/conf/server.xml
   sed -irne "s@port_http@$port_http@g" $tmp/conf/server.xml
   sed -irne "s@port_ajp@$port_ajp@g" $tmp/conf/server.xml
   
   argNbr=$((argNbr-1))

   echo "-- "$name" tomcat creation ended ---"
done
