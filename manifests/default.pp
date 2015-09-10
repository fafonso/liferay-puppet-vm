#################################
##       Configurations        ##
#################################

class { 'vmbuilder' : 
  ############### DB config 
  #db_user              => "liferay",
  #db_password          => "D3P4ssw0rd",
  #db_name              => "lportal",

  ############### To ensure the clock is synchronized 
  #timzone              => "Europe/Dublin",

  ############### Liferay configuration 
  #liferay_user         => "liferay",
  #liferay_group        => "www",
  #install_path         => "/opt/liferay",

  ############### Liferay Databse to use 
  #Possibel  values are: mysql, postgresql
  #Default to mysql
  #liferay_db           => "postgresql",

  ############### Install Liferay from local archive 
  #liferay_zip_filename => "liferay-portal-tomcat-6.2-ee-sp11-20150407182402908.zip",
  #Liferay folder name inside zip archive
  #liferay_folder       => "liferay-portal-6.2-ee-sp11",

  ################ Cluster configuration 
  #Default to false
  #liferay_cluster      => true,

  ############### Tomcat info 
  ############### (in a cluster configuration, each of the nodes will get this JVM memory parameters)
  #xmx                  => "1024",
  #permsize             => "256",

  ############### Enable firewall. false by default
  #use_firewall         => true,

  ############### Java distribution to be used
  #Default oracle
  #java_distribution    => "openjdk",

  ############### SOLR
  #Default should be 3.5.0 for CE edition
  #solr_distribution    => "3.5.0", 

  ############### Mail Server
  #mail_server          => "mailcatcher",

  ############### Http server
  #By default will not install a http server
  #possible values = apache2 | nginx
  #httpserver           => "apache2",
}






